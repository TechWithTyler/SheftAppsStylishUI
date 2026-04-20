//
//  FormNumericTextFieldStepperVisibilityModifier.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/20/24.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import Foundation

// Many modifiers, like this one, set environment values. SomeView.formNumericTextFieldStepperVisible(<#value#>) can also be written as SomeView.environment(\.formNumericTextFieldStepperVisibility, <#value#>).
/// A modifier that sets the visibility of the stepper for `FormNumericTextField`s in a view.
public struct FormNumericTextFieldStepperVisibilityModifier: ViewModifier {

    // MARK: - Properties - Booleans

    let isVisible: Bool

    // MARK: - Initialization

    init(_ isVisible: Bool) {
        self.isVisible = isVisible
    }

    // MARK: - Body

    public func body(content: Content) -> some View {
        content.environment(\.formNumericTextFieldStepperVisibility, isVisible)
    }
    
}

// MARK: - View Extension

public extension View {

    /// Sets the visibility of the stepper for `FormNumericTextField`s in this view.
    ///
    /// - Parameter isVisible: A Boolean value indicating whether the stepper should be visible.
    /// - Returns: A modified view with the stepper visibility.
    func formNumericTextFieldStepperVisible(_ isVisible: Bool) -> some View {
        return modifier(FormNumericTextFieldStepperVisibilityModifier(isVisible))
    }
    
}

// MARK: - Environment Key

struct FormNumericTextFieldStepperVisibilityKey: EnvironmentKey {

    static var defaultValue: Bool = false

}

// MARK: - EnvironmentValues Extension

public extension EnvironmentValues {

    /// The `FormNumericTextField` stepper visibility of this environment.
    var formNumericTextFieldStepperVisibility: Bool {
        // Get the value from the environment key.
        get { self[FormNumericTextFieldStepperVisibilityKey.self] }
        // Set the value of the environment key to the new value.
        set { self[FormNumericTextFieldStepperVisibilityKey.self] = newValue }
    }

}

// MARK: - Library Items

struct FormNumericTextFieldStepperVisibilityModifierLibraryProvider: LibraryContentProvider {

    func modifiers(base: AnyView) -> [LibraryItem] {
        LibraryItem(base.formNumericTextFieldStepperVisible(true), visible: true, title: "Form Numeric Text Field Stepper Visibility", category: .control, matchingSignature: "formnumerictextfieldstepper")
    }

}
