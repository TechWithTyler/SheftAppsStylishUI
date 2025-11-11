//
//  ConditionalAccessibilityTraitModifier.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 9/20/24.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

// MARK: - Imports

import Foundation

/// A modifier that adds or removes an accessibility trait from a view based on a condition.
public struct ConditionalAccessibilityTraitModifier: ViewModifier {

    // MARK: - Properties - Accessibility Traits

    let trait: AccessibilityTraits

    // MARK: - Properties - Booleans

    let condition: Bool

    // MARK: - Initialization

    init(_ trait: AccessibilityTraits, condition: Bool) {
        self.trait = trait
        self.condition = condition
    }

    // MARK: - Body

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

// MARK: - View Extension

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

// MARK: - Library Items

struct ConditionalAccessibilityTraitModifierLibraryProvider: LibraryContentProvider {

    func modifiers(base: AnyView) -> [LibraryItem] {
        LibraryItem(base.accessibilityConditionalTrait(.isButton, condition: true), visible: true, title: "Conditional Accessibility Trait", category: .control, matchingSignature: "conditionalaccessibilitytrait")
    }

}

