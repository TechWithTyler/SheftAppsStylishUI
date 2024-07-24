//
//  FormNumericTextField.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 11/16/23.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import SwiftUI

/// A numeric`TextField` which always shows its title.
public struct FormNumericTextField<Label, N>: View where Label: View, N: Numeric, N: Strideable {
    
    @Environment(\.formNumericTextFieldStepperVisibility) var stepperVisibility
    
    var label: Label
    
    var valueRange: ClosedRange<N>
    
    @Binding var value: N

    var suffix: String?

    /// Creates a new `FormNumericField` with the given label, value binding, and optional suffix.
    /// - Parameters:
    ///  - label: The `View` to display as the label of the text field.
    ///  - value: The numeric value of the text field.
    ///  - valueRange: The range of possible numeric values for the text field.
    ///  - suffix: An optional suffix to be displayed after the text field (e.g. "year(s) old" or "entry/ies").
    public init(@ViewBuilder _ label: (() -> Label), value: Binding<N>, valueRange: ClosedRange<N> = Int.min...Int.max, suffix: String? = nil) where Label == Text {
        self.label = label()
        self._value = value
        self.valueRange = valueRange
        self.suffix = suffix
    }
    
    /// Creates a new `FormNumericTextField` with the given label string, value binding, and optional suffix.
    /// - Parameters:
    ///  - label: The `String` to display as the label of the text field.
    ///  - value: The numeric value of the text field.
    ///  - valueRange: The range of possible numeric values for the text field.
    ///  - suffix: An optional suffix to be displayed after the text field (e.g. "year(s) old" or "entry/ies").
    public init(_ label: String, value: Binding<N>, valueRange: ClosedRange<N> = Int.min...Int.max, suffix: String? = nil) where Label == Text {
        self.label = Text(label)
        self._value = value
        self.valueRange = valueRange
        self.suffix = suffix
    }
    
    public var body: some View {
        HStack {
#if os(macOS)
            textField
#else
            label
                .multilineTextAlignment(.leading)
            textField
                .multilineTextAlignment(.trailing)
#endif
            if let suffix = suffix {
                Text(suffix)
            }
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

#Preview {
    @State var age: Int = 1
    return Form {
        FormNumericTextField("Age", value: $age, valueRange: .allPositivesIncludingZero, suffix: "year(s) old")
            .formNumericTextFieldStepperVisibility(true)
    }
}

struct FormNumericTextFieldLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(FormNumericTextField({
            Text("Text Field")
        }, value: .constant(0)), visible: true, title: "Form Numeric Text Field (Label View)", category: .control, matchingSignature: "formnumerictextfield")
        LibraryItem(FormNumericTextField("Text Field", value: .constant(0)), visible: true, title: "Form Numeric Text Field (Label String)", category: .control, matchingSignature: "formnumerictextfield")
    }

}
