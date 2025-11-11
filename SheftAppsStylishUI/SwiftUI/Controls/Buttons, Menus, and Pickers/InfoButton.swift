//
//  InfoButton.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/6/23.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

// MARK: - Imports

import SwiftUI

/// A borderless `Button` with an info icon and an optional title.
@available(tvOS 17, *)
public struct InfoButton: View {

    // MARK: - Properties - Action

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

@available(tvOS 17, *)
#Preview {
    InfoButton {

    }
    .padding()
}

// MARK: - Library Items

@available(tvOS 17, *)
struct InfoButtonLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(InfoButton("Info", action: {
            
        }), visible: true, title: "Info Button", category: .control, matchingSignature: "infobutton")
    }

}
