//
//  TranslucentFooterVStack.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 11/21/23.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

import SwiftUI

/// A `VStack` with a translucent footer.
///
/// A `TranslucentFooterVStack` is useful when you want a larger translucent surface area than what a system-provided bottom bar offers.
@available(watchOS 10, *)
public struct TranslucentFooterVStack<MainContent: View, FooterContent: View>: View {
    
    let mainContent: () -> MainContent
    
    let translucentFooterContent: () -> FooterContent

    let mainAlignment: HorizontalAlignment

    let footerAlignment: HorizontalAlignment

    let mainSpacing: CGFloat?

    let footerSpacing: CGFloat?

    /// Creates a new `TranslucentFooterVStack` with the given content, alignment, and spacing.
    /// - Parameters:
    ///   - mainAlignment: Horizontal alignment of the main content.
    ///   - mainSpacing: Spacing between items in the main content.
    ///   - footerAlignment: Horizontal alignment of the translucent footer content.
    ///   - footerSpacing: Spacing between items in the translucent footer content.
    ///   - mainContent: The main content of the stack.
    ///   - translucentFooterContent: The content of the translucent footer.
    public init(mainAlignment: HorizontalAlignment = .center, mainSpacing: CGFloat? = nil, footerAlignment: HorizontalAlignment = .center, footerSpacing: CGFloat? = nil, @ViewBuilder mainContent: @escaping () -> MainContent, @ViewBuilder translucentFooterContent: @escaping () -> FooterContent) {
        self.mainContent = mainContent
        self.translucentFooterContent = translucentFooterContent
        self.mainAlignment = mainAlignment
        self.footerAlignment = footerAlignment
        self.mainSpacing = mainSpacing
        self.footerSpacing = footerSpacing
    }
    
    public var body: some View {
        VStack(alignment: mainAlignment, spacing: mainSpacing) {
            mainContent()
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack(alignment: footerAlignment, spacing: footerSpacing) {
                translucentFooterContent()
            }
            .padding(.vertical, 10)
            .background(.regularMaterial)
        }
    }
    
}

@available(watchOS 10, *)
#Preview {
    TranslucentFooterVStack {
            ScrollableText("I'm the main content of this stack. I'm very long so part of me will appear underneath the translucent footer.\nDid you know the SheftApps team was established in 2014? Swift hadn't even come out yet! Look where we are today!")
                .multilineTextAlignment(.center)
        .font(.system(size: 36))
    } translucentFooterContent: {
        VStack {
        Image(systemName: "swift")
                .font(.system(size: 36))
        Text("I'm the content the main content can scroll under.")
    }
        .frame(width: .infinity)
        .padding()
    }
}

@available(watchOS 10, *)
struct TranslucentFooterVStackLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(TranslucentFooterVStack(mainAlignment: .center, mainSpacing: nil, footerAlignment: .center, footerSpacing: nil, mainContent: {
            Text("Main content")
        }, translucentFooterContent: {
            Text("Content for translucent footer")
        }), visible: true, title: "Vertical Stack With Translucent Footer", category: .layout, matchingSignature: "verticalstacktranslucent")
    }

}
