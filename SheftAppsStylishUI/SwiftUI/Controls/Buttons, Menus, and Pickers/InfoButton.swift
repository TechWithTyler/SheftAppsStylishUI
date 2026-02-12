//
//  InfoButton.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/6/23.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import SwiftUI

/// A borderless `Button` with an info icon and an optional title.
public struct InfoButton: View {

    // MARK: - Properties - Action

    // Void means "empty" or "has nothing", so many programming languages use it to indicate that a function doesn't return a value, or rather, a value with nothing inside it. In Swift closures without arguments, Void is written as an empty tuple. In all other cases, it can be written as Void or an empty tuple.
    var action: (() -> Void)

    // MARK: - Properties - Strings

    var title: String

    // MARK: - Initialization

    /// Creates a new `InfoButton` with an optional title and the given action closure.
    public init(_ title: String = "Info", action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button {
            action()
        } label: {
            Label(title, systemImage: "info.circle")
        }
        .buttonStyle(.borderless)
        #if os(iOS)
        .hoverEffect(.highlight)
        #endif
    }
    
}

// MARK: - Preview

#Preview {
    InfoButton {

    }
    .padding()
}

// MARK: - Library Items

struct InfoButtonLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(InfoButton("Info", action: {
            
        }), visible: true, title: "Info Button", category: .control, matchingSignature: "infobutton")
    }

}
