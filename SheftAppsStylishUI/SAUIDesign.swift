//
//  MARK: - Beginning Info
//
//  SAUIDesign.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 3/9/22.
//  Copyright © 2022-2023 SheftApps. All rights reserved.
//
//  This file contains code to create and configure the UI in SheftApps apps.
//  In macOS class prefixes, SAM stands for SheftApps macOS.
//  In iOS class prefixes, SAI stands for SheftApps iOS.

// MARK: - Imports - Cross-Platform

// These frameworks can be imported on any platform.
import SwiftUI

// MARK: - Imports - Specific Platforms Only

// These frameworks can only be imported on certain platforms, so we check availability at compile-time.
// Use #if canImport(<#module#>) before importing the module. Use #endif after the import statement.
#if canImport(Cocoa)
import Cocoa
#endif
#if canImport(UIKit)
import UIKit
#endif

// MARK: - SheftApps Team Internal Build Designation

/// Adds a method to append " (SheftApps Team Internal Build)" to String objects.
public extension String {
    
    /// Appends " (SheftApps Team Internal Build)" to `self`.
    ///
    /**
     * This designation is useful for window titles and feedback titles, so people who look at an app can know whether the shown build is internal (unreleased, in-development). This designation makes sure people know that the build they're seeing doesn't exactly (or in some cases, at all) represent what will get released at the end of a given development season.
     * For example, early builds of version 2022.5 of all our AppKit apps, which started development in February 2022, didn't include the next-generation button design, which, alongside this framework, was introduced into the internal builds in March 2022, with the final versions being released on May 6, 2022.
     * An app's final build is created by archiving the given app. Builds created by building the app normally will be marked as internal.
     * Internal vs final build is determined by the build configuration (Debug or Release).
     */
    mutating func appendSheftAppsTeamInternalBuildDesignation() {
#if(DEBUG)
        append(" (SheftApps Team Internal Build)")
#else
        fatalError("The SheftApps Team Internal Build designation is supposed to appear only in internal builds. Please wrap this function call in a #if(DEBUG) block. Don't release this broken build as the final!")
#endif
    }
    
}

// MARK: - Cross-Platform UI Code - Corner Radii

// Code in this section applies to SheftApps apps on any Apple devices.

/// The corner radius for text views in SheftApps apps.
public var sheftAppsTextViewCornerRadius: CGFloat = 5

public var sheftAppsButtonCornerRadius: CGFloat = 5

/// A corner radius value that creates a circle (no corners) used for image views which display a person's photo in SheftApps apps.
public var sheftAppsPersonPhotoViewCornerRadius: CGFloat = 360

// MARK: - AppKit UI Code - Colors

// Use #if os(macOS) before code that only applies to macOS. End with #endif.

#if os(macOS)

var SAMButtonBorderableNormalBackgroundColor: NSColor = .gray.withAlphaComponent(0.1)

var SAMButtonBorderableNormalContentColor: NSColor = .controlTextColor

var SAMButtonBorderableNormalHighlightColor: NSColor = .gray.withAlphaComponent(0.25)

var SAMButtonBorderableDisabledBackgroundColor: NSColor = .gray.withAlphaComponent(0.05)

// MARK: - AppKit UI Code - Custom Button Design

/// Shares many `NSButton` and `NSPopUpButton` methods and properties with both `SAMButton` and `SAMPopup` to allow access in the `configureButtonDesign(for:)` global function.
protocol SAMButtonBorderable {
    
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
    
    /// Whether the button shows a border only when the mouse is inside it.
    var showsBorderOnlyWhileMouseInside: Bool { get set }
    
    /// The color of the button's content.
    var contentTintColor: NSColor? { get set }
    
    /// The color of the button's highlight.
    var highlightColor: NSColor { get set }
    
    /// The color of the button's background.
    var backgroundColor: NSColor { get set }
    
    /// The image that is displayed on the button.
    var image: NSImage? { get set }
    
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
    
    /// Sets the size of the button.
    func setFrameSize(_ newSize: NSSize)
    
    /// Draws the focus ring mask for the button.
    func drawFocusRingMask()
    
    /// Adds a tracking area to the button.
    func addTrackingArea(_ trackingArea: NSTrackingArea)
    
}

