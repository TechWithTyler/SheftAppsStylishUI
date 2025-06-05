//
//  SAMButton.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 3/9/22.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

// Code in this file only applies to macOS. Start with #if os(macOS) and end with #endif.
#if os(macOS)
import Cocoa
import Foundation

// SAM = SheftApps macOS
/// A subclass of `NSButton` that conforms to the SheftApps design language.
public class SAMButton: NSButton, SAMButtonBorderable {

    static var noBorderAttemptFatalErrorMessage: String = "SAMButton/SAMPopup doesn't support modifying the isBordered property and is only designed for bordered or border-on-hover buttons. For a borderless button or a button with a system button border style, use NSButton/NSPopUpButton (the system superclasses of SAMButton/SAMPopup) instead."

    static var bezelStyleChangeAttemptFatalErrorMessage: String = "SAMButton/SAMPopup doesn't support modifying the bezelStyle property and is only designed for rounded-corner buttons. For a button with a system bezel style, use NSButton/NSPopUpButton (the system superclasses of SAMButton/SAMPopup) instead."

    // MARK: - Properties - Colors

    var backgroundColor: NSColor = SAMButtonBorderableNormalBackgroundColor

    var contentColor: NSColor = SAMButtonBorderableNormalContentColor

    public override var contentTintColor: NSColor? {
        get {
            return contentColor
        } set {
            contentColor = newValue!
        }
    }

    var highlightColor: NSColor = SAMButtonBorderableNormalHighlightColor

    // MARK: - Properties - Corner Radius

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
            configureButtonDesign(for: &mutableSelf)
        }
    }

    var borderOnHover: Bool = false {
        didSet {
            let enabledState = isEnabled
            var mutableSelf = self
            configureButtonDesign(for: &mutableSelf)
            isEnabled = true
            isEnabled = false
            isEnabled = enabledState
        }
    }

    public override var allowsVibrancy: Bool {
        if let window = window {
            if !isEnabled || (showsBorderOnlyWhileMouseInside && !mouseInside) {
                return true
            } else if (keyEquivalent == SAReturnKeyEquivalentString || bezelColor != nil) && (!showsBorderOnlyWhileMouseInside || mouseInside) && window.isKeyWindow {
                if NSColor.currentControlTint == .graphiteControlTint && effectiveAppearance.name.rawValue.contains("Dark") {
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }
        } else {
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
        // Add any code here that should only be executed when the button is first instantiated
        SheftAppsStylishUI.addTrackingArea(to: self)
        super.awakeFromNib()
    }

    public override func updateLayer() {
        super.updateLayer()
        needsDisplay = true
    }

    public override func draw(_ dirtyRect: NSRect) {
        var mutableSelf = self
        configureButtonDesign(for: &mutableSelf)
        super.draw(dirtyRect)
    }

    public override func performKeyEquivalent(with key: NSEvent) -> Bool {
        needsDisplay = true
        return super.performKeyEquivalent(with: key)
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

    public override func mouseDown(with event: NSEvent) {
        mouseInside = true
        needsDisplay = true
        super.mouseDown(with: event)
    }

    public override func mouseUp(with event: NSEvent) {
        needsDisplay = true
        super.mouseUp(with: event)
    }

    public override func mouseMoved(with event: NSEvent) {
        needsDisplay = true
        super.mouseMoved(with: event)
    }

}

#Preview("AppKit SAMButton") {
    let viewController = NSViewController()
    viewController.view.frame = NSRect(x: 50, y: 50, width: 100, height: 100)
    let button = SAMButton(frame: viewController.view.frame)
    viewController.view.addSubview(button)
    return viewController
}
#endif
