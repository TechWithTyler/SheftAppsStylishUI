//
//  FormSAMPopup.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/10/24.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

#if os(macOS)

// MARK: - Imports

import SwiftUI

/// An `SAMPopupSwiftUIRepresentable` optimized for SwiftUI `Form` views.
public struct FormSAMPopup: View {

    // MARK: - Properties - Strings

    var title: String

    var items: [String : Int]

    // MARK: - Properties - Integers

    var selectedIndex: Binding<Int>

    // MARK: - Properties - Actions

    var selectionChangedAction: ((Int, String, Int) -> Void)?

    var itemHighlightHandler: ((Int, String, Int, Bool) -> Void)?

    var menuOpenHandler: ((NSMenu) -> Void)?

    var menuClosedHandler: ((NSMenu) -> Void)?

    // MARK: - Initialization

    /// Initializes a `FormSAMPopup` with the given parameters.
    /// - Parameters:
    ///   - title: The title of the popup.
    ///   - itemTitles: An array of item titles to be displayed in the popup. Use an empty `String` to insert a separator.
    ///   - selectedIndex: An `Int` binding for the currently selected item in the popup.
    ///   - selectionChangedAction: The action to be performed when an item is selected from the popup. This closure gives back the item's index, title, and tag.
    ///   - itemHighlightHandler: An optional action to be performed when an item in the popup is highlighted. This closure gives back the item's index, title, tag, and enabled state.
    ///   - menuOpenHandler: An optional action to be performed when the popup is opened.
    ///   - menuClosedHandler: An optional action to be performed when the popup is closed.
    public init(title: String, itemTitles: [String], selectedIndex: Binding<Int>, selectionChangedAction: ( (Int, String, Int) -> Void)? = nil, itemHighlightHandler: ( (Int, String, Int, Bool) -> Void)? = nil, menuOpenHandler: ( (NSMenu) -> Void)? = nil, menuClosedHandler: ( (NSMenu) -> Void)? = nil) {
        self.title = title
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
    }

    /// Initializes a `FormSAMPopup` with the given parameters.
    /// - Parameters:
    ///   - title: The title of the popup.
    ///   - items: A dictionary of items to be displayed in the popup, where the key is the title and the value is the tag. Use an empty `String` to insert a separator.
    ///   - selectedIndex: An `Int` binding for the currently selected item in the popup.
    ///   - selectionChangedAction: The action to be performed when an item is selected from the popup. This closure gives back the item's index, title, and tag.
    ///   - itemHighlightHandler: An optional action to be performed when an item in the popup is highlighted. This closure gives back the item's index, title, tag, and enabled state.
    ///   - menuOpenHandler: An optional action to be performed when the popup is opened.
    ///   - menuClosedHandler: An optional action to be performed when the popup is closed.
    public init(title: String, items: [String : Int], selectedIndex: Binding<Int>, selectionChangedAction: ( (Int, String, Int) -> Void)? = nil, itemHighlightHandler: ( (Int, String, Int, Bool) -> Void)? = nil, menuOpenHandler: ( (NSMenu) -> Void)? = nil, menuClosedHandler: ( (NSMenu) -> Void)? = nil) {
        self.title = title
        self.items = items
        self.selectedIndex = selectedIndex
        self.selectionChangedAction = selectionChangedAction
        self.itemHighlightHandler = itemHighlightHandler
        self.menuOpenHandler = menuOpenHandler
        self.menuClosedHandler = menuClosedHandler
    }

    // MARK: - Body

    public var body: some View {
        HStack {
            Text(title)
            Spacer()
            SAMPopupSwiftUIRepresentable(borderOnHover: .constant(true), items: items, selectedIndex: selectedIndex, selectionChangedAction: selectionChangedAction, itemHighlightHandler: itemHighlightHandler, menuOpenHandler: menuOpenHandler, menuClosedHandler: menuClosedHandler)
                .accessibilityLabel(title)
        }
        
    }
    
}

// MARK: - Preview

#Preview("FormSAMPopup") {
    @Previewable @State var selection: Int = 0
    return FormSAMPopup(title: "Popup", itemTitles: ["Item 1", "Item 2"], selectedIndex: $selection)
}

// MARK: - Library Items

struct FormSAMPopupLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(FormSAMPopup(title: "Popup", itemTitles: ["Item 1", "Item 2", "Item 3"], selectedIndex: .constant(0), selectionChangedAction: nil, itemHighlightHandler: nil, menuOpenHandler: nil, menuClosedHandler: nil), visible: true, title: "SheftAppsStylishUI macOS Popup (Form-Optimized, Item Titles)", category: .control, matchingSignature: "popup")
        LibraryItem(FormSAMPopup(title: "Popup", items: ["Item 1": 1, "Item 2": 2, "Item 3": 3], selectedIndex: .constant(0), selectionChangedAction: nil, itemHighlightHandler: nil, menuOpenHandler: nil, menuClosedHandler: nil), visible: true, title: "SheftAppsStylishUI macOS Popup (Form-Optimized, Item Titles/Tags)", category: .control, matchingSignature: "popup")
    }

}
#endif
