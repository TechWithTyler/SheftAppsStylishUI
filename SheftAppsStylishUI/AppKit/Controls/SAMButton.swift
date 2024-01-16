//
//  SAMButton.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 3/9/22.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

// Code in this file only applies to macOS. Start with #if os(macOS) and end with #endif.
#if os(macOS)
import Cocoa
import Foundation

// SAM = SheftApps macOS
/// A subclass of `NSButton` that conforms to the SheftApps design language.
public class SAMButton: NSButton, SAMButtonBorderable {

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

	// MARK: - Properties - Status

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

	public override var isEnabled: Bool {
		willSet {
			if !newValue {
				mouseInside = false
			}
		}
		didSet {
			configureButtonDesign(for: self)
		}
	}

	var borderOnHover: Bool = false {
		didSet {
			let enabledState = isEnabled
			configureButtonDesign(for: self)
			isEnabled = true
			isEnabled = false
			isEnabled = enabledState
		}
	}

	public override var allowsVibrancy: Bool {
        if !isEnabled || (showsBorderOnlyWhileMouseInside && !mouseInside) {
            return true
        } else if (keyEquivalent == SAReturnKeyEquivalentString || bezelColor != nil) && (!showsBorderOnlyWhileMouseInside || mouseInside) {
			if NSColor.currentControlTint == .graphiteControlTint && effectiveAppearance.name.rawValue.contains("Dark") {
				return true
			} else {
				return false
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

	public override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		mouseInside = false
		configureButtonDesign(for: self)
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
		configureButtonDesign(for: self)
		super.draw(dirtyRect)
	}

	public override func performKeyEquivalent(with key: NSEvent) -> Bool {
		needsDisplay = true
		return super.performKeyEquivalent(with: key)
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

/// A custom `NSViewRepresentable` that represents an `SAMButton`.
public struct SAMButtonSwiftUIRepresentable: NSViewRepresentable {

	/// The title of the button.
	public var title: String

	/// The action that should be triggered when the button is clicked.
	public var action: (() -> Void)

	/// Whether the border should only be visible when the mouse is hovering over the button.
	@Binding public var borderOnHover: Bool

	/// Initializes the `SAMButtonSwiftUIRepresentable`.
	///
	/// - Parameters:
	///   - title: The title of the button.
	///   - borderOnHover: Whether the border should only be visible when the mouse is hovering over the button. Defaults to `false`.
	///   - action: The action that should be triggered when the button is clicked.
	public init(title: String, borderOnHover: Binding<Bool> = .constant(false), action: @escaping (() -> Void)) {
		self._borderOnHover = borderOnHover
		self.title = title
		self.action = action
	}

	/// Makes an `NSView` representation of the `SAMButton`.
	///
	/// - Parameter context: The context in which the representable is created.
	/// - Returns: An `SAMButton`.
	public func makeNSView(context: Context) -> SAMButton {
		let button = SAMButton(frame: .zero)
		button.title = title
		button.target = context.coordinator
		button.action = #selector(Coordinator.buttonClicked)
		// Add Auto Layout constraints to set the button's height to 24 pixels
		button.setContentHuggingPriority(.required, for: .vertical)
		button.setContentCompressionResistancePriority(.required, for: .vertical)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.heightAnchor.constraint(equalToConstant: 24).isActive = true
		return button
	}

	/// Updates the `NSView` representation of the `SAMButton`.
	///
	/// - Parameters:
	///   - button: The `SAMButton` to be updated.
	///   - context: The context in which the representable is updated.
	public func updateNSView(_ button: SAMButton, context: Context) {
		button.title = title
		button.showsBorderOnlyWhileMouseInside = borderOnHover
		SheftAppsStylishUI.addTrackingArea(to: button)
	}

	/// Makes a `Coordinator` for the `SAMButton`.
	///
	/// - Returns: A `Coordinator`.
	public func makeCoordinator() -> Coordinator {
		return Coordinator(action: action)
	}

	/// The `Coordinator` for the `SAMButton`.
	public class Coordinator: NSObject {

		/// The action that should be triggered when the button is clicked.
		public var action: (() -> Void)

		/// Initializes the `Coordinator`.
		///
		/// - Parameter action: The action that should be triggered when the button is clicked.
		public init(action: @escaping (() -> Void)) {
			self.action = action
		}

		/// Triggers the action when the button is clicked.
		@objc func buttonClicked() {
			action()
		}
	}
}

@available(macOS 14, *)
#Preview("AppKit SAMButton") {
    let viewController = NSViewController()
    viewController.view.frame = NSRect(x: 50, y: 50, width: 100, height: 100)
    let button = SAMButton(frame: viewController.view.frame)
    viewController.view.addSubview(button)
    return viewController
}

#Preview("SwiftUI SAMButtonSwiftUIRepresentable") {
    SAMButtonSwiftUIRepresentable(title: "Button") {
        
    }
}
#endif
