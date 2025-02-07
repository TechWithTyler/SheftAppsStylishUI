//
//  MARK: - Beginning Info
//
//  SAMButtonBorderable.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 3/9/22.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
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
    
    // In a protocol, properties are declared with "get" or "get set" within curly braces, which determines whether objects adopting the protocol can get and set, or only get, the property's value. Protocol properties never have initial values--that's for the object(s) adopting (corforming to) the protocol to decide.
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
    
    /// The color of the button's content.
    var contentTintColor: NSColor? { get set }
    
    /// The color of the button's highlight.
    var highlightColor: NSColor { get set }
    
    /// The color of the button's background.
    var backgroundColor: NSColor { get set }
    
    /// The image that is displayed on the button.
    var image: NSImage? { get set }

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
    
    // Protocol methods never have bodies--that's for the object(s) adopting (corforming to) the protocol to implement.
    /// Sets the size of the button.
    func setFrameSize(_ newSize: NSSize)
    
    /// Draws the focus ring mask for the button.
    func drawFocusRingMask()
    
    /// Adds a tracking area to the button.
    func addTrackingArea(_ trackingArea: NSTrackingArea)
    
}

// MARK: - Custom Button Design - Configuration

// This function has the type of B declared at the end of the function signature.
// Marking a parameter as inout allows that parameter to be modified and the original value updated.
func configureButtonDesign<B>(for button: inout B) where B : SAMButtonBorderable {
    // Add any code here to configure SAMButtons and SAMPopups.
    // 1. Determine the accent color for the button.
    let isGraphite = NSColor.currentControlTint == .graphiteControlTint && button.effectiveAppearance.name.rawValue.contains("Dark")
    var samButtonBorderableAccentColor: NSColor {
        if let bezelColor = button.bezelColor {
            return bezelColor.hueColorWithBrightnessAmount(amount: 0.85).withAlphaComponent(0.75)
        } else
        if isGraphite {
            return .white.withAlphaComponent(0.5)
        } else {
            return .controlAccentColor.hueColorWithBrightnessAmount(amount: 0.85).withAlphaComponent(0.75)
        }
    }
    // 2. Disable the standard NSButton/NSPopUpButton bordering. SAMButton/SAMPopup requires the standard bordering to be disabled.
    button.isBordered = false
    // 3. Set the bezel style to smallSquare, the default style for borderless buttons. The custom design requires a height-resizable button style.
    button.bezelStyle = .smallSquare
    // 4. Configure the button based on key equivalent, enabled state, and mouse hover state.
    if !button.isEnabled {
        // Disabled button
        button.mouseInside = false
        button.backgroundColor = SAMButtonBorderableDisabledBackgroundColor
        button.contentTintColor = .disabledControlTextColor
        button.highlightColor = SAMButtonBorderableNormalHighlightColor
    } else {
        if button is SAMButton && (button.keyEquivalent == SAReturnKeyEquivalentString || button.bezelColor != nil) && button.isEnabled {
            if button.isShowingBorder {
                // Enabled default button showing button border
                button.backgroundColor = samButtonBorderableAccentColor
                button.contentTintColor = isGraphite ? .black : .white
                button.highlightColor = samButtonBorderableAccentColor.themeAwareButtonHighlightColor(theme: isGraphite ? "Graphite" : button.effectiveAppearance.name.rawValue)
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
    // 5. If we got here and none of the above conditions were met, use the default color values as specified in SAMButton/SAMPopup.
    if button.isShowingBorder {
        // Bordered button (use colors determined above)
        button.layer?.borderWidth = NSWorkspace.shared.accessibilityDisplayShouldIncreaseContrast ? 2 : 1
        button.layer?.borderColor = NSWorkspace.shared.accessibilityDisplayShouldIncreaseContrast ? button.backgroundColor.withAlphaComponent(button.isEnabled ? 1 : 0.25).cgColor : button.backgroundColor.hueColorWithBrightnessAmount(amount: 1.25).cgColor
    } else {
        // Border on hover button
        button.layer?.borderWidth = 0
        button.layer?.borderColor = nil
        button.backgroundColor = .clear
    }
    // 6. Create an attributed string using the provided title color, and use that attributed string as title.
    if !button.title.isEmpty {
        let attributedString = NSAttributedString(string: button.title, attributes: [NSAttributedString.Key.foregroundColor: button.contentTintColor!])
        button.attributedTitle = attributedString
    }
    // 7. Set the button's symbol configuration (has no effect for buttons whose images aren't SF Symbols or that have no image).
    if (button.keyEquivalent == SAReturnKeyEquivalentString || button.bezelColor != nil) && button.isEnabled && button.isShowingBorder {
            let symbolConfiguration = NSImage.SymbolConfiguration(paletteColors: [button.contentTintColor!])
            button.symbolConfiguration = symbolConfiguration
        } else {
            button.symbolConfiguration = nil
        }
    // 8. Set the proper background color depending on whether the button is highlighted.
    if !button.isHighlighted {
        button.layer?.backgroundColor = button.backgroundColor.cgColor
    } else {
        button.layer?.backgroundColor = button.highlightColor.cgColor
    }
    // 8. Set the corner radius to match the standard button corner radius.
    button.layer?.cornerRadius = button.cornerRadius
    // 9. Set the height to 24 pixels if the height is lower than 24 pixels.
    if button.frame.size.height < 24 {
        button.setFrameSize(NSSize(width: button.frame.size.width, height: 24))
    }
}

// This function has the type of B declared with the declaration of B.
func addTrackingArea<B : SAMButtonBorderable>(to button: B) {
    let trackingArea = NSTrackingArea(rect: NSZeroRect, options: [.mouseEnteredAndExited, .mouseMoved, .activeAlways, .assumeInside, .inVisibleRect], owner: button, userInfo: nil)
    button.addTrackingArea(trackingArea)
}

// MARK: - Recursive Button Borders

/// This function uses recursion to go through each view in `views`. If a view contains `SAMButton`s or `SAMPopup`s, they're configured. If a view contains a subview, the process repeats for that subview, and continues down the view hierarchy until it reaches a view without any subviews, at which point this function returns.
///
/// Use this function to quickly set `showsBorderOnlyWhileMouseInside` on any `SAMButton`s and `SAMPopup`s in each view in `views` to `flag`. This is ideal for views with many buttons, as it simplifies the amount of code needed to configure each button's `showsBorderOnlyWhileMouseInside` property and allows you to avoid creating outlets just for button border configuration.
/// - parameter flag: Whether buttons should show their borders only on mouse hover (`true`) or always (`false`).
/// - parameter views: An array of `NSView`s that may be `SAMButton`s or `SAMPopup`s, or that may contain subviews.
///
/// For each `NSView` containing subviews, this function calls itself with that `NSView`'s `subviews` property passed in as the value of `views`. This function does nothing for `NSViews` that aren't `SAMButton`s or `SAMPopup`s and that don't contain subviews. Although this function calls itself multiple times, it will eventually run out of buttons to configure, and will then return.
public func configureButtonBordersUsingRecursion(shownOnlyOnHover flag: Bool, forButtonsAndPopupsInViews views: [NSView]) {
    // 1. Configure each button and popup at the top of the view hierarchy.
    for view in views {
        if let button = view as? SAMButton {
            button.showsBorderOnlyWhileMouseInside = flag
        }
        if let popup = view as? SAMPopup {
            popup.showsBorderOnlyWhileMouseInside = flag
        }
    }
    // 2. Go through any nested subviews and repeat this process in those subviews. To prevent performance issues, this code only loops through views which contain subviews.
    let viewsContainingSubviews = views.filter { !$0.subviews.isEmpty }
    for view in viewsContainingSubviews {
        configureButtonBordersUsingRecursion(shownOnlyOnHover: flag, forButtonsAndPopupsInViews: view.subviews)
    }
}
#endif
