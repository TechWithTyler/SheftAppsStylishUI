//
//  AnimatedSymbolReplacementModifier.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/23/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import SwiftUI

// MARK: - Animated Symbol Replacement Modifier

/// A view modifier that animates the replacement of an SF Symbol when an `Image` view's image changes.
///
/// On 2022 and earlier OS versions, this will do nothing.
struct AnimatedSymbolReplacementModifier: ViewModifier {
    
    @ViewBuilder
    func body(content: Content) -> some View {
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
    /// On 2022 and earlier OS versions, this will do nothing.
    @ViewBuilder
    func animatedSymbolReplacement() -> some View {
        modifier(AnimatedSymbolReplacementModifier())
    }
    
}

