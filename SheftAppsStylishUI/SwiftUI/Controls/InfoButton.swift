//
//  InfoButton.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/6/23.
//

import SwiftUI

/// A borderless `Button` with an info icon and an optional title.
public struct InfoButton: View {
    
    /// The action closure of the info button.
    public var action: (() -> Void)
    
    /// The title of the info button.
    public var title: String?
    
    /// Creates a new `InfoButton` with the given title or nil, and the given action closure.
    public init(title: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "info.circle")
            if let title = title {
                Text(title)
            }
        }
        .accessibilityLabel(title ?? "Info")
        .buttonStyle(.borderless)
    }
    
}
