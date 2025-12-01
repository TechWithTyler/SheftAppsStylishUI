//
//  SAMPopupSwiftUIRepresentable.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/10/24.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

#if os(macOS)

// MARK: - Imports

import SwiftUI

/// An `SAMPopup` for use in SwiftUI, configured as a popup button.
public struct SAMPopupSwiftUIRepresentable: NSViewRepresentable {

    // MARK: - Properties - Strings

    var items: [String]

    // MARK: - Properties - Integers

    var selectedIndex: Binding<Int>

    // MARK: - Properties - Actions

    var selectionChangedAction: ((Int, String) -> Void)?

    var itemHighlightHandler: ((Int, String, Bool) -> Void)?

    var menuOpenHandler: ((NSMenu) -> Void)?

    var menuClosedHandler: ((NSMenu) -> Void)?

    // MARK: - Properties - Booleans

    @Binding var borderOnHover: Bool

    // MARK: - Initialization

    /// Initializes an `SAMPopupSwiftUIRepresentable` with the given parameters.
    /// - Parameters:
    ///   - borderOnHover: Whether the border should only be visible when the mouse is hovering over the button. Defaults to `false`.
    ///   - items: An array of items to be displayed in the popup menu.
    ///   - selectedIndex: A binding to the selected index of the popup.
    ///   - selectionChangedAction: An action to be performed when the selected item in the popup changes. You can also add the .onChange(of:) modifier to a `View` and respond to changes to your selected index property.
    ///   - itemHighlightHandler: An optional action to be performed when an item in the popup is highlighted.
    ///   - menuOpenHandler: An optional action to be performed when the popup menu is opened.
    ///   - menuClosedHandler: An optional action to be performed when the popup menu is closed.
    public init(borderOnHover: Binding<Bool> = .constant(false), items: [String], selectedIndex: Binding<Int>, selectionChangedAction: ((Int, String) -> Void)? = nil, itemHighlightHandler: ((Int, String, Bool) -> Void)? = nil, menuOpenHandler: ((NSMenu) -> Void)? = nil, menuClosedHandler: ((NSMenu) -> Void)? = nil) {
        self.items = items
        self.selectedIndex = selectedIndex
        self.selectionChangedAction = selectionChangedAction
        self.itemHighlightHandler = itemHighlightHandler
        self.menuOpenHandler = menuOpenHandler
        self.menuClosedHandler = menuClosedHandler
        self._borderOnHover = borderOnHover
    }

    // MARK: - NSViewRepresentable

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

    // MARK: - Coordinator

    /// Makes a `Coordinator` for the `SAMPopup`.
    ///
    /// - Returns: A `Coordinator`.
    public func makeCoordinator() -> Coordinator {
        Coordinator(selectedIndex: selectedIndex, selectionChangedAction: selectionChangedAction, itemHighlightHandler: itemHighlightHandler, menuOpenHandler: menuOpenHandler, menuClosedHandler: menuClosedHandler)
    }

    /// The `Coordinator` for the `SAMPopup`.
    public class Coordinator: NSObject, NSMenuDelegate {

        var samPopup: SAMPopup

        var selectedIndex: Binding<Int>

        var selectionChangedAction: ((Int, String) -> Void)?

        var itemHighlightHandler: ((Int, String, Bool) -> Void)?

        var menuOpenHandler: ((NSMenu) -> Void)?

        var menuClosedHandler: ((NSMenu) -> Void)?

        init(selectedIndex: Binding<Int>, selectionChangedAction: ((Int, String) -> Void)?, itemHighlightHandler: ((Int, String, Bool) -> Void)?, menuOpenHandler: ((NSMenu) -> Void)?, menuClosedHandler: ((NSMenu) -> Void)?) {
            self.samPopup = SAMPopup()
            self.selectedIndex = selectedIndex
            self.selectionChangedAction = selectionChangedAction
            self.itemHighlightHandler = itemHighlightHandler
            self.menuOpenHandler = menuOpenHandler
            self.menuClosedHandler = menuClosedHandler
        }

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

// MARK: - Preview

#Preview("SwiftUI SAMPopupSwiftUIRepresentable") {
    @Previewable @State var selection: Int = 0
    return SAMPopupSwiftUIRepresentable(items: ["Item 1", "Item 2"], selectedIndex: $selection)
}

// MARK: - Library Items

struct SAMPopupSwiftUIRepresentableLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(SAMPopupSwiftUIRepresentable(borderOnHover: .constant(false), items: ["Item 1", "Item 2", "Item 3"], selectedIndex: .constant(0), selectionChangedAction: nil, itemHighlightHandler: nil, menuOpenHandler: nil, menuClosedHandler: nil), visible: true, title: "SheftAppsStylishUI macOS Popup", category: .control, matchingSignature: "popup")
    }

}
#endif
