//
//  FormSAMPopup.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/10/24.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

#if os(macOS)
import SwiftUI

/// An `SAMPopupSwiftUIRepresentable` optimized for SwiftUI `Form` views.
public struct FormSAMPopup: View {
    
    var title: String

    var items: [String]
    
    var selectedIndex: Binding<Int>

    var selectionChangedAction: ((Int, String) -> Void)?

    var itemHighlightHandler: ((Int, String, Bool) -> Void)?

    var menuOpenHandler: ((NSMenu) -> Void)?

    var menuClosedHandler: ((NSMenu) -> Void)?
    
    /// Initializes a `FormSAMPopup` with the given parameters.
    /// - Parameters:
    ///   - title: The title of the button, which is the first item in the menu's `items` array.
    ///   - items: An array of items to be displayed in the pulldown menu.
    ///   - itemSelectedAction: The action to be performed when an item is selected from the menu.
    ///   - itemHighlightHandler: An optional action to be performed when an item in the menu is highlighted.
    ///   - menuOpenHandler: An optional action to be performed when the pulldown menu is opened.
    ///   - menuClosedHandler: An optional action to be performed when the pulldown menu is closed.
    public init(title: String, items: [String], selectedIndex: Binding<Int>, selectionChangedAction: ( (Int, String) -> Void)? = nil, itemHighlightHandler: ( (Int, String, Bool) -> Void)? = nil, menuOpenHandler: ( (NSMenu) -> Void)? = nil, menuClosedHandler: ( (NSMenu) -> Void)? = nil) {
        self.title = title
        self.items = items
        self.selectedIndex = selectedIndex
        self.selectionChangedAction = selectionChangedAction
        self.itemHighlightHandler = itemHighlightHandler
        self.menuOpenHandler = menuOpenHandler
        self.menuClosedHandler = menuClosedHandler
    }
    
    public var body: some View {
        HStack {
            Text(title)
            Spacer()
            SAMPopupSwiftUIRepresentable(borderOnHover: .constant(true), items: items, selectedIndex: selectedIndex, selectionChangedAction: selectionChangedAction, itemHighlightHandler: itemHighlightHandler, menuOpenHandler: menuOpenHandler, menuClosedHandler: menuClosedHandler)
                .accessibilityLabel(title)
        }
        
    }
    
}

#Preview("FormSAMPopup") {
    @State var selection: Int = 0
    return FormSAMPopup(title: "Popup", items: ["Item 1", "Item 2"], selectedIndex: $selection)
}
#endif
