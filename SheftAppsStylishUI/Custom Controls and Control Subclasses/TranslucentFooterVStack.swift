//
//  TranslucentFooterVStack.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 11/21/23.
//  Copyright © 2022-2023 SheftApps. All rights reserved.
//

import SwiftUI

/// A `VStack` with a translucent footer at the bottom, allowing scrollable content to extend to the bottom underneath the translucent footer.
public struct TranslucentFooterVStack<MainContent: View, FooterContent: View>: View {
    
    public var content: () -> MainContent
    
    public var translucentFooterContent: () -> FooterContent

    public init(@ViewBuilder content: @escaping () -> MainContent, @ViewBuilder translucentFooterContent: @escaping () -> FooterContent) {
        self.content = content
        self.translucentFooterContent = translucentFooterContent
    }
    
    public var body: some View {
        ZStack {
            // Content
            content()
            VStack {
                Spacer()
                VStack {
                    translucentFooterContent()
                }
                .padding()
                .background(.regularMaterial)
            }
        }
    }
}
