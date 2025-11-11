//
//  TranslucentFooterVStack.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 11/21/23.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

// MARK: - Imports

import SwiftUI

/// A `VStack` with a translucent footer.
///
/// A `TranslucentFooterVStack` is useful when you want a larger translucent surface area than what a system-provided bottom bar offers.
public struct TranslucentFooterVStack<MainContent: View, FooterContent: View>: View {

    // MARK: - Properties - Content

    let mainContent: () -> MainContent

    let translucentFooterContent: () -> FooterContent

    // MARK: - Properties - Alignment

    let mainAlignment: HorizontalAlignment

    let footerAlignment: HorizontalAlignment

    // MARK: - Properties - Booleans

    let usesLiquidGlass: Bool

    // MARK: - Properties - Floats

    let liquidGlassCornerRadius: CGFloat

    let mainSpacing: CGFloat?

    let footerSpacing: CGFloat?

    // MARK: - Initialization

    /// Creates a new `TranslucentFooterVStack` with the given content, alignment, and spacing.
    /// - Parameters:
    ///   - mainAlignment: Horizontal alignment of the main content.
    ///   - mainSpacing: Spacing between items in the main content.
    ///   - footerAlignment: Horizontal alignment of the translucent footer content.
    ///   - footerSpacing: Spacing between items in the translucent footer content.
    ///   - usesLiquidGlass: A Boolean value indicating whether to use the liquid glass effect for the footer on macOS/iOS/iPadOS/watchOS/tvOS 26 and later. On earlier versions, this will do nothing.
    ///   - liquidGlassCornerRadius: The corner radius of the liquid glass effect.
    ///   - mainContent: The main content of the stack.
    ///   - translucentFooterContent: The content of the translucent footer.
    public init(
        mainAlignment: HorizontalAlignment = .center,
        mainSpacing: CGFloat? = nil,
        footerAlignment: HorizontalAlignment = .center,
        footerSpacing: CGFloat? = nil,
        usesLiquidGlass: Bool = true,
        liquidGlassCornerRadius: CGFloat = SALiquidGlassPanelCornerRadius, @ViewBuilder mainContent: @escaping () -> MainContent,
        @ViewBuilder translucentFooterContent: @escaping () -> FooterContent
    ) {
        self.mainContent = mainContent
        self.translucentFooterContent = translucentFooterContent
        self.mainAlignment = mainAlignment
        self.footerAlignment = footerAlignment
        self.mainSpacing = mainSpacing
        self.footerSpacing = footerSpacing
        self.usesLiquidGlass = usesLiquidGlass
        self.liquidGlassCornerRadius = liquidGlassCornerRadius
    }

    // MARK: - Body

    public var body: some View {
        if #available(macOS 26, iOS 26, watchOS 26, tvOS 26, visionOS 26, *), usesLiquidGlass {
            mainContentStack
                .safeAreaBar(edge: .bottom, spacing: 0) {
                    translucentFooterContentStack
                    // Content padding
                    .padding(.vertical, 10)
                    .glassEffect(
                        in: .rect(cornerRadius: liquidGlassCornerRadius)
                    )
                    // Glass effect padding
                    .padding(8)
                    .buttonStyle(.glass)
                }
        } else {
            mainContentStack
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    translucentFooterContentStack
                    .padding(.vertical, 10)
                    .background(.regularMaterial)
                }
        }
    }

    // MARK: - Main Content

    @ViewBuilder
    var mainContentStack: some View {
        VStack(alignment: mainAlignment, spacing: mainSpacing) {
            mainContent()
        }
    }

    // MARK: - Translucent Footer Content

    @ViewBuilder
    var translucentFooterContentStack: some View {
        HStack {
            Spacer()
            VStack(alignment: footerAlignment, spacing: footerSpacing) {
                translucentFooterContent()
            }
            Spacer()
        }
    }

}

// MARK: - Preview

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

// MARK: - Library Items

struct TranslucentFooterVStackLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(TranslucentFooterVStack(mainAlignment: .center, mainSpacing: nil, footerAlignment: .center, footerSpacing: nil, mainContent: {
            Text("Main content")
        }, translucentFooterContent: {
            Text("Content for translucent footer")
        }), visible: true, title: "Vertical Stack With Translucent Footer", category: .layout, matchingSignature: "verticalstacktranslucent")
    }

}
