//
//  AnimatedSymbolReplacementModifier.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/23/23.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import SwiftUI

// MARK: - Animated Symbol Replacement Modifier

/// A view modifier that animates the replacement of an SF Symbol when an `Image` view's image changes.
///
/// On 2023 OS versions, the `magicReplace` parameter will do nothing.
/// On 2022 and earlier OS versions, this modifier will do nothing.
struct AnimatedSymbolReplacementModifier: ViewModifier {

    let magicReplace: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *), magicReplace {
            content
                .contentTransition(.symbolEffect(.replace.magic(fallback: .replace)))
        } else
        if #available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *) {
            content
                .contentTransition(.symbolEffect(.replace))
        } else {
            content
        }
    }
    
}

// MARK: - View Extension

public extension View {
    
    /// Animates the replacement of an SF Symbol when an `Image` view's image changes.
    ///
    /// On 2023 OS versions, the `magicReplace` parameter will do nothing.
    /// On 2022 and earlier OS versions, this modifier will do nothing.
    @ViewBuilder
    func animatedSymbolReplacement(magicReplace: Bool = false) -> some View {
        modifier(AnimatedSymbolReplacementModifier(magicReplace: magicReplace))
    }
    
}

struct AnimatedSymbolReplacementModifierLibraryProvider: LibraryContentProvider {

    func modifiers(base: AnyView) -> [LibraryItem] {
        LibraryItem(base.animatedSymbolReplacement(magicReplace: false), visible: true, title: "Animated Symbol Replacement", category: .effect, matchingSignature: "animatedsymbol")
    }

}

