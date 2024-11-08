//
//  TextSelectabilityModifier.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/9/23.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import Foundation

// MARK: - Conditional Text Selectability Modifier

/// A view modifier that enables or disables text selectability in this view based on a Boolean value.
@available(watchOS, unavailable)
@available(tvOS, unavailable)
public struct TextSelectabilityModifier: ViewModifier {

    var isSelectable: Bool

    @ViewBuilder
    public func body(content: Content) -> some View {
        if isSelectable {
            content
                .textSelection(.enabled)
        } else {
            content
                .textSelection(.disabled)
        }
    }

}

// MARK: - View Extension

@available(watchOS, unavailable)
@available(tvOS, unavailable)
public extension View {

    /// Enables or disables selectability of text in this view based on the value of `selectable`.
    @ViewBuilder
    func isTextSelectable(_ selectable: Bool) -> some View {
        modifier(TextSelectabilityModifier(isSelectable: selectable))
    }

}

struct TextSelectabilityModifierLibraryProvider: LibraryContentProvider {

    func modifiers(base: AnyView) -> [LibraryItem] {
        LibraryItem(base.isTextSelectable(true), visible: true, title: "Conditional Text Selectability", category: .other, matchingSignature: "conditionaltext")
    }

}

