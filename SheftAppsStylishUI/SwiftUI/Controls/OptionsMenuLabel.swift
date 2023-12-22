//
//  OptionsMenuLabel.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 5/29/23.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import SwiftUI

// MARK: - Options Menu

/// A menu with an ellipsis icon and an optional title as its label.
public struct OptionsMenu<MenuContent: View>: View {

    /// The title of the options menu.
	public var title: String
    
    /// The content of the options menu.
    public var menuContent: MenuContent
    
    /// Creates an `OptionsMenuLabel` with the givven title and style.
    public init(title: String = "Options", @ViewBuilder menuContent: (() -> MenuContent)) {
		self.title = title
        self.menuContent = menuContent()
	}

	public var body: some View {
        Menu {
            menuContent
        } label: {
            Label(title, systemImage: "ellipsis.circle")
        }
        .accessibilityLabel(title)
	}

}

#Preview {
    OptionsMenu {
        Text("Item 1")
        Text("Item 2")
    }
}
