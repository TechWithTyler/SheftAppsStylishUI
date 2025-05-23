//
//  FormNumericTextField.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 11/16/23.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

import SwiftUI

/// A numeric `TextField` which always shows its title.
public struct FormNumericTextField<Label, N>: View where Label: View, N: Numeric, N: Strideable {
    
    @Environment(\.formNumericTextFieldStepperVisibility) var stepperVisibility
    
    var label: Label
    
    var valueRange: ClosedRange<N>
    
    @Binding var value: N

    var singularSuffix: String?

    var pluralSuffix: String?

    /// Creates a new `FormNumericField` with the given label, value binding, and optional suffix.
    /// - Parameters:
    ///   - label: The `View` to display as the label of the text field.
    ///   - value: The numeric value of the text field.
    ///   - valueRange: The range of possible numeric values for the text field.
    ///   - suffix: An optional suffix to be displayed after the text field (e.g. "year(s) old" or "entry/ies").
    ///
    ///  If you want to use a separate singular and plural suffix based on the value of the text field, use an initializer that takes a singular and plural suffix instead.
    public init(@ViewBuilder _ label: (() -> Label), value: Binding<N>, valueRange: ClosedRange<N> = Int.min...Int.max, suffix: String? = nil) where Label == Text {
        self.label = label()
        self._value = value
        self.valueRange = valueRange
        self.singularSuffix = suffix
        self.pluralSuffix = suffix
    }
    
    /// Creates a new `FormNumericTextField` with the given label string, value binding, and optional suffix.
    /// - Parameters:
    ///   - label: The `String` to display as the label of the text field.
    ///   - value: The numeric value of the text field.
    ///   - valueRange: The range of possible numeric values for the text field.
    ///   - suffix: An optional suffix to be displayed after the text field (e.g. "year(s) old" or "entry/ies").
    ///
    ///  If you want to use a separate singular and plural suffix based on the value of the text field, use an initializer that takes a singular and plural suffix instead.
    public init(_ label: String, value: Binding<N>, valueRange: ClosedRange<N> = Int.min...Int.max, suffix: String? = nil) where Label == Text {
        self.label = Text(label)
        self._value = value
        self.valueRange = valueRange
        self.singularSuffix = suffix
        self.pluralSuffix = suffix
    }

    /// Creates a new `FormNumericField` with the given label, value binding, and suffixes.
    /// - Parameters:
    ///   - label: The `View` to display as the label of the text field.
    ///   - value: The numeric value of the text field.
    ///   - valueRange: The range of possible numeric values for the text field.
    ///   - singularSuffix: The suffix to be displayed after the text field when `value` is 1 (e.g. "year old" or "entry").
    ///   - pluralSuffix: The suffix to be displayed after the text field when `value` isn't 1 (e.g. "years old" or "entries").
    ///
    ///  If you want to use the same suffix regardless of the value of the text field, use an initializer that takes a single suffix instead.
    public init(@ViewBuilder _ label: (() -> Label), value: Binding<N>, valueRange: ClosedRange<N> = Int.min...Int.max, singularSuffix: String, pluralSuffix: String) where Label == Text {
        self.label = label()
        self._value = value
        self.valueRange = valueRange
        self.singularSuffix = singularSuffix
        self.pluralSuffix = pluralSuffix
    }

    /// Creates a new `FormNumericTextField` with the given label string, value binding, and suffixes.
    /// - Parameters:
    ///   - label: The `String` to display as the label of the text field.
    ///   - value: The numeric value of the text field.
    ///   - valueRange: The range of possible numeric values for the text field.
    ///   - singularSuffix: The suffix to be displayed after the text field when `value` is 1 (e.g. "year old" or "entry").
    ///   - pluralSuffix: The suffix to be displayed after the text field when `value` isn't 1 (e.g. "years old" or "entries").
    ///
    ///  If you want to use the same suffix regardless of the value of the text field, use an initializer that takes a single suffix instead.
    public init(_ label: String, value: Binding<N>, valueRange: ClosedRange<N> = Int.min...Int.max, singularSuffix: String, pluralSuffix: String) where Label == Text {
        self.label = Text(label)
        self._value = value
        self.valueRange = valueRange
        self.singularSuffix = singularSuffix
        self.pluralSuffix = pluralSuffix
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
            if let singularSuffix = singularSuffix, let pluralSuffix = pluralSuffix {
                Text(value == 1 ? singularSuffix : pluralSuffix)
            }
            #if !os(tvOS)
            if stepperVisibility {
                Stepper(value: $value, in: valueRange) {
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

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
#Preview {
    @Previewable @State var age: Int = 1
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
