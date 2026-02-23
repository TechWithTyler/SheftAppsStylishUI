//
//  UnknowableStepper.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 2/19/26.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import SwiftUI

/// A `Stepper` which can select from a range of known values, as well as -1 to indicate "unknown".
/// - Important: Negative numbers shouldn't be used. -1 is reserved as the "unknown" value.
// Use & to combine 2 protocol conformance checks into one. In this case, Value is anything that conforms to Strideable, Comparable, and ExpressibleByIntegerLiteral. ExpressibleByIntegerLiteral is used for the unknownValue property's value, -1.
public struct UnknowableStepper<Value, Label>: View where Value: Strideable & Comparable & ExpressibleByIntegerLiteral, Value.Stride : SignedNumeric, Label: View {

    // MARK: - Properties - Values

    @Binding var value: Value

    let minValue: Value

    let maxValue: Value

    var unknownValue: Value = -1

    // MARK: - Properties - Step

    // Since Strideable is among the adopted protocols of whatever type Value is, it has a Stride associated type, which conforms to Comparable and SignedNumeric.
    let step: Value.Stride

    // MARK: - Properties - Labels

    let label: Label

    // MARK: - Properties - Allowed Range

    var allowedRange: ClosedRange<Value> {
        return unknownValue...maxValue
    }

    // MARK: - Initialization

    /// Creates a new `UnknowableStepper` with the given value `Binding`, value range, step amount, and label.
    /// - Parameters:
    ///   - value: A `Binding` to the current value.
    ///   - range: The range of known values.
    ///   - step: The amount to step by.
    ///   - label: A label `View`.
    public init(value: Binding<Value>, in range: ClosedRange<Value>, step: Value.Stride = 1, @ViewBuilder label: () -> Label) {
        self._value = value
        self.minValue = range.lowerBound
        self.maxValue = range.upperBound
        self.step = step
        self.label = label()
    }

    /// Creates a new `UnknowableStepper` with the given title `String`, value `Binding`, value range, and step amount.
    /// - Parameters:
    ///   - title: The title of the stepper.
    ///   - value: A `Binding` to the current value.
    ///   - range: The range of known values.
    ///   - step: The amount to step by.
    public init(_ title: String, value: Binding<Value>, in range: ClosedRange<Value>, step: Value.Stride = 1) where Label == Text {
        self.label = Text(title)
        self._value = value
        self.minValue = range.lowerBound
        self.maxValue = range.upperBound
        self.step = step
    }

    public var body: some View {
        Stepper(value: $value, in: allowedRange, step: step) {
            label
        }
        .onChange(of: value) { oldValue, newValue in
            handleValueChange(oldValue: oldValue, newValue: newValue)
        }
    }

    // This method sets the value to unknownValue if newValue is less than oldValue and minValue, or minValue if newValue is greater than oldValue and oldValue is unknownValue.
    func handleValueChange(oldValue: Value, newValue: Value) {
        if newValue < oldValue && newValue < minValue {
            value = unknownValue
        } else if newValue > oldValue && oldValue == unknownValue {
            value = minValue
        }
    }

}

#Preview {
    @Previewable @State var age: Double = 5.0
    UnknowableStepper("Age: \(age)", value: $age, in: 0.5...15.0, step: 0.5)
}
