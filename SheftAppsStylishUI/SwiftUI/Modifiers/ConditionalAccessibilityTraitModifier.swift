//
//  ConditionalAccessibilityTraitModifier.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 9/20/24.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

import Foundation

/// A modifier that adds or removes an accessibility trait from a view based on a condition.
public struct ConditionalAccessibilityTraitModifier: ViewModifier {

    let trait: AccessibilityTraits

    let condition: Bool

    init(_ trait: AccessibilityTraits, condition: Bool) {
        self.trait = trait
        self.condition = condition
    }

    public func body(content: Content) -> some View {
        if condition {
            content
                .accessibilityAddTraits(trait)
        } else {
            content
                .accessibilityRemoveTraits(trait)
        }
    }

}

public extension View {
    /// Adds or removes `trait` from a view based on `condition`.
    ///
    /// - Parameter trait: The accessibility trait to add or remove.
    /// - Parameter condition: A Boolean value which adds or removes the accessibility trait.
    /// - Returns: A modified view with the added/removed accessibility trait.
    func accessibilityConditionalTrait(_ trait: AccessibilityTraits, condition: Bool) -> some View {
        return modifier(ConditionalAccessibilityTraitModifier(trait, condition: condition))
    }
}
