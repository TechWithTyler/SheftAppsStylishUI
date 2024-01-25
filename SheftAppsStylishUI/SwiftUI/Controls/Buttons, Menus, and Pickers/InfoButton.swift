//
//  InfoButton.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/6/23.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import SwiftUI

/// A borderless `Button` with an info icon and an optional title.
@available(tvOS 17, *)
public struct InfoButton: View {
    
    var action: (() -> Void)
    
    var title: String?
    
    /// Creates a new `InfoButton` with an optional title and the given action closure.
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
        #if os(iOS)
        .hoverEffect(.highlight)
        #endif
    }
    
}

@available(tvOS 17, *)
#Preview {
    InfoButton(title: nil) {
        
    }
}
