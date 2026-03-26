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

    var step: N.Stride

    // MARK: - Properties - Strings

    var singularSuffix: String?

    var pluralSuffix: String?

    // MARK: - Properties - Dynamic Type Size

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    // MARK: - Properties - Floats

    var fittingSuffixWidth: CGFloat? {
        // 1. If the suffix is nil, return nil.
        guard let singularSuffix = singularSuffix, let pluralSuffix = pluralSuffix else {
            return nil
        }
        // 2. Calculate the width needed to fit the suffix based on the character count of the longer one. The max(_:_:) function compares the 2 numbers and returns the greater one.
        let longerSuffixCount = max(pluralSuffix.count, singularSuffix.count)
        // 3. Assuming an average character width of 8pt, multiply the count by 8.
        let width = CGFloat(longerSuffixCount) * 8
        // 4. Further determine the width based on Dynamic Type. "x" stands for extra.
        let scale: CGFloat
        switch dynamicTypeSize {
        case .xSmall:
            scale = 0.9
        case .small:
            scale = 0.95
        case .medium:
            scale = 1.0
        case .large:
            scale = 1.05
        case .xLarge:
            scale = 1.1
        case .xxLarge:
            scale = 1.2
        case .xxxLarge:
            scale = 1.3
        case .accessibility1:
            scale = 1.4
        case .accessibility2:
            scale = 1.55
        case .accessibility3:
            scale = 1.7
        case .accessibility4:
            scale = 1.9
        case .accessibility5:
            scale = 2.1
        default:
            scale = 1.0
        }
        // 5. Add padding to the label.
        let paddingAmount: CGFloat = 50
        // 6. Return the width.
        return (width * scale) + paddingAmount
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

    /// Creates a new `FormNumericTextField` with the given label, `Numeric` value `Binding`, value range, amount to step by, Boolean indicating whether to use a grouping separator, and optional suffix.
    /// - Parameters:
    ///   - label: The `View` to display as the label of the text field.
    ///   - value: The `Numeric` value of the text field.
    ///   - valueRange: The range of possible numeric values for the text field.
    ///   - step: The amount that the stepper (if visible) steps by. Defaults to 1.
    ///   - usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    ///   - suffix: An optional suffix to be displayed after the text field (e.g. "year(s) old" or "entry/ies").
    ///
    ///  If you want to use a separate singular and plural suffix based on the value of the text field, use an initializer that takes a singular and plural suffix instead.
    public init(@ViewBuilder _ label: (() -> Label), value: Binding<N>, valueRange: ClosedRange<N>, step: N.Stride = 1, usesGroupingSeparator: Bool = true, suffix: String? = nil) {
        self.label = label()
        self._value = value
        self.valueRange = valueRange
        self.step = step
        self.singularSuffix = suffix
        self.pluralSuffix = suffix
        self.usesGroupingSeparator = usesGroupingSeparator
    }

    /// Creates a new `FormNumericTextField` with the given label, `Int` value `Binding`, amount to step by, Boolean indicating whether to use a grouping separator, and optional suffix.
    /// - Parameters:
    ///   - label: The `View` to display as the label of the text field.
    ///   - value: The `Int` value of the text field.
    ///   - step: The amount that the stepper (if visible) steps by. Defaults to 1.
    ///   - usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    ///   - suffix: An optional suffix to be displayed after the text field (e.g. "year(s) old" or "entry/ies").
    ///
    ///  If you want to use a separate singular and plural suffix based on the value of the text field, use an initializer that takes a singular and plural suffix instead.
    public init(@ViewBuilder _ label: (() -> Label), value: Binding<Int>, step: Int.Stride = 1, usesGroupingSeparator: Bool = true, suffix: String? = nil) where N == Int {
        self.label = label()
        self._value = value
        self.valueRange = Int.min...Int.max
        self.step = step
        self.singularSuffix = suffix
        self.pluralSuffix = suffix
        self.usesGroupingSeparator = usesGroupingSeparator
    }

    /// Creates a new `FormNumericTextField` with the given label, `Double` value `Binding`, amount to step by, Boolean indicating whether to use a grouping separator, and optional suffix.
    /// - Parameters:
    ///   - label: The `View` to display as the label of the text field.
    ///   - value: The `Double` value of the text field.
    ///   - step: The amount that the stepper (if visible) steps by. Defaults to 1.
    ///   - usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    ///   - suffix: An optional suffix to be displayed after the text field (e.g. "year(s) old" or "entry/ies").
    ///
    ///  If you want to use a separate singular and plural suffix based on the value of the text field, use an initializer that takes a singular and plural suffix instead.
    public init(@ViewBuilder _ label: (() -> Label), value: Binding<Double>, step: Double.Stride = 1, usesGroupingSeparator: Bool = true, suffix: String? = nil) where N == Double {
        self.label = label()
        self._value = value
        self.valueRange = -Double.greatestFiniteMagnitude...Double.greatestFiniteMagnitude
        self.step = step
        self.singularSuffix = suffix
        self.pluralSuffix = suffix
        self.usesGroupingSeparator = usesGroupingSeparator
    }

    /// Creates a new `FormNumericTextField` with the given label, `Float` value `Binding`, amount to step by, Boolean indicating whether to use a grouping separator, and optional suffix.
    /// - Parameters:
    ///   - label: The `View` to display as the label of the text field.
    ///   - value: The `Float` value of the text field.
    ///   - step: The amount that the stepper (if visible) steps by. Defaults to 1.
    ///   - usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    ///   - suffix: An optional suffix to be displayed after the text field (e.g. "year(s) old" or "entry/ies").
    ///
    ///  If you want to use a separate singular and plural suffix based on the value of the text field, use an initializer that takes a singular and plural suffix instead.
    public init(@ViewBuilder _ label: (() -> Label), value: Binding<Float>, step: Float.Stride = 1, usesGroupingSeparator: Bool = true, suffix: String? = nil) where N == Float {
        self.label = label()
        self._value = value
        self.valueRange = -Float.greatestFiniteMagnitude...Float.greatestFiniteMagnitude
        self.step = step
        self.singularSuffix = suffix
        self.pluralSuffix = suffix
        self.usesGroupingSeparator = usesGroupingSeparator
    }

    /// Creates a new `FormNumericTextField` with the given label string, `Numeric` value `Binding`, value range, amount to step by, Boolean indicating whether to use a grouping separator, and optional suffix.
    /// - Parameters:
    ///   - label: The `String` to display as the label of the text field.
    ///   - value: The `Numeric` value of the text field.
    ///   - valueRange: The range of possible numeric values for the text field.
    ///   - step: The amount that the stepper (if visible) steps by. Defaults to 1.
    ///   - usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    ///   - suffix: An optional suffix to be displayed after the text field (e.g. "year(s) old" or "entry/ies").
    ///
    ///  If you want to use a separate singular and plural suffix based on the value of the text field, use an initializer that takes a singular and plural suffix instead.
    public init(_ label: String, value: Binding<N>, valueRange: ClosedRange<N>, step: N.Stride = 1, usesGroupingSeparator: Bool = true, suffix: String? = nil) where Label == Text {
        self.label = Text(label)
        self._value = value
        self.valueRange = valueRange
        self.step = step
        self.singularSuffix = suffix
        self.pluralSuffix = suffix
        self.usesGroupingSeparator = usesGroupingSeparator
    }

    /// Creates a new `FormNumericTextField` with the given label string, `Int` value `Binding`, amount to step by, Boolean indicating whether to use a grouping separator, and optional suffix.
    /// - Parameters:
    ///   - label: The `String` to display as the label of the text field.
    ///   - value: The `Int` value of the text field.
    ///   - step: The amount that the stepper (if visible) steps by. Defaults to 1.
    ///   - usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    ///   - suffix: An optional suffix to be displayed after the text field (e.g. "year(s) old" or "entry/ies").
    ///
    ///  If you want to use a separate singular and plural suffix based on the value of the text field, use an initializer that takes a singular and plural suffix instead.
    public init(_ label: String, value: Binding<Int>, step: Int.Stride = 1, usesGroupingSeparator: Bool = true, suffix: String? = nil) where Label == Text, N == Int {
        self.label = Text(label)
        self._value = value
        self.valueRange = Int.min...Int.max
        self.step = step
        self.singularSuffix = suffix
        self.pluralSuffix = suffix
        self.usesGroupingSeparator = usesGroupingSeparator
    }

    /// Creates a new `FormNumericTextField` with the given label string, `Double` value `Binding`, amount to step by, Boolean indicating whether to use a grouping separator, and optional suffix.
    /// - Parameters:
    ///   - label: The `String` to display as the label of the text field.
    ///   - value: The `Double` value of the text field.
    ///   - step: The amount that the stepper (if visible) steps by. Defaults to 1.
    ///   - usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    ///   - suffix: An optional suffix to be displayed after the text field (e.g. "year(s) old" or "entry/ies").
    ///
    ///  If you want to use a separate singular and plural suffix based on the value of the text field, use an initializer that takes a singular and plural suffix instead.
    public init(_ label: String, value: Binding<Double>, step: Double.Stride = 1, usesGroupingSeparator: Bool = true, suffix: String? = nil) where Label == Text, N == Double {
        self.label = Text(label)
        self._value = value
        self.valueRange = -Double.greatestFiniteMagnitude...Double.greatestFiniteMagnitude
        self.step = step
        self.singularSuffix = suffix
        self.pluralSuffix = suffix
        self.usesGroupingSeparator = usesGroupingSeparator
    }

    /// Creates a new `FormNumericTextField` with the given label string, `Float` value `Binding`, amount to step by, Boolean indicating whether to use a grouping separator, and optional suffix.
    /// - Parameters:
    ///   - label: The `String` to display as the label of the text field.
    ///   - value: The `Float` value of the text field.
    ///   - step: The amount that the stepper (if visible) steps by. Defaults to 1.
    ///   - usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    ///   - suffix: An optional suffix to be displayed after the text field (e.g. "year(s) old" or "entry/ies").
    ///
    ///  If you want to use a separate singular and plural suffix based on the value of the text field, use an initializer that takes a singular and plural suffix instead.
    public init(_ label: String, value: Binding<Float>, step: Float.Stride = 1, usesGroupingSeparator: Bool = true, suffix: String? = nil) where Label == Text, N == Float {
        self.label = Text(label)
        self._value = value
        self.valueRange = -Float.greatestFiniteMagnitude...Float.greatestFiniteMagnitude
        self.step = step
        self.singularSuffix = suffix
        self.pluralSuffix = suffix
        self.usesGroupingSeparator = usesGroupingSeparator
    }

    /// Creates a new `FormNumericTextField` with the given label, `Numeric` value `Binding`, value range, amount to step by, Boolean indicating whether to use a grouping separator, and suffixes.
    /// - Parameters:
    ///   - label: The `View` to display as the label of the text field.
    ///   - value: The `Numeric` value of the text field.
    ///   - valueRange: The range of possible numeric values for the text field.
    ///   - step: The amount that the stepper (if visible) steps by. Defaults to 1.
    ///   - usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    ///   - singularSuffix: The suffix to be displayed after the text field when `value` is 1 (e.g. "year old" or "entry").
    ///   - pluralSuffix: The suffix to be displayed after the text field when `value` isn't 1 (e.g. "years old" or "entries").
    ///
    ///  If you want to use the same suffix regardless of the value of the text field, use an initializer that takes a single suffix instead.
    public init(@ViewBuilder _ label: (() -> Label), value: Binding<N>, valueRange: ClosedRange<N>, step: N.Stride = 1, usesGroupingSeparator: Bool = true, singularSuffix: String, pluralSuffix: String) {
        self.label = label()
        self._value = value
        self.valueRange = valueRange
        self.step = step
        self.singularSuffix = singularSuffix
        self.pluralSuffix = pluralSuffix
        self.usesGroupingSeparator = usesGroupingSeparator
    }

    /// Creates a new `FormNumericTextField` with the given label, `Int` value `Binding`, amount to step by, Boolean indicating whether to use a grouping separator, and suffixes.
    /// - Parameters:
    ///   - label: The `View` to display as the label of the text field.
    ///   - value: The `Int` value of the text field.
    ///   - step: The amount that the stepper (if visible) steps by. Defaults to 1.
    ///   - usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    ///   - singularSuffix: The suffix to be displayed after the text field when `value` is 1 (e.g. "year old" or "entry").
    ///   - pluralSuffix: The suffix to be displayed after the text field when `value` isn't 1 (e.g. "years old" or "entries").
    ///
    ///  If you want to use the same suffix regardless of the value of the text field, use an initializer that takes a single suffix instead.
    public init(@ViewBuilder _ label: (() -> Label), value: Binding<Int>, step: Int.Stride = 1, usesGroupingSeparator: Bool = true, singularSuffix: String, pluralSuffix: String) where N == Int {
        self.label = label()
        self._value = value
        self.valueRange = Int.min...Int.max
        self.step = step
        self.singularSuffix = singularSuffix
        self.pluralSuffix = pluralSuffix
        self.usesGroupingSeparator = usesGroupingSeparator
    }

    /// Creates a new `FormNumericTextField` with the given label, `Double` value `Binding`, amount to step by, Boolean indicating whether to use a grouping separator, and suffixes.
    /// - Parameters:
    ///   - label: The `View` to display as the label of the text field.
    ///   - value: The `Double` value of the text field.
    ///   - step: The amount that the stepper (if visible) steps by. Defaults to 1.
    ///   - usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    ///   - singularSuffix: The suffix to be displayed after the text field when `value` is 1 (e.g. "year old" or "entry").
    ///   - pluralSuffix: The suffix to be displayed after the text field when `value` isn't 1 (e.g. "years old" or "entries").
    ///
    ///  If you want to use the same suffix regardless of the value of the text field, use an initializer that takes a single suffix instead.
    public init(@ViewBuilder _ label: (() -> Label), value: Binding<Double>, step: Double.Stride = 1, usesGroupingSeparator: Bool = true, singularSuffix: String, pluralSuffix: String) where N == Double {
        self.label = label()
        self._value = value
        self.valueRange = -Double.greatestFiniteMagnitude...Double.greatestFiniteMagnitude
        self.step = step
        self.singularSuffix = singularSuffix
        self.pluralSuffix = pluralSuffix
        self.usesGroupingSeparator = usesGroupingSeparator
    }

    /// Creates a new `FormNumericTextField` with the given label, `Float` value `Binding`, amount to step by, Boolean indicating whether to use a grouping separator, and suffixes.
    /// - Parameters:
    ///   - label: The `View` to display as the label of the text field.
    ///   - value: The `Float` value of the text field.
    ///   - step: The amount that the stepper (if visible) steps by. Defaults to 1.
    ///   - usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    ///   - singularSuffix: The suffix to be displayed after the text field when `value` is 1 (e.g. "year old" or "entry").
    ///   - pluralSuffix: The suffix to be displayed after the text field when `value` isn't 1 (e.g. "years old" or "entries").
    ///
    ///  If you want to use the same suffix regardless of the value of the text field, use an initializer that takes a single suffix instead.
    public init(@ViewBuilder _ label: (() -> Label), value: Binding<Float>, step: Float.Stride = 1, usesGroupingSeparator: Bool = true, singularSuffix: String, pluralSuffix: String) where N == Float {
        self.label = label()
        self._value = value
        self.valueRange = -Float.greatestFiniteMagnitude...Float.greatestFiniteMagnitude
        self.step = step
        self.singularSuffix = singularSuffix
        self.pluralSuffix = pluralSuffix
        self.usesGroupingSeparator = usesGroupingSeparator
    }

    /// Creates a new `FormNumericTextField` with the given label string, `Numeric` value `Binding`, value range, amount to step by, Boolean indicating whether to use a grouping separator, and suffixes.
    /// - Parameters:
    ///   - label: The `String` to display as the label of the text field.
    ///   - value: The `Numeric` value of the text field.
    ///   - valueRange: The range of possible numeric values for the text field.
    ///   - step: The amount that the stepper (if visible) steps by. Defaults to 1.
    ///   - usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    ///   - singularSuffix: The suffix to be displayed after the text field when `value` is 1 (e.g. "year old" or "entry").
    ///   - pluralSuffix: The suffix to be displayed after the text field when `value` isn't 1 (e.g. "years old" or "entries").
    ///
    ///  If you want to use the same suffix regardless of the value of the text field, use an initializer that takes a single suffix instead.
    public init(_ label: String, value: Binding<N>, valueRange: ClosedRange<N>, step: N.Stride = 1, usesGroupingSeparator: Bool = true, singularSuffix: String, pluralSuffix: String) where Label == Text {
        self.label = Text(label)
        self._value = value
        self.valueRange = valueRange
        self.step = step
        self.singularSuffix = singularSuffix
        self.pluralSuffix = pluralSuffix
        self.usesGroupingSeparator = usesGroupingSeparator
    }

    /// Creates a new `FormNumericTextField` with the given label string, `Numeric` value `Binding`, amount to step by, Boolean indicating whether to use a grouping separator, and suffixes.
    /// - Parameters:
    ///   - label: The `String` to display as the label of the text field.
    ///   - value: The `Numeric` value of the text field.
    ///   - step: The amount that the stepper (if visible) steps by. Defaults to 1.
    ///   - usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    ///   - singularSuffix: The suffix to be displayed after the text field when `value` is 1 (e.g. "year old" or "entry").
    ///   - pluralSuffix: The suffix to be displayed after the text field when `value` isn't 1 (e.g. "years old" or "entries").
    ///
    ///  If you want to use the same suffix regardless of the value of the text field, use an initializer that takes a single suffix instead.
    public init(_ label: String, value: Binding<Int>, step: Int.Stride = 1, usesGroupingSeparator: Bool = true, singularSuffix: String, pluralSuffix: String) where Label == Text, N == Int {
        self.label = Text(label)
        self._value = value
        self.valueRange = Int.min...Int.max
        self.step = step
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
                Stepper(value: $value, in: valueRange, step: step) {
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
        .onChange(of: value) { oldValue, newValue in
            clampToValueRange(newValue: newValue)
        }
    }

    // This method clamps the value to stay within the specified range.
    func clampToValueRange(newValue: N) {
        // 1. If the new value is higher than the highest value, clamp to the highest value.
        if newValue > valueRange.upperBound {
            self.value = valueRange.upperBound
        }
        // 2. If the new value is lower than the lowest value, clamp to the lowest value.
        if newValue < valueRange.lowerBound {
            self.value = valueRange.lowerBound
        }
    }

}

// MARK: - Preview

#Preview {
    @Previewable @State var age: Int = 1
    return Form {
        FormNumericTextField("Age", value: $age, valueRange: 0...Int.max, suffix: "year(s) old")
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

