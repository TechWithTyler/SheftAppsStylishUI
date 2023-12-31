//
//  TranslucentFooterVStack.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 11/21/23.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import SwiftUI

/// A `VStack` with a translucent footer.
public struct TranslucentFooterVStack<MainContent: View, FooterContent: View>: View {
    
    /// The content to display above the translucent footer.
    let mainContent: () -> MainContent
    
    /// The content to display in the translucent footer.
    let translucentFooterContent: () -> FooterContent

    /// Creates a new `TranslucentFooterVStack` with the given main content and footer content.
    public init(@ViewBuilder mainContent: @escaping () -> MainContent, @ViewBuilder translucentFooterContent: @escaping () -> FooterContent) {
        self.mainContent = mainContent
        self.translucentFooterContent = translucentFooterContent
    }
    
    public var body: some View {
        VStack {
            mainContent()
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack {
                translucentFooterContent()
            }
            .padding(.vertical, 10)
            .background(.regularMaterial)
        }
    }
    
}

#Preview {
    TranslucentFooterVStack {
        ScrollableText("I'm the main content of this stack.")
    } translucentFooterContent: {
        Text("I'm the content the main content can scroll under.")
    }

}
