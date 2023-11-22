//
//  TranslucentFooterVStack.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 11/21/23.
//  Copyright © 2022-2023 SheftApps. All rights reserved.
//

import SwiftUI

/// A `VStack` with a translucent footer.
public struct TranslucentFooterVStack<MainContent: View, FooterContent: View>: View {
    
    let content: () -> MainContent
    
    let translucentFooterContent: () -> FooterContent

    public init(@ViewBuilder content: @escaping () -> MainContent, @ViewBuilder translucentFooterContent: @escaping () -> FooterContent) {
        self.content = content
        self.translucentFooterContent = translucentFooterContent
    }
    
    public var body: some View {
        VStack {
            content()
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack {
                translucentFooterContent()
            }
            .padding(.top, 10)
            .background(.regularMaterial)
        }
    }
}
