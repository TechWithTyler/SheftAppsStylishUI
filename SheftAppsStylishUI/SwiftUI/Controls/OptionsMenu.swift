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
@available(tvOS 17.0, *)
public struct OptionsMenu<MenuContent: View>: View {

    var title: String
    
    var menuContent: MenuContent
    
    /// Creates an `OptionsMenu` with an optional title and the given content.
    public init(_ title: String = "Options", @ViewBuilder menuContent: (() -> MenuContent)) {
		self.title = title
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

@available(tvOS 17, *)
#Preview {
    OptionsMenu {
        Text("Item 1")
        Text("Item 2")
    }
}
