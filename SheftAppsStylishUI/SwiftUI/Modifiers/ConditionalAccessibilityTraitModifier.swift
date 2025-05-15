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
    /// - Parameter condition: A Boolean value to determine whether the accessibility trait should be added (true) or removed (false).
    /// - Returns: A modified view with the added/removed accessibility trait.
    func accessibilityConditionalTrait(_ trait: AccessibilityTraits, condition: Bool) -> some View {
        return modifier(ConditionalAccessibilityTraitModifier(trait, condition: condition))
    }
}

struct ConditionalAccessibilityTraitModifierLibraryProvider: LibraryContentProvider {

    func modifiers(base: AnyView) -> [LibraryItem] {
        LibraryItem(base.accessibilityConditionalTrait(.isButton, condition: true), visible: true, title: "Conditional Accessibility Trait", category: .control, matchingSignature: "conditionalaccessibilitytrait")
    }

}