// This function has the type of B declared at the end of the function signature.
func configureButtonDesign<B>(for button: B) where B : SAMButtonBorderable {
    // Add any code here to configure SAMButtons and SAMPopups.
    // 1. Since values passed to functions are immutable by design, we need to assign this one to a variable, which is then mutated to configure button.
    var mutableButton = button
    let isGraphite = NSColor.currentControlTint == .graphiteControlTint && mutableButton.effectiveAppearance.name.rawValue.contains("Dark")
    var samButtonBorderableAccentColor: NSColor {
        if isGraphite {
            return .white.withAlphaComponent(0.5)
        } else {
            return .controlAccentColor
        }
    }
    // 2. Disable the standard NSButton/NSPopUpButton bordering. SAMButton/SAMPopup requires the standard bordering to be disabled.
    mutableButton.isBordered = false
    // 3. Set the bezel style to smallSquare, the default style for borderless buttons. The custom design requires a height-resizable button style.
    mutableButton.bezelStyle = .smallSquare
    // 4. Configure the button based on key equivalent, enabled state, and mouse hover state.
    if !button.isEnabled {
        // Disabled button
        mutableButton.mouseInside = false
        mutableButton.backgroundColor = SAMButtonBorderableDisabledBackgroundColor
        mutableButton.contentTintColor = .disabledControlTextColor
        mutableButton.highlightColor = SAMButtonBorderableNormalHighlightColor
    } else {
        if mutableButton is SAMButton && mutableButton.keyEquivalent == returnKeyEquivalentString && mutableButton.isEnabled {
            if (mutableButton.showsBorderOnlyWhileMouseInside && mutableButton.mouseInside) || (!button.showsBorderOnlyWhileMouseInside) {
                // Enabled default button showing button border
                mutableButton.backgroundColor = samButtonBorderableAccentColor
                mutableButton.contentTintColor = isGraphite ? .black : .white
                mutableButton.highlightColor = samButtonBorderableAccentColor.themeAwareButtonHighlightColor(theme: isGraphite ? "Graphite" : mutableButton.effectiveAppearance.name.rawValue)
            } else {
                // Default button not showing button border
                mutableButton.backgroundColor = .clear
                mutableButton.contentTintColor = SAMButtonBorderableNormalContentColor
                mutableButton.highlightColor = .gray.themeAwareButtonHighlightColor(theme: mutableButton.effectiveAppearance.name.rawValue)
            }
        } else {
            // Normal button
            mutableButton.backgroundColor = SAMButtonBorderableNormalBackgroundColor
            mutableButton.contentTintColor = SAMButtonBorderableNormalContentColor
            mutableButton.highlightColor = .gray.themeAwareButtonHighlightColor(theme: mutableButton.effectiveAppearance.name.rawValue)
        }
    }
    // If we got here and none of the above conditions were met, use the default color values as specified in SAMButton/SAMPopup.
    if (mutableButton.showsBorderOnlyWhileMouseInside && mutableButton.mouseInside) || (!button.showsBorderOnlyWhileMouseInside) {
        // Bordered button (use colors determined above)
        mutableButton.layer?.borderWidth = NSWorkspace.shared.accessibilityDisplayShouldIncreaseContrast ? 2 : 1
        mutableButton.layer?.borderColor = NSWorkspace.shared.accessibilityDisplayShouldIncreaseContrast ? mutableButton.backgroundColor.withAlphaComponent(1).cgColor : mutableButton.backgroundColor.hueColorWithBrightnessAmount(amount: 1.25).cgColor
    } else {
        // Border on hover button
        mutableButton.layer?.borderWidth = 0
        mutableButton.layer?.borderColor = nil
        mutableButton.backgroundColor = .clear
    }
    // 6. Create an attributed string using the provided title color, and use that attributed string as title.
    if !mutableButton.title.isEmpty {
        let attributedString = NSAttributedString(string: mutableButton.title, attributes: [NSAttributedString.Key.foregroundColor: mutableButton.contentTintColor!])
        mutableButton.attributedTitle = attributedString
    }
    if let buttonImage = mutableButton.image, (mutableButton.contentTintColor != .disabledControlTextColor) {
        let symbolConfiguration = NSImage.SymbolConfiguration(paletteColors: [mutableButton.contentTintColor!])
        mutableButton.image = buttonImage.withSymbolConfiguration(symbolConfiguration)
    }
    // 5. Set the proper background color depending on whether the button is highlighted.
    if !button.isHighlighted {
        mutableButton.layer?.backgroundColor = mutableButton.backgroundColor.cgColor
    } else {
        mutableButton.layer?.backgroundColor = mutableButton.highlightColor.cgColor
    }
    // 8. Set the corner radius to match the standard button corner radius.
    mutableButton.layer?.cornerRadius = mutableButton.cornerRadius
    // 9. Set the height to 24 pixels, in case buttons are created with another height.
    mutableButton.setFrameSize(NSSize(width: mutableButton.frame.size.width, height: 24))
}

