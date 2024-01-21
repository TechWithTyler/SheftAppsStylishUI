//
//  FormNumericTextFieldStepperVisibilityModifier.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/20/24.
//  Copyright © 2024 SheftApps. All rights reserved.
//

import Foundation

/// A modifier that sets the visibility of the stepper for `FormNumericTextField`s in a view.
public struct FormNumericTextFieldStepperVisibilityModifier: ViewModifier {
    
    let isVisible: Bool
    
    init(_ isVisible: Bool) {
        self.isVisible = isVisible
    }

    public func body(content: Content) -> some View {
        content.environment(\.formNumericTextFieldStepperVisibility, isVisible)
    }
    
}

public extension View {
    /// Sets the visibility of the stepper for `FormNumericTextField`s in this view.
    ///
    /// - Parameter isVisible: A boolean value indicating whether the stepper should be visible.
    /// - Returns: A modified view with the stepper visibility.
    func formNumericTextFieldStepperVisibility(_ isVisible: Bool) -> some View {
        return modifier(FormNumericTextFieldStepperVisibilityModifier(isVisible))
    }
}

struct FormNumericTextFieldStepperVisibilityKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

extension EnvironmentValues {
    var formNumericTextFieldStepperVisibility: Bool {
        get { self[FormNumericTextFieldStepperVisibilityKey.self] }
        set { self[FormNumericTextFieldStepperVisibilityKey.self] = newValue }
    }
}
