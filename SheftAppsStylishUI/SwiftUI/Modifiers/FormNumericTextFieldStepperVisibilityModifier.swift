//
//  FormNumericTextFieldStepperVisibilityModifier.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/20/24.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import Foundation

/// A modifier that sets the visibility of the stepper for `FormNumericTextField`s in a view.
@available(macOS 13, iOS 16, tvOS 16, watchOS 9, visionOS 1, *)
public struct FormNumericTextFieldStepperVisibilityModifier: ViewModifier {
    
    let isVisible: Bool
    
    init(_ isVisible: Bool) {
        self.isVisible = isVisible
    }

    public func body(content: Content) -> some View {
        content.environment(\.formNumericTextFieldStepperVisibility, isVisible)
    }
    
}

@available(macOS 13, iOS 16, tvOS 16, watchOS 9, visionOS 1, *)
public extension View {
    /// Sets the visibility of the stepper for `FormNumericTextField`s in this view.
    ///
    /// - Parameter isVisible: A boolean value indicating whether the stepper should be visible.
    /// - Returns: A modified view with the stepper visibility.
    func formNumericTextFieldStepperVisibility(_ isVisible: Bool) -> some View {
        return modifier(FormNumericTextFieldStepperVisibilityModifier(isVisible))
    }
}

@available(macOS 13, iOS 16, tvOS 16, watchOS 9, visionOS 1, *)
struct FormNumericTextFieldStepperVisibilityKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

@available(macOS 13, iOS 16, tvOS 16, watchOS 9, visionOS 1, *)
public extension EnvironmentValues {

    /// The `FormNumericTextField` stepper visibility of this environment.
    var formNumericTextFieldStepperVisibility: Bool {
        get { self[FormNumericTextFieldStepperVisibilityKey.self] }
        set { self[FormNumericTextFieldStepperVisibilityKey.self] = newValue }
    }
}

@available(macOS 13, iOS 16, tvOS 16, watchOS 9, visionOS 1, *)
struct FormNumericTextFieldStepperVisibilityModifierLibraryProvider: LibraryContentProvider {

    func modifiers(base: AnyView) -> [LibraryItem] {
        LibraryItem(base.formNumericTextFieldStepperVisibility(true), visible: true, title: "Form Numeric Text Field Stepper Visibility", category: .control, matchingSignature: "formnumerictextfieldstepper")
    }

}
