//
//  MARK: - Beginning Info
//
//  SAMButtonBorderable.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 3/9/22.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

#if canImport(Cocoa)
import Cocoa
#endif

// Use #if os(macOS) before code that only applies to macOS. End with #endif.

#if os(macOS)

// MARK: - Colors

var SAMButtonBorderableNormalBackgroundColor: NSColor = .gray.withAlphaComponent(NSWorkspace.shared.accessibilityDisplayShouldIncreaseContrast ? 0.35 : 0.075)

var SAMButtonBorderableNormalContentColor: NSColor = .controlTextColor

var SAMButtonBorderableNormalHighlightColor: NSColor = SAMButtonBorderableNormalBackgroundColor.withAlphaComponent(0.1)

var SAMButtonBorderableDisabledBackgroundColor: NSColor = .gray.withAlphaComponent(0.025)

// MARK: - Custom Button Design - Protocol

/// Shares many `NSButton` and `NSPopUpButton` methods and properties, as well as custom SheftApps design-related methods and properties, with both `SAMButton` and `SAMPopup` to allow access in the `configureButtonDesign(for:)` global function.
protocol SAMButtonBorderable {
    
    // In a protocol, properties are declared with "get" or "get set" within curly braces, which determines whether objects adopting the protocol can get and set, or only get, the property's value. Protocol properties never have initial values--that's for the object(s) adopting (conforming to) the protocol to decide.
    /// The frame of the button.
    var frame: CGRect { get set }
    
    /// The bounds of the button.
    var bounds: CGRect { get }
    
    /// The cell that is used to render the button.
    var cell: NSCell? { get }
    
    /// Whether the button is enabled.
    var isEnabled: Bool { get set }
    
    /// Whether the button has a border.
    var isBordered: Bool { get set }
    
    /// Whether the button shows a border only when the mouse is hovered over it.
    var showsBorderOnlyWhileMouseInside: Bool { get set }

    /// Whether the button is currently showing a border.
    var isShowingBorder: Bool { get }

    /// The bezel color of the button.
    var bezelColor: NSColor? { get set }

    /// The window containing the button's view hierarchy.
    var window: NSWindow? { get }

    /// The color of the button's content.
    var contentTintColor: NSColor? { get set }
    
    /// The color of the button's highlight.
    var highlightColor: NSColor { get set }
    
    /// The color of the button's background.
    var backgroundColor: NSColor { get set }
    
    /// The image that is displayed on the button.
    var image: NSImage? { get set }

    /// The position of the button's image.
    var imagePosition: NSControl.ImagePosition { get set }

    /// The symbol configuration for buttons which use SF Symbols for their images.
    var symbolConfiguration: NSImage.SymbolConfiguration? { get set }

    /// The title of the button.
    var title: String { get set }
    
    /// The attributed title of the button.
    var attributedTitle: NSAttributedString { get set }
    
    /// The alignment of the button's title.
    var alignment: NSTextAlignment { get set }
    
    /// The layer that is used to render the button.
    var layer: CALayer? { get }
    
    /// Whether the button is highlighted.
    var isHighlighted: Bool { get }
    
    /// The corner radius of the button's border.
    var cornerRadius: CGFloat { get }
    
    /// Whether the mouse is inside the button.
    var mouseInside: Bool { get set }
    
    /// The bezel style of the button.
    var bezelStyle: NSButton.BezelStyle { get set }
    
    /// The effective appearance of the button.
    var effectiveAppearance: NSAppearance { get }
    
    /// The key equivalent of the button.
    var keyEquivalent: String { get set }
    
    // Protocol methods never have bodies--that's for the object(s) adopting (conforming to) the protocol to implement. Default implementations can be provided by creating an extension of the protocol.
    /// Sets the size of the button.
    func setFrameSize(_ newSize: NSSize)
    
    /// Draws the focus ring mask for the button.
    func drawFocusRingMask()
    
