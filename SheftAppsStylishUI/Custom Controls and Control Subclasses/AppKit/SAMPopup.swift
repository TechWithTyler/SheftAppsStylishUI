//
//  SAMPopup.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 3/9/22.
//  Copyright © 2022-2023 SheftApps. All rights reserved.
//

#if os(macOS)
import Cocoa
import Foundation

/// A subclass of `NSPopUpButton` optimized for classy, stylish looks.
@IBDesignable public class SAMPopup: NSPopUpButton, SAMButtonBorderable {

	// MARK: - Properties - Colors

	var backgroundColor: NSColor = SAMButtonBorderableNormalBackgroundColor

	var contentColor: NSColor = SAMButtonBorderableNormalContentColor

	public override var contentTintColor: NSColor? {
		get {
			return contentColor
		} set {
			contentColor = newValue ?? SAMButtonBorderableNormalContentColor
		}
	}

	var highlightColor: NSColor = SAMButtonBorderableNormalHighlightColor

	// MARK: - Properties - Corner Radius

	var cornerRadius: CGFloat = {
		return sheftAppsButtonCornerRadius
	}()

	// MARK: - Properties - Status

	/// Whether the mouse cursor is in the popup's bounds.
	internal(set) public var mouseInside: Bool = false

	/// Whether the popup shows its border only while the mouse is hovered over it.
	///
	/// `mouseInside` returns `true` when the mouse is hovered over the popup regardless of the value of this property, allowing mouse-tracking events even if the popup always shows its border.
	@IBInspectable public override var showsBorderOnlyWhileMouseInside: Bool {
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

/// A custom `NSViewRepresentable` that represents an `SAMPopup` configured as a popup button.
public struct SAMPopupSwiftUIRepresentable: NSViewRepresentable {

	/// An array of items to be displayed in the popup menu.
	public var items: [String]

	/// A binding to the selected index of the popup.
	public var selectedIndex: Binding<Int>

	/// An action to be performed when the selected item in the popup changes.
	public var selectionChangedAction: ((Int, String) -> Void)?

	/// An action to be performed when an item in the popup is highlighted.
	public var itemHighlightHandler: ((Int, String, Bool) -> Void)?

	/// An action to be performed when the popup menu is opened.
	public var menuOpenHandler: ((NSMenu) -> Void)?

	/// An action to be performed when the popup menu is closed.
	public var menuClosedHandler: ((NSMenu) -> Void)?

	/// Whether the border should only be visible when the mouse is hovering over the button.
	@Binding public var borderOnHover: Bool

	/// Initializes an `SAMPopupSwiftUIRepresentable` with the given parameters.
	/// - Parameters:
	///   - borderOnHover: Whether the border should only be visible when the mouse is hovering over the button. Defaults to `false`.
	///   - items: An array of items to be displayed in the popup menu.
	///   - selectedIndex: A binding to the selected index of the popup.
	///   - selectionChangedAction: An action to be performed when the selected item in the popup changes.
	///   - itemHighlightHandler: An action to be performed when an item in the popup is highlighted.
	///   - menuOpenHandler: An action to be performed when the popup menu is opened.
	///   - menuClosedHandler: An action to be performed when the popup menu is closed.
	public init(borderOnHover: Binding<Bool> = .constant(false), items: [String], selectedIndex: Binding<Int>, selectionChangedAction: ((Int, String) -> Void)? = nil, itemHighlightHandler: ((Int, String, Bool) -> Void)? = nil, menuOpenHandler: ((NSMenu) -> Void)? = nil, menuClosedHandler: ((NSMenu) -> Void)? = nil) {
		self.items = items
		self.selectedIndex = selectedIndex
		self.selectionChangedAction = selectionChangedAction
		self.itemHighlightHandler = itemHighlightHandler
		self.menuOpenHandler = menuOpenHandler
		self.menuClosedHandler = menuClosedHandler
		self._borderOnHover = borderOnHover
	}

	/// Makes an `NSView` representation of the `SAMPopup`.
	///
	/// - Parameter context: The context in which the representable is created.
	/// - Returns: An `SAMPopup`.
	public func makeNSView(context: Context) -> SAMPopup {
		let button = SAMPopup(frame: CGRect(x: 0, y: 0, width: 0, height: 24), pullsDown: false)
		button.addItems(withTitles: items)
		let index = selectedIndex.wrappedValue
		button.selectItem(at: index)
		button.target = context.coordinator
		button.action = #selector(Coordinator.itemSelected)
		// Add Auto Layout constraints to set the button's height to 24 pixels
		button.setContentHuggingPriority(.required, for: .vertical)
		button.setContentCompressionResistancePriority(.required, for: .vertical)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.heightAnchor.constraint(equalToConstant: 24).isActive = true
		context.coordinator.samPopup = button
		return button
	}

	/// Updates the `NSView` representation of the `SAMPopup`.
	///
	/// - Parameters:
	///   - button: The `SAMPopup` to be updated.
	///   - context: The context in which the representable is updated.
	public func updateNSView(_ button: SAMPopup, context: Context) {
		let index = selectedIndex.wrappedValue
		button.selectItem(at: index)
		context.coordinator.samPopup = button
		button.menu?.delegate = context.coordinator
		button.showsBorderOnlyWhileMouseInside = borderOnHover
		SheftAppsStylishUI.addTrackingArea(to: button)
	}

	/// Makes a `Coordinator` for the `SAMPopup`.
	///
	/// - Returns: A `Coordinator`.
	public func makeCoordinator() -> Coordinator {
		Coordinator(selectedIndex: selectedIndex, selectionChangedAction: selectionChangedAction, itemHighlightHandler: itemHighlightHandler, menuOpenHandler: menuOpenHandler, menuClosedHandler: menuClosedHandler)
	}

	/// The `Coordinator` for the `SAMPopup`.
	public class Coordinator: NSObject, NSMenuDelegate {

		/// The `SAMPopup` being served by this `Coordinator`.
		public var samPopup: SAMPopup

		/// A binding to the selected index of the popup.
		public var selectedIndex: Binding<Int>

		/// An action to be performed when the selected item in the popup changes.
		public var selectionChangedAction: ((Int, String) -> Void)?

		/// An action to be performed when an item in the popup is highlighted.
		public var itemHighlightHandler: ((Int, String, Bool) -> Void)?

		/// An action to be performed when the popup menu is opened.
		public var menuOpenHandler: ((NSMenu) -> Void)?

		/// An action to be performed when the popup menu is closed.
		public var menuClosedHandler: ((NSMenu) -> Void)?

		/// Initializes the `Coordinator`.
		///
		/// - Parameters:
		///   - selectedIndex: A binding to the selected index of the popup.
		///   - selectionChangedAction: An action to be performed when the selected item in the popup changes.
		///   - itemHighlightHandler: An action to be performed when an item in the popup is highlighted.
		///   - menuOpenHandler: An action to be performed when the popup menu is opened.
		///   - menuClosedHandler: An action to be performed when the popup menu is closed.
		public init(selectedIndex: Binding<Int>, selectionChangedAction: ((Int, String) -> Void)?, itemHighlightHandler: ((Int, String, Bool) -> Void)?, menuOpenHandler: ((NSMenu) -> Void)?, menuClosedHandler: ((NSMenu) -> Void)?) {
			self.samPopup = SAMPopup()
			self.selectedIndex = selectedIndex
			self.selectionChangedAction = selectionChangedAction
			self.itemHighlightHandler = itemHighlightHandler
			self.menuOpenHandler = menuOpenHandler
			self.menuClosedHandler = menuClosedHandler
		}

		/// Triggers the action when the selection in the popup changes.
		@objc func itemSelected() {
			let index = samPopup.indexOfSelectedItem
			let selectedItem = samPopup.itemTitle(at: index)
			selectedIndex.wrappedValue = index
			selectionChangedAction?(index, selectedItem)
		}

		public func menuWillOpen(_ menu: NSMenu) {
			menuOpenHandler?(menu)
		}

		public func menuDidClose(_ menu: NSMenu) {
			menuClosedHandler?(menu)
		}

		public func menu(_ menu: NSMenu, willHighlight item: NSMenuItem?) {
			guard let item = item else { return }
			itemHighlightHandler?(menu.index(of: item), item.title, item.isEnabled)
		}

		public func menu(_ menu: NSMenu, update item: NSMenuItem, at index: Int, shouldCancel: Bool) -> Bool {
			itemHighlightHandler?(menu.index(of: item), item.title, item.isEnabled)
			return true
		}

	}
}

/// A custom `NSViewRepresentable` that represents an `SAMPopup` configured as a pulldown button.
public struct SAMPulldownSwiftUIRepresentable: NSViewRepresentable {

	/// The title of the button, which is the first item in the menu's `items` array.
	public var title: String

	/// An array of items to be displayed in the pulldown menu.
	public var items: [String]

	/// An action to be performed when an item is selected from the menu.
	public var selectionChangedAction: ((Int, String) -> Void)?

	/// An action to be performed when an item in the pulldown is highlighted.
	public var itemHighlightHandler: ((Int, String, Bool) -> Void)?

	/// An action to be performed when the pulldown menu is opened.
	public var menuOpenHandler: ((NSMenu) -> Void)?

	/// An action to be performed when the pulldown menu is closed.
	public var menuClosedHandler: ((NSMenu) -> Void)?

	/// Whether the border should only be visible when the mouse is hovering over the button.
	@Binding public var borderOnHover: Bool

	/// Initializes an `SAMPulldownSwiftUIRepresentable` with the given parameters.
	/// - Parameters:
	///   - title: The title of the button, which is the first item in the menu's `items` array.
	///   - borderOnHover: Whether the border should only be visible when the mouse is hovering over the button. Defaults to `false`.
	///   - items: An array of items to be displayed in the pulldown menu.
	///   - selectionChangedAction: An action to be performed when an item is selected from the menu.
	///   - itemHighlightHandler: An action to be performed when an item in the menu is highlighted.
	///   - menuOpenHandler: An action to be performed when the pulldown menu is opened.
	///   - menuClosedHandler: An action to be performed when the pulldown menu is closed.
	public init(title: String, borderOnHover: Binding<Bool> = .constant(false), items: [String], selectionChangedAction: ((Int, String) -> Void)? = nil, itemHighlightHandler: ((Int, String, Bool) -> Void)? = nil, menuOpenHandler: ((NSMenu) -> Void)? = nil, menuClosedHandler: ((NSMenu) -> Void)? = nil) {
		self.title = title
		self.items = items
		self.selectionChangedAction = selectionChangedAction
		self.itemHighlightHandler = itemHighlightHandler
		self.menuOpenHandler = menuOpenHandler
		self.menuClosedHandler = menuClosedHandler
		self._borderOnHover = borderOnHover
	}

	/// Makes an `NSView` representation of the `SAMPopup`.
	///
	/// - Parameter context: The context in which the representable is created.
	/// - Returns: An `SAMPopup`.
	public func makeNSView(context: Context) -> SAMPopup {
		let button = SAMPopup(frame: CGRect(x: 0, y: 0, width: 0, height: 24), pullsDown: true)
		button.addItem(withTitle: title)
		button.addItems(withTitles: items)
		button.target = context.coordinator
		button.action = #selector(Coordinator.itemSelected)
		// Add Auto Layout constraints to set the button's height to 24 pixels
		button.setContentHuggingPriority(.required, for: .vertical)
		button.setContentCompressionResistancePriority(.required, for: .vertical)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.heightAnchor.constraint(equalToConstant: 24).isActive = true
		context.coordinator.samPopup = button
		return button
	}

	/// Updates the `NSView` representation of the `SAMPopup`.
	///
	/// - Parameters:
	///   - button: The `SAMPopup` to be updated.
	///   - context: The context in which the representable is updated.
	public func updateNSView(_ button: SAMPopup, context: Context) {
		context.coordinator.samPopup = button
		button.menu?.delegate = context.coordinator
		button.showsBorderOnlyWhileMouseInside = borderOnHover
		SheftAppsStylishUI.addTrackingArea(to: button)
	}

	/// Makes a `Coordinator` for the `SAMPopup`.
	///
	/// - Returns: A `Coordinator`.
	public func makeCoordinator() -> Coordinator {
		Coordinator(selectionChangedAction: selectionChangedAction, itemHighlightHandler: itemHighlightHandler, menuOpenHandler: menuOpenHandler, menuClosedHandler: menuClosedHandler)
	}

	/// The `Coordinator` for the `SAMPopup`.
	public class Coordinator: NSObject, NSMenuDelegate {

		/// The `SAMPopup` being served by this `Coordinator`.
		public var samPopup: SAMPopup

		/// An action to be performed when an item is selected from the menu.
		public var selectionChangedAction: ((Int, String) -> Void)?

		/// An action to be performed when an item in the menu is highlighted.
		public var itemHighlightHandler: ((Int, String, Bool) -> Void)?

		/// An action to be performed when the pulldown menu is opened.
		public var menuOpenHandler: ((NSMenu) -> Void)?

		/// An action to be performed when the pulldown menu is closed.
		public var menuClosedHandler: ((NSMenu) -> Void)?

		/// Initializes the `Coordinator`.
		///
		/// - Parameters:
		///   - selectionChangedAction: An action to be performed when an item is selected form the menu.
		///   - itemHighlightHandler: An action to be performed when an item in the menu is highlighted.
		///   - menuOpenHandler: An action to be performed when the pulldown menu is opened.
		///   - menuClosedHandler: An action to be performed when the pulldown menu is closed.
		public init(selectionChangedAction: ((Int, String) -> Void)?, itemHighlightHandler: ((Int, String, Bool) -> Void)?, menuOpenHandler: ((NSMenu) -> Void)?, menuClosedHandler: ((NSMenu) -> Void)?) {
			self.samPopup = SAMPopup()
			self.selectionChangedAction = selectionChangedAction
			self.itemHighlightHandler = itemHighlightHandler
			self.menuOpenHandler = menuOpenHandler
			self.menuClosedHandler = menuClosedHandler
		}

		/// Triggers the action when an item is selected from the menu.
		@objc func itemSelected() {
			let index = samPopup.indexOfSelectedItem
			let selectedItem = samPopup.itemTitle(at: index)
			selectionChangedAction?(index, selectedItem)
		}

		public func menuWillOpen(_ menu: NSMenu) {
			menuOpenHandler?(menu)
		}

		public func menuDidClose(_ menu: NSMenu) {
			menuClosedHandler?(menu)
		}

		public func menu(_ menu: NSMenu, willHighlight item: NSMenuItem?) {
			guard let item = item else { return }
			itemHighlightHandler?(menu.index(of: item), item.title, item.isEnabled)
		}

		public func menu(_ menu: NSMenu, update item: NSMenuItem, at index: Int, shouldCancel: Bool) -> Bool {
			itemHighlightHandler?(menu.index(of: item), item.title, item.isEnabled)
			return true
		}

	}
}

#endif