// This function has the type of B declared with the declaration of B.
func addTrackingArea<B : SAMButtonBorderable>(to button: B) {
    let trackingArea = NSTrackingArea(rect: NSZeroRect, options: [.mouseEnteredAndExited, .mouseMoved, .activeAlways, .assumeInside, .inVisibleRect], owner: button, userInfo: nil)
    button.addTrackingArea(trackingArea)
}

// MARK: - AppKit UI Code - Recursive Button Borders

/// This function uses recursion to go through each view in `views`. If a view contains `SAMButton`s or `SAMPopup`s, they're configured. If a view contains a subview, the process repeats for that subview, and continues down the view hierarchy until it reaches a view without any subviews, at which point this function returns.
///
/// Use this function to quickly set `showsBorderOnlyWhileMouseInside` on any `SAMButton`s and `SAMPopup`s in each view in `views` to `flag`. This is ideal for views with many buttons, as it simplifies the amount of code needed to configure each button's `showsBorderOnlyWhileMouseInside` property and allows you to avoid creating outlets just for the purpose of button border configuration.
/// - parameter flag: Whether buttons should show their borders only on mouse hover.
/// - parameter views: An array of `NSView`s that may be `SAMButton`s or `SAMPopup`s, or that may contain subviews.
///
/// For each `NSView` containing subviews, this function calls itself with that `NSView`'s `subviews` property passed in as the value of `views`. This function does nothing for `NSViews` that aren't `SAMButton`s or `SAMPopup`s, and that don't contain subviews. Although this function calls itself multiple times, it will eventually run out of buttons to configure, and will then return.
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
    // 2. Go through any nested subviews and repeat this process in those subviews. This code only loops through views which contain subviews.
    let viewsContainingSubviews = views.filter { !$0.subviews.isEmpty }
    for view in viewsContainingSubviews {
        configureButtonBordersUsingRecursion(shownOnlyOnHover: flag, forButtonsAndPopupsInViews: view.subviews)
    }
}
#endif

// MARK: - UIKit UI Code

// Use #if os(iOS) before code that only applies to iOS/Catalyst. End with #endif.

#if os(iOS)
// TODO: Add customizations for UIKit apps.
#endif

// MARK: - SwiftUI UI Code - Destructive Color Modifier

public struct SheftAppsDestructiveColorModifier: ViewModifier {
    
    @ViewBuilder
    public func body(content: Content) -> some View {
        content.foregroundColor(.red)
    }
    
}

// MARK: - SwiftUI UI Code - Conditional Text Selectability Modifier

public struct TextSelectabilityModifier: ViewModifier {
    
    var isSelectable: Bool
    
    public func body(content: Content) -> some View {
#if os(tvOS) || os(watchOS)
        content
#else
        if isSelectable {
            content
                .textSelection(.enabled)
        } else {
            content
                .textSelection(.disabled)
        }
#endif
    }
    
}

// MARK: - SwiftUI UI Code - Continuous Button Modifier

public struct ContinuousButtonModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        if #available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *) {
            content.buttonRepeatBehavior(.enabled)
        } else {
            content
        }
    }
    
}

// MARK: - SwiftUI UI Code - View Extension

public extension View {
    
    /// Enables or disables selectability of text in `Text` views based on the value of `selectable`.
    func isTextSelectable(_ selectable: Bool) -> some View {
        modifier(TextSelectabilityModifier(isSelectable: selectable))
    }
    
    /// Returns a red color for use on destructive buttons.
    func destructiveColor() -> some View {
        modifier(SheftAppsDestructiveColorModifier())
    }
    
    /// Modifies a `Button` to continuously send its action on supported OS versions.
    func continuousButton() -> some View {
        modifier(ContinuousButtonModifier())
    }
    
}
