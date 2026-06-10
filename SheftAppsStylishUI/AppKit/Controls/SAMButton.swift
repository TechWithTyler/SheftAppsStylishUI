//
//  SAMButton.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 3/9/22.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

// Code in this file only applies to macOS. Start with #if os(macOS) and end with #endif.
#if os(macOS)

// MARK: - Imports

import Cocoa
import Foundation

// SAM = SheftApps macOS
/// A subclass of `NSButton` that conforms to the SheftApps design language.
public class SAMButton: NSButton, SAMButtonBorderable {

    // MARK: - Properties - Strings

    static var noBorderAttemptFatalErrorMessage: String = "SAMButton/SAMPopup doesn't support modifying the isBordered property and is only designed for bordered or border-on-hover buttons. For a borderless button or a button with a system button border style, use NSButton/NSPopUpButton (the system superclasses of SAMButton/SAMPopup) instead."

    static var bezelStyleChangeAttemptFatalErrorMessage: String = "SAMButton/SAMPopup doesn't support modifying the bezelStyle property and is only designed for rounded-corner buttons. For a button with a system bezel style, use NSButton/NSPopUpButton (the system superclasses of SAMButton/SAMPopup) instead."

    // MARK: - Properties - Colors

    var backgroundColor: NSColor = SAMButtonBorderableNormalBackgroundColor

    var contentColor: NSColor? = SAMButtonBorderableNormalContentColor

    /// The content tint color of the button.
    public override var contentTintColor: NSColor? {
        get {
            return contentColor
        } set {
            contentColor = newValue
        }
    }

    var highlightColor: NSColor = SAMButtonBorderableNormalHighlightColor

    // MARK: - Properties - Floats

    var cornerRadius: CGFloat = {
        return SAButtonCornerRadius
    }()

    // MARK: - Properties - Bezel Style

    /// This property doesn't do anything. Attempting to set this property will throw a fatal error.
    public override var bezelStyle: NSButton.BezelStyle {
        willSet {
            if newValue != .smallSquare {
                fatalError(SAMButton.bezelStyleChangeAttemptFatalErrorMessage)
            }
        }
    }

    // MARK: - Properties - Booleans

    /// This property doesn't do anything. Attempting to set this property will throw a fatal error.
    public override var isBordered: Bool {
        willSet {
            if newValue {
                fatalError(SAMButton.noBorderAttemptFatalErrorMessage)
            }
        }
    }

    /// Whether the mouse cursor is in the button's bounds.
    ///
    /// This property always returns `false` if `isEnabled` is `false`.
    internal(set) public var mouseInside: Bool = false

    /// Whether the button shows its border only while the mouse is hovered over it.
    ///
    /// `mouseInside` returns `true` when the mouse is hovered over the button regardless of the value of this property, allowing mouse-tracking events even if the button always shows its border.
    public override var showsBorderOnlyWhileMouseInside: Bool {
        get {
            return borderOnHover
        } set {
            if mouseInside && isEnabled && newValue {
                borderOnHover = newValue
                mouseInside = true
            } else {
                borderOnHover = newValue
            }
        }
    }

    /// Whether the button is currently showing a border.
    ///
    /// - important: This property is not to be confused with `isBordered`, which has no effect on `SAMButton`/`SAMPopup`. Attempting to set `isBordered` to `true` will throw a fatal error.
    public var isShowingBorder: Bool {
        return (showsBorderOnlyWhileMouseInside && mouseInside) || !showsBorderOnlyWhileMouseInside || isHighlighted
    }

    /// Whether the button is enabled.
    public override var isEnabled: Bool {
        willSet {
            if !newValue {
                mouseInside = false
            }
        }
        didSet {
            // Since self is immutable by design, we need to assign it to a variable, which is then passed as an inout argument to configureButtonDesign(for:).
            var mutableSelf = self
            // Use & ("address of" operator) before a value passed as an inout or UnsafeSomethingPointer argument.
            SAMButton.configureButtonDesign(for: &mutableSelf)
        }
    }

    var borderOnHover: Bool = false {
        didSet {
            // 1. Configure the button design.
            var mutableSelf = self
            SAMButton.configureButtonDesign(for: &mutableSelf)
            // 2. Clean up "border residue" if any.
            SAMButton.cleanUpBorderResidue(for: &mutableSelf)
        }
    }

    /// Whether the button allows vibrancy.
    public override var allowsVibrancy: Bool {
        if let window = window {
            // 1. If the button isn't enabled, or showsBorderOnlyWhileMouseInside is true and the mouse isn't inside the button, return true.
            if !isEnabled || (showsBorderOnlyWhileMouseInside && !mouseInside) {
                return true
            } else if (keyEquivalent == SAReturnKeyEquivalentString || bezelColor != nil) && (!showsBorderOnlyWhileMouseInside || mouseInside) && window.isKeyWindow {
                // 2. If the button is a default button and is showing its border, return true in dark theme but false in light theme.
                if NSColor.currentControlTint == .graphiteControlTint && effectiveAppearance.name.rawValue.contains("Dark") {
                    return true
                } else {
                    return false
                }
            } else {
                // 4. If not a default button and/or not showing the border, return true.
                return true
            }
        } else {
            // 5. If we can't get the containing window, return true.
            return true
        }
    }

    // MARK: - Drawing

    public override func drawFocusRingMask() {
        // Wrap the focus ring around the button and set the corner radius.
        let cornerRadius: CGFloat = cornerRadius
        let path = NSBezierPath(roundedRect: self.bounds, xRadius: cornerRadius, yRadius: cornerRadius)
        path.fill()
        needsDisplay = true
    }

    public override func awakeFromNib() {
        // Add any code here that should only be executed when the button is first instantiated.
        SAMButton.addTrackingArea(to: self)
        super.awakeFromNib()
    }

    public override func updateLayer() {
        super.updateLayer()
        needsDisplay = true
    }

    public override func draw(_ dirtyRect: NSRect) {
        var mutableSelf = self
        SAMButton.configureButtonDesign(for: &mutableSelf)
        super.draw(dirtyRect)
    }

    // MARK: - Key Window State Handler

    public override func viewWillMove(toWindow newWindow: NSWindow?) {
        super.viewWillMove(toWindow: newWindow)
        // 1. Remove old observers
        NotificationCenter.default.removeObserver(self)
        guard let window = newWindow else { return }
        // 2. Observe window key state changes.
        NotificationCenter.default.addObserver(self, selector: #selector(windowKeyStateChanged), name: NSWindow.didBecomeKeyNotification, object: window)
        NotificationCenter.default.addObserver(self, selector: #selector(windowKeyStateChanged), name: NSWindow.didResignKeyNotification, object: window)
    }

    @objc private func windowKeyStateChanged() {
        needsDisplay = true
    }

    // MARK: - Mouse Events

    public override func mouseEntered(with event: NSEvent) {
        mouseInside = true
        needsDisplay = true
        super.mouseEntered(with: event)
    }

    public override func mouseExited(with event: NSEvent) {
        mouseInside = false
        needsDisplay = true
        super.mouseExited(with: event)
    }

    public override func mouseMoved(with event: NSEvent) {
        needsDisplay = true
        super.mouseMoved(with: event)
    }

}

// MARK: - Preview

#Preview("AppKit SAMButton") {
    let viewController = NSViewController()
    viewController.view.frame = NSRect(x: 50, y: 50, width: 100, height: 100)
    let button = SAMButton(frame: viewController.view.frame)
    viewController.view.addSubview(button)
    return viewController
}
#endif
