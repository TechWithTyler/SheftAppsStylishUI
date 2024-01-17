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
    
    /// The title of the button.
    public var title: String

    /// An array of items to be displayed in the popup menu.
    public var items: [String]
    
    /// A binding to the selected index of the popup.
    public var selectedIndex: Binding<Int>

    /// An action to be performed when an item is selected from the menu.
    public var selectionChangedAction: ((Int, String) -> Void)?

    /// An action to be performed when an item in the popup is highlighted.
    public var itemHighlightHandler: ((Int, String, Bool) -> Void)?

    /// An action to be performed when the popup menu is opened.
    public var menuOpenHandler: ((NSMenu) -> Void)?

    /// An action to be performed when the popup menu is closed.
    public var menuClosedHandler: ((NSMenu) -> Void)?
    
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
