//
//  FormNumericTextField.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 11/16/23.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import SwiftUI

/// A numeric `TextField` which always shows its title.
public struct FormNumericTextField<Label, N>: View where Label: View, N: Numeric, N: Strideable {

    // MARK: - Properties - Stepper Visibility

    @Environment(\.formNumericTextFieldStepperVisibility) var stepperVisibility

    // MARK: - Properties - Label

    var label: Label

    // MARK: - Properties - Numerics

    var valueRange: ClosedRange<N>

    @Binding var value: N

    // MARK: - Properties - Strings

    var singularSuffix: String?

    var pluralSuffix: String?

    // MARK: - Properties - Floats

    var fittingSuffixWidth: CGFloat? {
        // 1. If the suffix is nil, return nil.
        guard let singularSuffix = singularSuffix, let pluralSuffix = pluralSuffix else {
            return nil
        }
        // 2. Calculate the width needed to fit the suffix based on the character count of the longest suffix.
        let longestSuffixCount = max(
            pluralSuffix.count,
            singularSuffix.count
        )
        let width = CGFloat(longestSuffixCount) * 8 // Assuming an average character width of 7.5pt.
        // 3. Return the width.
        return width
    }

    // MARK: - Properties - Booleans

    var usesGroupingSeparator: Bool

    // MARK: - Properties - Number Formatter

    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = usesGroupingSeparator
        return formatter
    }

    // MARK: - Initialization

    /// Creates a new `FormNumericField` with the given label, `Numeric` value `Binding`, and optional suffix.
    /// - Parameters:
    ///   - label: The `View` to display as the label of the text field.
    ///   - value: The `Numeric` value of the text field.
    ///   - valueRange: The range of possible numeric values for the text field.
    ///   - usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    ///   - suffix: An optional suffix to be displayed after the text field (e.g. "year(s) old" or "entry/ies").
    ///
    ///  If you want to use a separate singular and plural suffix based on the value of the text field, use an initializer that takes a singular and plural suffix instead.
    public init(@ViewBuilder _ label: (() -> Label), value: Binding<N>, valueRange: ClosedRange<N> = Int.min...Int.max, usesGroupingSeparator: Bool = true, suffix: String? = nil) where Label == Text {
        self.label = label()
        self._value = value
        self.valueRange = valueRange
        self.singularSuffix = suffix
        self.pluralSuffix = suffix
        self.usesGroupingSeparator = usesGroupingSeparator
    }

    /// Creates a new `FormNumericTextField` with the given label string, `Numeric` value `Binding`, and optional suffix.
    /// - Parameters:
    ///   - label: The `String` to display as the label of the text field.
    ///   - value: The `Numeric` value of the text field.
    ///   - valueRange: The range of possible numeric values for the text field.
    ///   - usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    ///   - suffix: An optional suffix to be displayed after the text field (e.g. "year(s) old" or "entry/ies").
    ///
    ///  If you want to use a separate singular and plural suffix based on the value of the text field, use an initializer that takes a singular and plural suffix instead.
    public init(_ label: String, value: Binding<N>, valueRange: ClosedRange<N> = Int.min...Int.max, usesGroupingSeparator: Bool = true, suffix: String? = nil) where Label == Text {
        self.label = Text(label)
        self._value = value
        self.valueRange = valueRange
        self.singularSuffix = suffix
        self.pluralSuffix = suffix
        self.usesGroupingSeparator = usesGroupingSeparator
    }

    /// Creates a new `FormNumericField` with the given label, `Numeric` value `Binding`, and suffixes.
    /// - Parameters:
    ///   - label: The `View` to display as the label of the text field.
    ///   - value: The `Numeric` value of the text field.
    ///   - valueRange: The range of possible numeric values for the text field.
    ///   - usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    ///   - singularSuffix: The suffix to be displayed after the text field when `value` is 1 (e.g. "year old" or "entry").
    ///   - pluralSuffix: The suffix to be displayed after the text field when `value` isn't 1 (e.g. "years old" or "entries").
    ///
    ///  If you want to use the same suffix regardless of the value of the text field, use an initializer that takes a single suffix instead.
    public init(@ViewBuilder _ label: (() -> Label), value: Binding<N>, valueRange: ClosedRange<N> = Int.min...Int.max, usesGroupingSeparator: Bool = true, singularSuffix: String, pluralSuffix: String) where Label == Text {
        self.label = label()
        self._value = value
        self.valueRange = valueRange
        self.singularSuffix = singularSuffix
        self.pluralSuffix = pluralSuffix
        self.usesGroupingSeparator = usesGroupingSeparator
    }

    /// Creates a new `FormNumericTextField` with the given label string, `Numeric` value `Binding`, and suffixes.
    /// - Parameters:
    ///   - label: The `String` to display as the label of the text field.
    ///   - value: The `Numeric` value of the text field.
    ///   - valueRange: The range of possible numeric values for the text field.
    ///   - usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    ///   - singularSuffix: The suffix to be displayed after the text field when `value` is 1 (e.g. "year old" or "entry").
    ///   - pluralSuffix: The suffix to be displayed after the text field when `value` isn't 1 (e.g. "years old" or "entries").
    ///
    ///  If you want to use the same suffix regardless of the value of the text field, use an initializer that takes a single suffix instead.
    public init(_ label: String, value: Binding<N>, valueRange: ClosedRange<N> = Int.min...Int.max, usesGroupingSeparator: Bool = true, singularSuffix: String, pluralSuffix: String) where Label == Text {
        self.label = Text(label)
        self._value = value
        self.valueRange = valueRange
        self.singularSuffix = singularSuffix
        self.pluralSuffix = pluralSuffix
        self.usesGroupingSeparator = usesGroupingSeparator
    }

    // MARK: - Body

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
                    .frame(width: fittingSuffixWidth, alignment: .leading)
            }
            #if !os(tvOS)
            if stepperVisibility {
                Stepper(value: $value, in: valueRange) {
                    label
                }
                .labelsHidden()
            }
            #endif
        }
    }

    // MARK: - Text Field

    var textField: some View {
        TextField(value: $value, formatter: numberFormatter) {
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
        .onChange(of: value) { oldValue, newValue in
            if newValue > valueRange.upperBound {
                self.value = valueRange.upperBound
            }
            if newValue < valueRange.lowerBound {
                self.value = valueRange.lowerBound
            }
        }
        #endif
    }

}

// MARK: - Preview

#Preview {
    @Previewable @State var age: Int = 1
    return Form {
        FormNumericTextField("Age", value: $age, valueRange: .allPositivesIncludingZero, suffix: "year(s) old")
            .formNumericTextFieldStepperVisibility(true)
    }
}

// MARK: - Library Items

struct FormNumericTextFieldLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(FormNumericTextField({
            Text("Text Field")
        }, value: .constant(0)), visible: true, title: "Form Numeric Text Field (Label View)", category: .control, matchingSignature: "formnumerictextfield")
        LibraryItem(FormNumericTextField("Text Field", value: .constant(0)), visible: true, title: "Form Numeric Text Field (Label String)", category: .control, matchingSignature: "formnumerictextfield")
    }

}