    /// Adds a tracking area to the button.
    func addTrackingArea(_ trackingArea: NSTrackingArea)
    
}

extension SAMButton {
    
    // MARK: - Custom Button Design - Configuration

    // This method has the type of B declared at the end of the method signature.
    // Marking a parameter as inout allows that parameter to be modified and the original value updated. UnsafeMutableSomethingPointer also allows this.
    static func configureButtonDesign<B>(for button: inout B) where B : SAMButtonBorderable {
        // Add any code here to configure SAMButtons and SAMPopups.
        // 1. Determine the accent color for the button.
        let isGraphite = Self.isGraphiteAppearance(for: button)
        let samButtonBorderableAccentColor = Self.accentColor(for: button, isGraphite: isGraphite)
        // 2. Disable standard bordering.
        Self.applyBaseConfiguration(to: &button)
        // 3. Apply coloring based on whether the button is a default button, enabled, and bordered.
        Self.applyStateColors(to: &button, isGraphite: isGraphite, accentColor: samButtonBorderableAccentColor)
        // 4. Configure the button's custom border.
        Self.applyBorderAppearance(to: &button)
        // 5. Configure the button's title and attributed title.
        Self.applyAttributedTitleIfNeeded(to: &button)
        // 6. Configure the button's SF Symbol if its image is an SF Symbol.
        Self.applySymbolConfigurationIfNeeded(to: &button)
        // 7. Apply a background if the button is highlighted and set the corner radius.
        Self.applyLayerBackgroundAndCornerRadius(to: &button)
        // 8. Set the button height to 24px if needed.
        Self.enforceMinimumHeightIfNeeded(for: &button)
    }

    // This method has the type of B declared in the declaration of B itself.
    private static func isGraphiteAppearance<B: SAMButtonBorderable>(for button: B) -> Bool {
        let isDarkTheme = button.effectiveAppearance.name.rawValue.contains("Dark")
        return NSColor.currentControlTint == .graphiteControlTint && isDarkTheme
    }

    private static func accentColor<B: SAMButtonBorderable>(for button: B, isGraphite: Bool) -> NSColor {
        if let bezelColor = button.bezelColor {
            // 1. If a bezel color is set, set its brightness to 85% of its original value.
            return bezelColor.hueColorWithBrightnessAmount(amount: 0.85).withAlphaComponent(0.75)
        } else if isGraphite {
            // 2. If dark theme graphite, use a white color.
            return .white.withAlphaComponent(0.5)
        } else {
            // 3. Otherwise, use the accent color with 85% brightness.
            return .controlAccentColor.hueColorWithBrightnessAmount(amount: 0.85).withAlphaComponent(0.75)
        }
    }

    private static func applyBaseConfiguration<B: SAMButtonBorderable>(to button: inout B) {
        // Disable standard bordering and set bezel style appropriate for custom design.
        button.isBordered = false
        button.bezelStyle = .smallSquare
    }

    private static func applyStateColors<B: SAMButtonBorderable>(to button: inout B, isGraphite: Bool, accentColor: NSColor) {
        if !button.isEnabled {
            // Disabled button
            button.mouseInside = false
            button.backgroundColor = SAMButtonBorderableDisabledBackgroundColor
            button.contentTintColor = .disabledControlTextColor
            button.highlightColor = SAMButtonBorderableNormalHighlightColor
            return
        }
        if let window = button.window, button is SAMButton && isEnabledColoredButton(button) && window.isKeyWindow {
            if button.isShowingBorder {
                // Enabled default/colored button showing button border
                button.backgroundColor = accentColor
                button.contentTintColor = contentColorForColoredButton(button, isGraphite: isGraphite)
                button.highlightColor = accentColor.themeAwareButtonHighlightColor(theme: isGraphite ? "Graphite" : button.effectiveAppearance.name.rawValue)
            } else {
                // Default button not showing button border
                button.backgroundColor = .clear
                button.contentTintColor = SAMButtonBorderableNormalContentColor
                button.highlightColor = .gray.themeAwareButtonHighlightColor(theme: button.effectiveAppearance.name.rawValue)
            }
        } else {
            // Normal button
            button.backgroundColor = SAMButtonBorderableNormalBackgroundColor
            button.contentTintColor = SAMButtonBorderableNormalContentColor
            button.highlightColor = SAMButtonBorderableNormalHighlightColor.themeAwareButtonHighlightColor(theme: button.effectiveAppearance.name.rawValue)
        }
    }

