//
//  SAMPopup.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 3/9/22.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

#if os(macOS)
import Cocoa
import Foundation

/// A subclass of `NSPopUpButton` optimized for classy, stylish looks.
public class SAMPopup: NSPopUpButton, SAMButtonBorderable {

	// MARK: - Properties - Colors

	var backgroundColor: NSColor = SAMButtonBorderableNormalBackgroundColor

	var contentColor: NSColor? = SAMButtonBorderableNormalContentColor

	public override var contentTintColor: NSColor? {
		get {
			return contentColor
		} set {
			contentColor = newValue
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

	/// Whether the mouse cursor is in the popup's bounds.
	internal(set) public var mouseInside: Bool = false

	/// Whether the popup shows its border only while the mouse is hovered over it.
	///
	/// `mouseInside` returns `true` when the mouse is hovered over the popup regardless of the value of this property, allowing mouse-tracking events even if the popup always shows its border.
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
        return (showsBorderOnlyWhileMouseInside && mouseInside) || (!showsBorderOnlyWhileMouseInside)
    }

    /// Whether the popup is enabled.
	public override var isEnabled: Bool {
		willSet {
			if !newValue {
				mouseInside = false
			}
		}
		didSet {
            var mutableSelf = self
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
		return true
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

@available(macOS 14, *)
#Preview("AppKit SAMPopup (popup)") {
    let viewController = NSViewController()
    viewController.view.frame = NSRect(x: 50, y: 50, width: 100, height: 100)
    let button = SAMPopup(frame: viewController.view.frame)
    button.addItems(withTitles: ["Item 1", "Item 2"])
    viewController.view.addSubview(button)
    return viewController
}

@available(macOS 14, *)
#Preview("AppKit SAMPopup (pulldown)") {
    let viewController = NSViewController()
    viewController.view.frame = NSRect(x: 50, y: 50, width: 100, height: 100)
    let button = SAMPopup(frame: viewController.view.frame)
    button.pullsDown = true
    button.addItems(withTitles: ["Pulldown", "Item 1", "Item 2"])
    viewController.view.addSubview(button)
    return viewController
}

#endif
