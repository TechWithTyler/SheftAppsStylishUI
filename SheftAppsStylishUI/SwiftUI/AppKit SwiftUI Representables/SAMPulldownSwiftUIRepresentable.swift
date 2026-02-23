//
//  SAMPulldownSwiftUIRepresentable.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/10/24.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

#if os(macOS)

// MARK: - Imports

import SwiftUI

/// An `SAMPopup` for use in SwiftUI, configured as a pulldown menu.
public struct SAMPulldownSwiftUIRepresentable: NSViewRepresentable {

    // MARK: - Properties - Strings

    var title: String

    var items: [String]

    // MARK: - Properties - Actions

    var itemSelectedAction: ((Int, String) -> Void)

    var itemHighlightHandler: ((Int, String, Bool) -> Void)?

    var menuOpenHandler: ((NSMenu) -> Void)?

    var menuClosedHandler: ((NSMenu) -> Void)?

    // MARK: - Properties - Booleans

    @Binding var borderOnHover: Bool

    // MARK: - Initialization

    /// Initializes an `SAMPulldownSwiftUIRepresentable` with the given parameters.
    /// - Parameters:
    ///   - title: The title of the button, which is the first item in the menu's `items` array.
    ///   - borderOnHover: Whether the border should only be visible when the mouse is hovering over the button. Defaults to `false`.
    ///   - items: An array of item titles to be displayed in the pulldown menu. Use an empty `String` to insert a separator.
    ///   - itemSelectedAction: The action to be performed when an item is selected from the menu.
    ///   - itemHighlightHandler: An optional action to be performed when an item in the menu is highlighted.
    ///   - menuOpenHandler: An optional action to be performed when the pulldown menu is opened.
    ///   - menuClosedHandler: An optional action to be performed when the pulldown menu is closed.
    public init(title: String, borderOnHover: Binding<Bool> = .constant(false), items: [String], itemSelectedAction: @escaping ((Int, String) -> Void), itemHighlightHandler: ((Int, String, Bool) -> Void)? = nil, menuOpenHandler: ((NSMenu) -> Void)? = nil, menuClosedHandler: ((NSMenu) -> Void)? = nil) {
        self.title = title
        self.items = items
        self.itemSelectedAction = itemSelectedAction
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
        // 1. Create the pulldown.
        let button = SAMPopup(frame: CGRect(x: 0, y: 0, width: 0, height: 24), pullsDown: true)
        // 2. Add the title and menu items.
        button.addItem(withTitle: title)
        for item in items {
            if item.isEmpty {
                button.menu?.addItem(.separator())
            } else {
                button.addItem(withTitle: item)
            }
        }
        // 3. Set the target and action.
        button.target = context.coordinator
        button.action = #selector(Coordinator.itemSelected)
        // 4. Add Auto Layout constraints to set the button's height to 24px
        button.setContentHuggingPriority(.required, for: .vertical)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        // 5. Set the coordinator's SAMPopup property.
        context.coordinator.samPopup = button
        // 6. Return the pulldown.
        return button
    }

    /// Updates the `NSView` representation of the `SAMPopup`.
    ///
    /// - Parameters:
    ///   - button: The `SAMPopup` to be updated.
    ///   - context: The context in which the representable is updated.
    public func updateNSView(_ button: SAMPopup, context: Context) {
        // 1. Update the coordinator's SAMPopup property and menu delegate.
        context.coordinator.samPopup = button
        button.menu?.delegate = context.coordinator
        // 2. Update the border on hover state and tracking area.
        button.showsBorderOnlyWhileMouseInside = borderOnHover
        SAMButton.addTrackingArea(to: button)
    }

    // MARK: - Coordinator

    /// Makes a `Coordinator` for the `SAMPopup`.
    ///
    /// - Returns: A `Coordinator`.
    public func makeCoordinator() -> Coordinator {
        Coordinator(itemSelectedAction: itemSelectedAction, itemHighlightHandler: itemHighlightHandler, menuOpenHandler: menuOpenHandler, menuClosedHandler: menuClosedHandler)
    }

    /// The `Coordinator` for the `SAMPopup`.
    public class Coordinator: NSObject, NSMenuDelegate {

        var samPopup: SAMPopup

        var itemSelectedAction: ((Int, String) -> Void)

        var itemHighlightHandler: ((Int, String, Bool) -> Void)?

        var menuOpenHandler: ((NSMenu) -> Void)?

        var menuClosedHandler: ((NSMenu) -> Void)?

        init(itemSelectedAction: @escaping ((Int, String) -> Void), itemHighlightHandler: ((Int, String, Bool) -> Void)?, menuOpenHandler: ((NSMenu) -> Void)?, menuClosedHandler: ((NSMenu) -> Void)?) {
            self.samPopup = SAMPopup()
            self.itemSelectedAction = itemSelectedAction
            self.itemHighlightHandler = itemHighlightHandler
            self.menuOpenHandler = menuOpenHandler
            self.menuClosedHandler = menuClosedHandler
        }

        @objc func itemSelected() {
            // 1. Get the index and title of the selected item
            let index = samPopup.indexOfSelectedItem
            let selectedItem = samPopup.itemTitle(at: index)
            // 2. Perform the item selected action with the index and item title.
            itemSelectedAction(index, selectedItem)
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
            // 2. Get the index of the highlighted item.
            let itemIndex = menu.index(of: item)
            // 3. Perform the item highlight handler.
            itemHighlightHandler?(itemIndex, item.title, item.isEnabled)
        }

    }

}

// MARK: - Preview

#Preview("SwiftUI SAMPulldownSwiftUIRepresentable") {
    SAMPulldownSwiftUIRepresentable(title: "Pulldown", items: ["Item 1", "Item 2"]) {
        index, title in
        NSSound.beep()
    }
}

// MARK: - Library Items

struct SAMPulldownSwiftUIRepresentableLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(SAMPulldownSwiftUIRepresentable(title: "Pulldown", borderOnHover: .constant(false), items: ["Item 1", "Item 2", "Item 3"], itemSelectedAction: { index, title in
            
        }, itemHighlightHandler: nil, menuOpenHandler: nil, menuClosedHandler: nil), visible: true, title: "SheftAppsStylishUI macOS Pulldown", category: .control, matchingSignature: "pulldown")
    }

}
#endif
