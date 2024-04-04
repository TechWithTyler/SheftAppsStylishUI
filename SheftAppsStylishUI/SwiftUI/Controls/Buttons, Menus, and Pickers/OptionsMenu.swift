//
//  OptionsMenu.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 5/29/23.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import SwiftUI

// MARK: - Options Menu

/// A menu with an ellipsis icon and an optional title as its label.
@available(tvOS 17, *)
@available(watchOS, unavailable)
public struct OptionsMenu<MenuContent: View>: View {

    /// A set of commonly-used titles for options menus.
    public enum Title : String {

        /// Title "Options"
        case options = "Options"

        /// Title "Menu"
        case menu = "Menu"

        /// Title "Action"
        case action = "Action"

    }

    var title: String
    
    var menuContent: MenuContent
    
    /// Creates an `OptionsMenu` with the given title `String` and content.
    public init(_ title: String, @ViewBuilder menuContent: (() -> MenuContent)) {
		self.title = title
        self.menuContent = menuContent()
	}

    /// Creates an `OptionsMenu` with the given `Title` and content.
    ///
    /// To use a custom title, use the initializer that takes a `String` instead of a `Title`.
    public init(title: Title = .options, @ViewBuilder menuContent: (() -> MenuContent)) {
        self.title = title.rawValue
        self.menuContent = menuContent()
    }

	public var body: some View {
        Menu {
            menuContent
        } label: {
            Label(title, systemImage: "ellipsis.circle")
                .accessibilityLabel(title)
        }
	}

}

#if !os(watchOS)
@available(tvOS 17, *)
#Preview {
    OptionsMenu(title: .menu) {
        Button("Item 1") {}
        Button("Item 2") {}
        Button("Item 3") {}
    }
}
#endif