    private static func contentColorForColoredButton<B: SAMButtonBorderable>(_ button: B, isGraphite: Bool) -> NSColor {
        if let bezelColor = button.bezelColor {
            return bezelColor.isDark ? .white : .black
        } else {
            return isGraphite ? .black : .white
        }
    }

    private static func isEnabledColoredButton<B: SAMButtonBorderable>(_ button: B) -> Bool {
        return (button.keyEquivalent == SAReturnKeyEquivalentString || button.bezelColor != nil) && button.isEnabled
    }

    private static func applyBorderAppearance<B: SAMButtonBorderable>(to button: inout B) {
        if button.isShowingBorder {
            // 1. If the button is showing its border, set the border width. Use a thicker border if Increase Contrast is enabled.
            button.layer?.borderWidth = NSWorkspace.shared.accessibilityDisplayShouldIncreaseContrast ? 2 : 1
            // 2. Use the button's background color as its border color.
            button.layer?.borderColor = NSWorkspace.shared.accessibilityDisplayShouldIncreaseContrast ? button.backgroundColor.withAlphaComponent(button.isEnabled ? 1 : 0.25).cgColor : button.backgroundColor.hueColorWithBrightnessAmount(amount: 1.25).cgColor
        } else {
            // 3. If the button isn't showing its border, don't show a custom border.
            button.layer?.borderWidth = 0
            button.layer?.borderColor = nil
            button.backgroundColor = .clear
        }
    }

    private static func applyAttributedTitleIfNeeded<B: SAMButtonBorderable>(to button: inout B) {
        // 1. Make sure the button has a title. If not, return.
        guard !button.title.isEmpty else { return }
        // 2. Set the button's attributed title to the button's title, using the button's content color as the title's color. Do nothing if the button only shows an image.
        if let tint = button.contentTintColor, button.imagePosition != .imageOnly {
            let attributedString = NSAttributedString(string: button.title, attributes: [NSAttributedString.Key.foregroundColor: tint])
            button.attributedTitle = attributedString
        }
    }

    private static func applySymbolConfigurationIfNeeded<B: SAMButtonBorderable>(to button: inout B) {
        if isEnabledColoredButton(button) && button.isShowingBorder {
            // 1. If the button is enabled, showing its border, and has a color, set the image's color to match the title color.
            let symbolConfiguration = NSImage.SymbolConfiguration(paletteColors: [button.contentTintColor!])
            button.symbolConfiguration = symbolConfiguration
        } else {
            // 2. Otherwise, don't use a custom symbol configuration.
            button.symbolConfiguration = nil
        }
    }

    private static func applyLayerBackgroundAndCornerRadius<B: SAMButtonBorderable>(to button: inout B) {
        if button.isHighlighted {
            // 1. If the button isn highlighted, use the highlight color.
            button.layer?.backgroundColor = button.highlightColor.cgColor
        } else {
            // 2. If the button isn't highlighted, use the background color.
            button.layer?.backgroundColor = button.backgroundColor.cgColor
        }
        // 3. Set the corner radius.
        button.layer?.cornerRadius = button.cornerRadius
    }

    private static func enforceMinimumHeightIfNeeded<B: SAMButtonBorderable>(for button: inout B) {
        if button.frame.size.height < 24 {
            button.setFrameSize(NSSize(width: button.frame.size.width, height: 24))
        }
    }

