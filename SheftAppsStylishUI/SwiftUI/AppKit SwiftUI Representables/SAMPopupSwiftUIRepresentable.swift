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

    var items: [String : Int]

    // MARK: - Properties - Integers

    var selectedIndex: Binding<Int>

    // MARK: - Properties - Actions

    var selectionChangedAction: ((Int, String, Int) -> Void)?

    var itemHighlightHandler: ((Int, String, Int, Bool) -> Void)?

    var menuOpenHandler: ((NSMenu) -> Void)?

    var menuClosedHandler: ((NSMenu) -> Void)?

    // MARK: - Properties - Booleans

    @Binding var borderOnHover: Bool

    // MARK: - Initialization

    /// Initializes an `SAMPopupSwiftUIRepresentable` with the given parameters.
    /// - Parameters:
    ///   - borderOnHover: Whether the border should only be visible when the mouse is hovering over the button. Defaults to `false`.
    ///   - itemTitles: An array of item titles to be displayed in the popup menu. Use an empty `String` to insert a separator.
    ///   - selectedIndex: A binding to the selected index of the popup.
    ///   - selectionChangedAction: An action to be performed when the selected item in the popup changes. This closure gives back the item's index, title, and tag. You can also add the `.onChange(of:)` modifier to a `View` and respond to changes to your selected index property.
    ///   - itemHighlightHandler: An optional action to be performed when an item in the popup is highlighted. This closure gives back the item's index, title, tag, and enabled state.
    ///   - menuOpenHandler: An optional action to be performed when the popup menu is opened.
    ///   - menuClosedHandler: An optional action to be performed when the popup menu is closed.
    public init(borderOnHover: Binding<Bool> = .constant(false), itemTitles: [String], selectedIndex: Binding<Int>, selectionChangedAction: ((Int, String, Int) -> Void)? = nil, itemHighlightHandler: ((Int, String, Int, Bool) -> Void)? = nil, menuOpenHandler: ((NSMenu) -> Void)? = nil, menuClosedHandler: ((NSMenu) -> Void)? = nil) {
        self.items = {
            var dict: [String : Int] = [:]
            for title in itemTitles {
                dict[title] = 0
            }
            return dict
        }()
        self.selectedIndex = selectedIndex
        self.selectionChangedAction = selectionChangedAction
        self.itemHighlightHandler = itemHighlightHandler
        self.menuOpenHandler = menuOpenHandler
        self.menuClosedHandler = menuClosedHandler
        self._borderOnHover = borderOnHover
    }

    /// Initializes an `SAMPopupSwiftUIRepresentable` with the given parameters.
    /// - Parameters:
    ///   - borderOnHover: Whether the border should only be visible when the mouse is hovering over the button. Defaults to `false`.
    ///   - items: A dictionary of items to be displayed in the popup menu, where the key is the title and the value is the tag. Use an empty `String` to insert a separator.
    ///   - selectedIndex: An `Int` binding for the currently selected item in the popup.
    ///   - selectionChangedAction: The action to be performed when an item is selected from the popup. This closure gives back the item's index, title, and tag.
    ///   - itemHighlightHandler: An optional action to be performed when an item in the popup is highlighted. This closure gives back the item's index, title, tag, and enabled state.
    ///   - menuOpenHandler: An optional action to be performed when the popup menu is opened.
    ///   - menuClosedHandler: An optional action to be performed when the popup menu is closed.
    public init(borderOnHover: Binding<Bool> = .constant(false), items: [String : Int], selectedIndex: Binding<Int>, selectionChangedAction: ((Int, String, Int) -> Void)? = nil, itemHighlightHandler: ((Int, String, Int, Bool) -> Void)? = nil, menuOpenHandler: ((NSMenu) -> Void)? = nil, menuClosedHandler: ((NSMenu) -> Void)? = nil) {
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
        // 1. Create the popup.
        let button = SAMPopup(frame: CGRect(x: 0, y: 0, width: 0, height: 24), pullsDown: false)
        // 2. Add the items and select the item at the selected index. For any item that's an empty string, insert a separator item.
        for item in items {
            let title = item.key
            let tag = item.value
            if title.isEmpty {
                button.menu?.addItem(.separator())
            } else {
                button.addItem(withTitle: title)
                button.item(withTitle: title)?.tag = tag
            }
        }
        let index = selectedIndex.wrappedValue
        button.selectItem(at: index)
        // 3. Set the target and action.
        button.target = context.coordinator
        button.action = #selector(Coordinator.itemSelected)
        // 4. Add Auto Layout constraints to set the button's height to 24px
        button.setContentHuggingPriority(.required, for: .vertical)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        // 5. Set the SAMPopup property of the coordinator.
        context.coordinator.samPopup = button
        // 6. Return the popup.
        return button
    }

    /// Updates the `NSView` representation of the `SAMPopup`.
    ///
    /// - Parameters:
    ///   - button: The `SAMPopup` to be updated.
    ///   - context: The context in which the representable is updated.
    public func updateNSView(_ button: SAMPopup, context: Context) {
        // 1. Select the item at the new index.
        let index = selectedIndex.wrappedValue
        button.selectItem(at: index)
        // 2. Update the coordinator's SAMPopup property and menu delegate.
        context.coordinator.samPopup = button
        button.menu?.delegate = context.coordinator
        // 3. Update the border on hover state and tracking area.
        button.showsBorderOnlyWhileMouseInside = borderOnHover
        SAMButton.addTrackingArea(to: button)
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

        var selectionChangedAction: ((Int, String, Int) -> Void)?

        var itemHighlightHandler: ((Int, String, Int, Bool) -> Void)?

        var menuOpenHandler: ((NSMenu) -> Void)?

        var menuClosedHandler: ((NSMenu) -> Void)?

        init(selectedIndex: Binding<Int>, selectionChangedAction: ((Int, String, Int) -> Void)?, itemHighlightHandler: ((Int, String, Int, Bool) -> Void)?, menuOpenHandler: ((NSMenu) -> Void)?, menuClosedHandler: ((NSMenu) -> Void)?) {
            self.samPopup = SAMPopup()
            self.selectedIndex = selectedIndex
            self.selectionChangedAction = selectionChangedAction
            self.itemHighlightHandler = itemHighlightHandler
            self.menuOpenHandler = menuOpenHandler
            self.menuClosedHandler = menuClosedHandler
        }

        @objc func itemSelected() {
            // 1. Get the index and title of the selected item
            let index = samPopup.indexOfSelectedItem
            let itemTitle = samPopup.itemTitle(at: index)
            guard let tag = samPopup.item(at: index)?.tag else { return }
            // 2. Update the selected index property.
            selectedIndex.wrappedValue = index
            // 3. Perform the selection changed action with the index, item title, and item tag.
            selectionChangedAction?(index, itemTitle, tag)
        }

        public func menuWillOpen(_ menu: NSMenu) {
            menuOpenHandler?(menu)
        }

        public func menuDidClose(_ menu: NSMenu) {
            menuClosedHandler?(menu)
        }

        public func menu(_ menu: NSMenu, willHighlight item: NSMenuItem?) {
            performItemHighlightHandler(for: item, in: menu)
        }

        public func menu(_ menu: NSMenu, update item: NSMenuItem, at index: Int, shouldCancel: Bool) -> Bool {
            performItemHighlightHandler(for: item, in: menu)
            return true
        }

        func performItemHighlightHandler(for item: NSMenuItem?, in menu: NSMenu) {
            // 1. Make sure the highlighted item isn't nil.
            guard let item = item else { return }
            // 2. Get the index, title, tag, and enabled state of the highlighted item.
            let index = menu.index(of: item)
            let title = item.title
            let tag = item.tag
            let enabled = item.isEnabled
            // 3. Perform the item highlight handler.
            itemHighlightHandler?(index, title, tag, enabled)
        }

    }

}

