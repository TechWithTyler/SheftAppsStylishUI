//
//  FormNumericTextField.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 11/16/23.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import SwiftUI

/// A numeric`TextField` which always shows its title.
@available(macOS 13, iOS 16, tvOS 16, watchOS 9, visionOS 1, *)
public struct FormNumericTextField<Label, N>: View where Label: View, N: Numeric, N: Strideable {
    
    @Environment(\.formNumericTextFieldStepperVisibility) var stepperVisibility
    
    var label: Label
    
    var valueRange: ClosedRange<N>
    
    @Binding var value: N
    
    /// Creates a new `FormNumericField` with the given label and value binding.
    public init(@ViewBuilder _ label: (() -> Label), value: Binding<N>, valueRange: ClosedRange<N> = Int.min...Int.max) where Label == Text {
        self.label = label()
        self._value = value
        self.valueRange = valueRange
    }
    
    /// Creates a new `FormNumericTextField` with the given label string and value binding.
    public init(_ label: String, value: Binding<N>, valueRange: ClosedRange<N> = Int.min...Int.max) where Label == Text {
        self.label = Text(label)
        self._value = value
        self.valueRange = valueRange
    }
    
    public var body: some View {
        HStack {
#if os(macOS)
            textField
#else
            label
                .multilineTextAlignment(.leading)
            textField
#endif
            #if !os(tvOS)
            if stepperVisibility {
                Stepper(value: $value) {
                    EmptyView()
                }
                .labelsHidden()
            }
            #endif
        }
    }
    
    var textField: some View {
        TextField(value: $value, formatter: NumberFormatter()) {
            label
        }
#if os(iOS) || os(tvOS) || os(visionOS)
        .keyboardType(.numberPad)
#endif
        #if os(visionOS)
        .onChange(of: value) { oldValue, newValue in
            if newValue > valueRange.upperBound {
                self.value = valueRange.upperBound
            }
            if newValue < valueRange.lowerBound {
                self.value = valueRange.lowerBound
            }
        }
        #else
        .onChange(of: value) { value in
            if value > valueRange.upperBound {
                self.value = valueRange.upperBound
            }
            if value < valueRange.lowerBound {
                self.value = valueRange.lowerBound
            }
        }
        #endif
    }
    
}

@available(macOS 13, iOS 16, tvOS 16, watchOS 9, visionOS 1, *)
#Preview {
    @State var age: Int = 1
    return Form {
        FormNumericTextField("Age", value: $age, valueRange: .allPositivesIncludingZero)
            .formNumericTextFieldStepperVisibility(true)
    }
}