    static func addTrackingArea<B : SAMButtonBorderable>(to button: B) {
        let trackingArea = NSTrackingArea(rect: NSZeroRect, options: [.mouseEnteredAndExited, .mouseMoved, .activeAlways, .assumeInside, .inVisibleRect], owner: button, userInfo: nil)
        button.addTrackingArea(trackingArea)
    }

    // MARK: - Custom Button Design - "Border Residue" Cleanup

    static func cleanUpBorderResidue<B>(for button: inout B) where B : SAMButtonBorderable {
        // 1. Get the current enabled state of the popup.
        let enabledState = button.isEnabled
        // 2. Enable and disable the popup to refresh its display in case "border residue" remains, then set it back to the current enabled state.
        button.isEnabled = true
        button.isEnabled = false
        button.isEnabled = enabledState
    }

    // MARK: - Recursive Button Borders

    /// This method uses recursion to go through each view in `views`. If a view contains `SAMButton`s or `SAMPopup`s, they're configured. If a view contains a subview, the process repeats for that subview, and continues down the view hierarchy until it reaches a view without any subviews, at which point this method returns.
    ///
    /// Use this method to quickly set `showsBorderOnlyWhileMouseInside` on any `SAMButton`s and `SAMPopup`s in each view in `view`'s subviews to `flag`. This is ideal for views with many buttons, as it simplifies the amount of code needed to configure each button's `showsBorderOnlyWhileMouseInside` property and allows you to avoid creating outlets just for button border configuration.
    /// - parameter flag: Whether buttons should show their borders only on mouse hover (`true`) or always (`false`).
    /// - parameter view: An `NSView` whose subviews may be `SAMButton`s or `SAMPopup`s, or may contain subviews.
    ///
    /// To configure all `SAMButton`s and `SAMPopup`s in an `NSViewController`'s view, simply pass its `view` property as the `view` parameter.
    /// For each `NSView` containing subviews, this method calls itself with that `NSView`'s `subviews` property passed in as the value of `views`. This method does nothing for `NSView`s that aren't `SAMButton`s or `SAMPopup`s and that don't contain subviews. Although this method calls itself multiple times, it will eventually run out of buttons/popups to configure, and will then return.
    /// Buttons/popups are configured one level at a time. Suppose you have an `NSVisualEffectView` with 2 `SAMButton`s and an `NSBox`, and that `NSBox` contains 2 `SAMButtons` and a second `NSBox`, and that second `NSBox` has 2 more `SAMButtons`. The 2 `SAMButton`s in the `SAMVisualEffectView` are configured first, followed by the 2 `SAMButton`s in the first `NSBox`, then the 2 `SAMButton`s in the second `NSBox`. Depending on the order subviews are added to the view, the buttons in the first `NSBox` (and its child `NSBox`) might be configured after the first `SAMButton` in the `SAMVisualEffectView` but before the second `SAMButton` in the `SAMVisualEffectView`.
    public static func configureButtonBordersUsingRecursion(shownOnlyOnHover flag: Bool, forButtonsAndPopupsInView view: NSView) {
        // 1. Configure each button and popup at the top of the view hierarchy (the subviews of view).
        let views = view.subviews
        for view in views {
            if let button = view as? SAMButton {
                button.showsBorderOnlyWhileMouseInside = flag
            }
            if let popup = view as? SAMPopup {
                popup.showsBorderOnlyWhileMouseInside = flag
            }
        }
        // 2. Go through any nested subviews and repeat this process in those subviews. To prevent performance issues, this code only loops through views which contain subviews. Even though this method calls itself for each subview, the for loop from the previous method call isn't stopped. Buttons/popups are configured one level at a time.
        let viewsContainingSubviews = views.filter { !$0.subviews.isEmpty }
        for view in viewsContainingSubviews {
            configureButtonBordersUsingRecursion(shownOnlyOnHover: flag, forButtonsAndPopupsInView: view)
        }
    }
}
#endif