// MARK: - Preview

#Preview("SwiftUI SAMPopupSwiftUIRepresentable") {
    @Previewable @State var selection: Int = 0
    return SAMPopupSwiftUIRepresentable(itemTitles: ["Item 1", "Item 2", String(), "Item 3", "Item 4"], selectedIndex: $selection)
}

// MARK: - Library Items

struct SAMPopupSwiftUIRepresentableLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(SAMPopupSwiftUIRepresentable(borderOnHover: .constant(false), itemTitles: ["Item 1", "Item 2", "Item 3"], selectedIndex: .constant(0), selectionChangedAction: nil, itemHighlightHandler: nil, menuOpenHandler: nil, menuClosedHandler: nil), visible: true, title: "SheftAppsStylishUI macOS Popup (Item Titles)", category: .control, matchingSignature: "popup")
        LibraryItem(SAMPopupSwiftUIRepresentable(borderOnHover: .constant(false), items: ["Item 1": 1, "Item 2": 2, "Item 3": 3], selectedIndex: .constant(0), selectionChangedAction: nil, itemHighlightHandler: nil, menuOpenHandler: nil, menuClosedHandler: nil), visible: true, title: "SheftAppsStylishUI macOS Popup (Item Titles/Tags)", category: .control, matchingSignature: "popup")
    }

}
#endif
