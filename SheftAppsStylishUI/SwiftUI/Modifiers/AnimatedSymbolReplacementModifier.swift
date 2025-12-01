//
//  AnimatedSymbolReplacementModifier.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/23/23.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import SwiftUI

/// A view modifier that animates the replacement of an SF Symbol when an `Image` view's image changes.
///
/// On 2023 OS versions, the `magicReplace` parameter will do nothing. Also note that the magic replace effect doesn't work with all SF Symbols even if they support the standard replace effect.
struct AnimatedSymbolReplacementModifier: ViewModifier {

    // MARK: - Properties - Booleans

    let magicReplace: Bool

    // MARK: - Body

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(macOS 15, iOS 18, tvOS 18, watchOS 11, visionOS 2, *), magicReplace {
            content
                .contentTransition(.symbolEffect(.replace.magic(fallback: .replace)))
        } else {
            content
                .contentTransition(.symbolEffect(.replace))
        }
    }
    
}

// MARK: - View Extension

public extension View {
    
    /// Animates the replacement of an SF Symbol when an `Image` view's image changes.
    ///
    /// On 2023 OS versions, the `magicReplace` parameter will do nothing. Also note that the magic replace effect doesn't work with all SF Symbols even if they support the standard replace effect.
    /// On 2022 and earlier OS versions, this modifier will do nothing.
    @ViewBuilder
    func animatedSymbolReplacement(magicReplace: Bool = false) -> some View {
        modifier(AnimatedSymbolReplacementModifier(magicReplace: magicReplace))
    }
    
}

// MARK: - Library Items

struct AnimatedSymbolReplacementModifierLibraryProvider: LibraryContentProvider {

    func modifiers(base: AnyView) -> [LibraryItem] {
        LibraryItem(base.animatedSymbolReplacement(magicReplace: false), visible: true, title: "Animated Symbol Replacement", category: .effect, matchingSignature: "animatedsymbol")
    }

}

