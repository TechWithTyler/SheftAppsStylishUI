//
//  TextSelectabilityModifier.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/9/23.
//

import Foundation

// MARK: - Conditional Text Selectability Modifier

/// A view modifier that enables or disables text selectability in this view based on a Boolean value.
public struct TextSelectabilityModifier: ViewModifier {
    
    /// Whether text in this view is selectable.
    var isSelectable: Bool
    
    @ViewBuilder
    public func body(content: Content) -> some View {
#if os(tvOS) || os(watchOS)
        content
#else
        if isSelectable {
            content
                .textSelection(.enabled)
        } else {
            content
                .textSelection(.disabled)
        }
#endif
    }
    
}

// MARK: - View Extension

public extension View {
    
    /// Enables or disables selectability of text in this view based on the value of `selectable`.
    @ViewBuilder
    func isTextSelectable(_ selectable: Bool) -> some View {
        modifier(TextSelectabilityModifier(isSelectable: selectable))
    }
    
}
