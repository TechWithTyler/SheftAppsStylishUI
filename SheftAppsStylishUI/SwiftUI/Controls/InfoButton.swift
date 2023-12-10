//
//  InfoButton.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/6/23.
//

import SwiftUI

/// A borderless `Button` with an info icon and the accessibility label "Info".
public struct InfoButton: View {
    
    public var action: (() -> Void)
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "info.circle")
        }
        .accessibilityLabel("Info")
        .buttonStyle(.borderless)
    }
    
}
