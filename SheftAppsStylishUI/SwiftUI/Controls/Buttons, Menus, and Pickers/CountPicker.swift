//
//  CountPicker.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 11/25/25.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import SwiftUI

/// A `Picker` for choosing a number.
public struct CountPicker<Label: View>: View {

    // MARK: - Properties - Label

    var label: Label

    // MARK: - Properties - Selection

    @Binding var selection: Int

    // MARK: - Properties - Integers

    var numbers: [Int]

    // MARK: - Properties - Strings

    var noneTitle: String?

    var unlimitedTitle: String?

    var unknownTitle: String?

    var singularSuffix: String?

    var pluralSuffix: String?

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

    /// Creates a new `CountPicker` with the given label, selection binding, numbers array, Boolean indicating whether to show a grouping separator, singular and plural suffixes, optional "none" option title, and optional "unlimited" option title.
    /// - Parameter label: The label for the picker.
    /// - Parameter selection: A `Binding` to a selection value.
    /// - Parameter numbers: An array of numbers to include in the picker.
    /// - Parameter usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    /// - Parameter singularSuffix: The suffix to be displayed after single numbers.
    /// - Parameter pluralSuffix: The suffix to be displayed after plural numbers.
    /// - Parameter unknownTitle: An optional title of the "unknown" option. If `nil`, this option isn't included.
    /// - Parameter noneTitle: An optional title of the "none" option. If `nil`, this option isn't included.
    /// - Parameter unlimitedTitle: An optional title of the "unlimited" option. If `nil`, this option isn't included.
    /// 
    /// If you want to use the same suffix for every number, use an initializer that takes a single suffix instead.
    public init(@ViewBuilder label: @escaping (() -> Label), selection: Binding<Int>, numbers: [Int], usesGroupingSeparator: Bool = true, singularSuffix: String, pluralSuffix: String, unknownTitle: String? = nil, noneTitle: String? = nil, unlimitedTitle: String? = nil) {
        self._selection = selection
        self.label = label()
        self.numbers = numbers
        self.usesGroupingSeparator = usesGroupingSeparator
        self.singularSuffix = singularSuffix
        self.pluralSuffix = pluralSuffix
        self.unknownTitle = unknownTitle
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` with the given label, selection binding, numbers array, Boolean indicating whether to show a grouping separator, suffix, optional "none" option title, and optional "unlimited" option title.
    /// - Parameter label: The label for the picker.
    /// - Parameter selection: A `Binding` to a selection value.
    /// - Parameter numbers: An array of numbers to include in the picker.
    /// - Parameter usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    /// - Parameter suffix: An optional suffix to be displayed after each number.
    /// - Parameter unknownTitle: An optional title of the "unknown" option. If `nil`, this option isn't included.
    /// - Parameter noneTitle: An optional title of the "none" option. If `nil`, this option isn't included.
    /// - Parameter unlimitedTitle: An optional title of the "unlimited" option. If `nil`, this option isn't included.
    ///
    /// If you want to use a separate suffix for singular and plural numbers, use an initializer that takes a singular and plural suffix instead.
    public init(@ViewBuilder label: @escaping (() -> Label), selection: Binding<Int>, numbers: [Int], usesGroupingSeparator: Bool = true, suffix: String? = nil, unknownTitle: String? = nil, noneTitle: String? = nil, unlimitedTitle: String? = nil) {
        self._selection = selection
        self.label = label()
        self.numbers = numbers
        self.usesGroupingSeparator = usesGroupingSeparator
        self.singularSuffix = suffix
        self.pluralSuffix = suffix
        self.unknownTitle = unknownTitle
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` with the given title, selection binding, numbers array, Boolean indicating whether to show a grouping separator, singular and plural suffixes, optional "none" option title, and optional "unlimited" option title.
    /// - Parameter title: The title for the picker.
    /// - Parameter selection: A `Binding` to a selection value.
    /// - Parameter numbers: An array of numbers to include in the picker.
    /// - Parameter usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    /// - Parameter singularSuffix: The suffix to be displayed after single numbers.
    /// - Parameter pluralSuffix: The suffix to be displayed after plural numbers.
    /// - Parameter unknownTitle: An optional title of the "unknown" option. If `nil`, this option isn't included.
    /// - Parameter noneTitle: An optional title of the "none" option. If `nil`, this option isn't included.
    /// - Parameter unlimitedTitle: An optional title of the "unlimited" option. If `nil`, this option isn't included.
    ///
    /// If you want to use the same suffix for every number, use an initializer that takes a single suffix instead.
    public init(_ title: String, selection: Binding<Int>, numbers: [Int], usesGroupingSeparator: Bool = true, singularSuffix: String, pluralSuffix: String, unknownTitle: String? = nil, noneTitle: String? = nil, unlimitedTitle: String? = nil) where Label == Text {
        self.label = Text(title)
        self._selection = selection
        self.numbers = numbers
        self.usesGroupingSeparator = usesGroupingSeparator
        self.singularSuffix = singularSuffix
        self.pluralSuffix = pluralSuffix
        self.unknownTitle = unknownTitle
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` with the given title, selection binding, numbers array, Boolean indicating whether to show a grouping separator, suffix, optional "none" option title, and optional "unlimited" option title.
    /// - Parameter title: The title for the picker.
    /// - Parameter selection: A `Binding` to a selection value.
    /// - Parameter numbers: An array of numbers to include in the picker.
    /// - Parameter usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    /// - Parameter suffix: An optional suffix to be displayed after each number.
    /// - Parameter unknownTitle: An optional title of the "unknown" option. If `nil`, this option isn't included.
    /// - Parameter noneTitle: An optional title of the "none" option. If `nil`, this option isn't included.
    /// - Parameter unlimitedTitle: An optional title of the "unlimited" option. If `nil`, this option isn't included.
    ///
    /// If you want to use a separate suffix for singular and plural numbers, use an initializer that takes a singular and plural suffix instead.
    public init(_ title: String, selection: Binding<Int>, numbers: [Int], usesGroupingSeparator: Bool = true, suffix: String? = nil, unknownTitle: String? = nil, noneTitle: String? = nil, unlimitedTitle: String? = nil) where Label == Text {
        self.label = Text(title)
        self._selection = selection
        self.numbers = numbers
        self.usesGroupingSeparator = usesGroupingSeparator
        self.singularSuffix = suffix
        self.pluralSuffix = suffix
        self.unknownTitle = unknownTitle
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` with the given label, selection binding, number range, Boolean indicating whether to show a grouping separator, singular and plural suffixes, optional "none" option title, and optional "unlimited" option title.
    /// - Parameter label: The label for the picker.
    /// - Parameter selection: A `Binding` to a selection value.
    /// - Parameter numberRange: A range of numbers to include in the picker.
    /// - Parameter usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    /// - Parameter singularSuffix: The suffix to be displayed after single numbers.
    /// - Parameter pluralSuffix: The suffix to be displayed after plural numbers.
    /// - Parameter unknownTitle: An optional title of the "unknown" option. If `nil`, this option isn't included.
    /// - Parameter noneTitle: An optional title of the "none" option. If `nil`, this option isn't included.
    /// - Parameter unlimitedTitle: An optional title of the "unlimited" option. If `nil`, this option isn't included.
    ///
    /// If you want to use the same suffix for every number, use an initializer that takes a single suffix instead.
    public init(@ViewBuilder label: @escaping (() -> Label), selection: Binding<Int>, numberRange: ClosedRange<Int>, usesGroupingSeparator: Bool = true, singularSuffix: String, pluralSuffix: String, unknownTitle: String? = nil, noneTitle: String? = nil, unlimitedTitle: String? = nil) {
        // 1. Create an array to hold the numbers.
        var numberRangeAsArray: [Int] = []
        // 2. Add each number from the range to the array.
        for n in numberRange {
            numberRangeAsArray.append(n)
        }
        // 3. Set up the picker.
        self._selection = selection
        self.label = label()
        self.numbers = numberRangeAsArray
        self.usesGroupingSeparator = usesGroupingSeparator
        self.singularSuffix = singularSuffix
        self.pluralSuffix = pluralSuffix
        self.unknownTitle = unknownTitle
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` with the given label, selection binding, number range, Boolean indicating whether to show a grouping separator, a single suffix applied to all numbers, optional "none" option title, and optional "unlimited" option title.
    ///
    /// If you want to use a separate suffix for singular and plural numbers, use an initializer that takes a singular and plural suffix instead.
    public init(@ViewBuilder label: @escaping (() -> Label), selection: Binding<Int>, numberRange: ClosedRange<Int>, usesGroupingSeparator: Bool = true, suffix: String? = nil, unknownTitle: String? = nil, noneTitle: String? = nil, unlimitedTitle: String? = nil) {
        // 1. Create an array to hold the numbers.
        var numberRangeAsArray: [Int] = []
        // 2. Add each number from the range to the array.
        for n in numberRange { numberRangeAsArray.append(n) }
        // 3. Set up the picker.
        self._selection = selection
        self.label = label()
        self.numbers = numberRangeAsArray
        self.usesGroupingSeparator = usesGroupingSeparator
        self.singularSuffix = suffix
        self.pluralSuffix = suffix
        self.unknownTitle = unknownTitle
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` with the given title, selection binding, number range, Boolean indicating whether to show a grouping separator, singular and plural suffixes, optional "none" option title, and optional "unlimited" option title.
    /// - Parameter title: The title for the picker.
    /// - Parameter selection: A `Binding` to a selection value.
    /// - Parameter numberRange: A range of numbers to include in the picker.
    /// - Parameter usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    /// - Parameter singularSuffix: The suffix to be displayed after single numbers.
    /// - Parameter pluralSuffix: The suffix to be displayed after plural numbers.
    /// - Parameter unknownTitle: An optional title of the "unknown" option. If `nil`, this option isn't included.
    /// - Parameter noneTitle: An optional title of the "none" option. If `nil`, this option isn't included.
    /// - Parameter unlimitedTitle: An optional title of the "unlimited" option. If `nil`, this option isn't included.
    ///
    /// If you want to use the same suffix for every number, use an initializer that takes a single suffix instead.
    public init(_ title: String, selection: Binding<Int>, numberRange: ClosedRange<Int>, usesGroupingSeparator: Bool = true, singularSuffix: String, pluralSuffix: String, unknownTitle: String? = nil, noneTitle: String? = nil, unlimitedTitle: String? = nil) where Label == Text {
        // 1. Create an array to hold the numbers.
        var numberRangeAsArray: [Int] = []
        // 2. Add the numbers from the range to the array.
        for n in numberRange {
            numberRangeAsArray.append(n)
        }
        // 3. Set up the picker.
        self.label = Text(title)
        self._selection = selection
        self.numbers = numberRangeAsArray
        self.usesGroupingSeparator = usesGroupingSeparator
        self.singularSuffix = singularSuffix
        self.pluralSuffix = pluralSuffix
        self.unknownTitle = unknownTitle
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` with the given title, selection binding, number range, Boolean indicating whether to show a grouping separator, a single suffix applied to all numbers, optional "none" option title, and optional "unlimited" option title.
    ///
    /// If you want to use a separate suffix for singular and plural numbers, use an initializer that takes a singular and plural suffix instead.
    public init(_ title: String, selection: Binding<Int>, numberRange: ClosedRange<Int>, usesGroupingSeparator: Bool = true, suffix: String? = nil, unknownTitle: String? = nil, noneTitle: String? = nil, unlimitedTitle: String? = nil) where Label == Text {
        // 1. Create an array to hold the numbers.
        var numberRangeAsArray: [Int] = []
        // 2. Add the numbers from the range to the array.
        for n in numberRange { numberRangeAsArray.append(n) }
        // 3. Set up the picker.
        self.label = Text(title)
        self._selection = selection
        self.numbers = numberRangeAsArray
        self.usesGroupingSeparator = usesGroupingSeparator
        self.singularSuffix = suffix
        self.pluralSuffix = suffix
        self.unknownTitle = unknownTitle
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` with the given label, selection binding, end number, Boolean indicating whether to show a grouping separator, singular and plural suffixes, optional "none" option title, and optional "unlimited" option title.
    /// - Parameter label: The label for the picker.
    /// - Parameter selection: A `Binding` to a selection value.
    /// - Parameter endNumber: The highest number to include in the picker.
    /// - Parameter usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    /// - Parameter singularSuffix: The suffix to be displayed after single numbers.
    /// - Parameter pluralSuffix: The suffix to be displayed after plural numbers.
    /// - Parameter unknownTitle: An optional title of the "unknown" option. If `nil`, this option isn't included.
    /// - Parameter noneTitle: An optional title of the "none" option. If `nil`, this option isn't included.
    /// - Parameter unlimitedTitle: An optional title of the "unlimited" option. If `nil`, this option isn't included.
    ///
    /// If you want to use the same suffix for every number, use an initializer that takes a single suffix instead.
    public init(@ViewBuilder label: @escaping (() -> Label), selection: Binding<Int>, oneTo endNumber: Int, usesGroupingSeparator: Bool = true, singularSuffix: String, pluralSuffix: String, unknownTitle: String? = nil, noneTitle: String? = nil, unlimitedTitle: String? = nil) {
        // 1. Create an array to hold the numbers.
        var numberRangeAsArray: [Int] = []
        // 2. Add numbers until endNumber is reached.
        for n in 1...endNumber {
            numberRangeAsArray.append(n)
        }
        // 3. Set up the picker.
        self._selection = selection
        self.label = label()
        self.numbers = numberRangeAsArray
        self.usesGroupingSeparator = usesGroupingSeparator
        self.singularSuffix = singularSuffix
        self.pluralSuffix = pluralSuffix
        self.unknownTitle = unknownTitle
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` with the given label, selection binding, end number, Boolean indicating whether to show a grouping separator, a single suffix applied to all numbers, optional "none" option title, and optional "unlimited" option title.
    ///
    /// If you want to use a separate suffix for singular and plural numbers, use an initializer that takes a singular and plural suffix instead.
    public init(@ViewBuilder label: @escaping (() -> Label), selection: Binding<Int>, oneTo endNumber: Int, usesGroupingSeparator: Bool = true, suffix: String? = nil, unknownTitle: String? = nil, noneTitle: String? = nil, unlimitedTitle: String? = nil) {
        // 1. Create an array to hold the numbers.
        var numberRangeAsArray: [Int] = []
        // 2. Add numbers until endNumber is reached.
        for n in 1...endNumber { numberRangeAsArray.append(n) }
        // 3. Set up the picker.
        self._selection = selection
        self.label = label()
        self.numbers = numberRangeAsArray
        self.usesGroupingSeparator = usesGroupingSeparator
        self.singularSuffix = suffix
        self.pluralSuffix = suffix
        self.unknownTitle = unknownTitle
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` with the given title, selection binding, end number, Boolean indicating whether to show a grouping separator, singular and plural suffixes, optional "none" option title, and optional "unlimited" option title.
    /// - Parameter title: The title for the picker.
    /// - Parameter selection: A `Binding` to a selection value.
    /// - Parameter endNumber: The highest number to include in the picker.
    /// - Parameter usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    /// - Parameter singularSuffix: The suffix to be displayed after single numbers.
    /// - Parameter pluralSuffix: The suffix to be displayed after plural numbers.
    /// - Parameter suffix: An optional general suffix.
    /// - Parameter unknownTitle: An optional title of the "unknown" option. If `nil`, this option isn't included.
    /// - Parameter noneTitle: An optional title of the "none" option. If `nil`, this option isn't included.
    /// - Parameter unlimitedTitle: An optional title of the "unlimited" option. If `nil`, this option isn't included.
    ///
    /// If you want to use the same suffix for every number, use an initializer that takes a single suffix instead.
    public init(_ title: String, selection: Binding<Int>, oneTo endNumber: Int, usesGroupingSeparator: Bool = true, singularSuffix: String, pluralSuffix: String, unknownTitle: String? = nil, noneTitle: String? = nil, unlimitedTitle: String? = nil) where Label == Text {
        // 1. Create an array to hold the numbers.
        var numberRangeAsArray: [Int] = []
        // 2. Add numbers until endNumber is reached.
        for n in 1...endNumber {
            numberRangeAsArray.append(n)
        }
        // 3. Set up the picker.
        self.label = Text(title)
        self._selection = selection
        self.numbers = numberRangeAsArray
        self.usesGroupingSeparator = usesGroupingSeparator
        self.singularSuffix = singularSuffix
        self.pluralSuffix = pluralSuffix
        self.unknownTitle = unknownTitle
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` with the given title, selection binding, end number, Boolean indicating whether to show a grouping separator, a single suffix applied to all numbers, optional "none" option title, and optional "unlimited" option title.
    ///
    /// If you want to use a separate suffix for singular and plural numbers, use an initializer that takes a singular and plural suffix instead.
    public init(_ title: String, selection: Binding<Int>, oneTo endNumber: Int, usesGroupingSeparator: Bool = true, suffix: String? = nil, unknownTitle: String? = nil, noneTitle: String? = nil, unlimitedTitle: String? = nil) where Label == Text {
        // 1. Create an array to hold the numbers.
        var numberRangeAsArray: [Int] = []
        // 2. Add numbers until endNumber is reached.
        for n in 1...endNumber { numberRangeAsArray.append(n) }
        // 3. Set up the picker.
        self.label = Text(title)
        self._selection = selection
        self.numbers = numberRangeAsArray
        self.usesGroupingSeparator = usesGroupingSeparator
        self.singularSuffix = suffix
        self.pluralSuffix = suffix
        self.unknownTitle = unknownTitle
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` whose numbers are produced by starting at `startNumber` and repeatedly multiplying by `multipliedBy` until reaching or exceeding `endNumber` (inclusive when exactly equal).
    /// - Parameter label: The label for the picker.
    /// - Parameter selection: A `Binding` to a selection value.
    /// - Parameter startNumber: The starting number of the sequence.
    /// - Parameter multipliedBy: The multiplier applied to each subsequent value.
    /// - Parameter endNumber: The maximum value to include in the sequence.
    /// - Parameter usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    /// - Parameter singularSuffix: The suffix to be displayed after single numbers.
    /// - Parameter pluralSuffix: The suffix to be displayed after plural numbers.
    /// - Parameter unknownTitle: An optional title of the "unknown" option. If `nil`, this option isn't included.
    /// - Parameter noneTitle: An optional title of the "none" option. If `nil`, this option isn't included.
    /// - Parameter unlimitedTitle: An optional title of the "unlimited" option. If `nil`, this option isn't included.
    ///
    /// If you want to use the same suffix for every number, use an initializer that takes a single suffix instead.
    public init(@ViewBuilder label: @escaping (() -> Label), selection: Binding<Int>, startNumber: Int, multipliedBy: Int, endNumber: Int, usesGroupingSeparator: Bool = true, singularSuffix: String, pluralSuffix: String, unknownTitle: String? = nil, noneTitle: String? = nil, unlimitedTitle: String? = nil) {
        // 1. Create an array to hold the numbers.
        var sequence: [Int] = []
        // 2. Add numbers to the array if startNumber is greater than 0, multipliedBy is greater than 1, and endNumber is greater than or equal to startNumber. Start at startNumber and multiply by multipliedBy until the next number in the sequence is greater than or equal to endNumber (numbers greater than endNumber aren't included).
        if startNumber > 0 && multipliedBy >= 2 && endNumber >= startNumber {
            var value = startNumber
            while value <= endNumber {
                sequence.append(value)
                value *= multipliedBy
            }
        }
        // 3. Set up the picker.
        self._selection = selection
        self.label = label()
        self.numbers = sequence
        self.usesGroupingSeparator = usesGroupingSeparator
        self.singularSuffix = singularSuffix
        self.pluralSuffix = pluralSuffix
        self.unknownTitle = unknownTitle
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` whose numbers are produced by starting at `startNumber` and repeatedly multiplying by `multipliedBy` until reaching or exceeding `endNumber`, using a single suffix applied to all numbers.
    ///
    /// If you want to use a separate suffix for singular and plural numbers, use an initializer that takes a singular and plural suffix instead.
    public init(@ViewBuilder label: @escaping (() -> Label), selection: Binding<Int>, startNumber: Int, multipliedBy: Int, endNumber: Int, usesGroupingSeparator: Bool = true, suffix: String? = nil, unknownTitle: String? = nil, noneTitle: String? = nil, unlimitedTitle: String? = nil) {
        // 1. Create an array to hold the numbers.
        var sequence: [Int] = []
        // 2. Add numbers to the array if startNumber is greater than 0, multipliedBy is greater than 1, and endNumber is greater than or equal to startNumber. Start at startNumber and multiply by multipliedBy until the next number in the sequence is greater than or equal to endNumber (numbers greater than endNumber aren't included).
        if startNumber > 0 && multipliedBy >= 2 && endNumber >= startNumber {
            var value = startNumber
            while value <= endNumber { sequence.append(value); value *= multipliedBy }
        }
        // 3. Set up the picker.
        self._selection = selection
        self.label = label()
        self.numbers = sequence
        self.usesGroupingSeparator = usesGroupingSeparator
        self.singularSuffix = suffix
        self.pluralSuffix = suffix
        self.unknownTitle = unknownTitle
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` whose numbers are produced by starting at `startNumber` and repeatedly multiplying by `multipliedBy` until reaching or exceeding `endNumber` (inclusive when exactly equal).
    /// - Parameter title: The title for the picker.
    /// - Parameter selection: A `Binding` to a selection value.
    /// - Parameter startNumber: The starting number of the sequence.
    /// - Parameter multipliedBy: The multiplier applied to each subsequent value.
    /// - Parameter endNumber: The maximum value to include in the sequence.
    /// - Parameter usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    /// - Parameter singularSuffix: The suffix to be displayed after single numbers.
    /// - Parameter pluralSuffix: The suffix to be displayed after plural numbers.
    /// - Parameter unknownTitle: An optional title of the "unknown" option. If `nil`, this option isn't included.
    /// - Parameter noneTitle: An optional title of the "none" option. If `nil`, this option isn't included.
    /// - Parameter unlimitedTitle: An optional title of the "unlimited" option. If `nil`, this option isn't included.
    ///
    /// If you want to use the same suffix for every number, use an initializer that takes a single suffix instead.
    public init(_ title: String, selection: Binding<Int>, startNumber: Int, multipliedBy: Int, endNumber: Int, usesGroupingSeparator: Bool = true, singularSuffix: String, pluralSuffix: String, unknownTitle: String? = nil, noneTitle: String? = nil, unlimitedTitle: String? = nil) where Label == Text {
        // 1. Create an array to hold the numbers.
        var sequence: [Int] = []
        // 2. Add numbers to the array if they're greater than 0, multipliedBy is greater than 1, and endNumber is greater than or equal to startNumber. Start at startNumber and multiply by multipliedBy until the next number in the sequence is greater than or equal to endNumber (numbers greater than endNumber aren't included).
        if startNumber > 0 && multipliedBy >= 2 && endNumber >= startNumber {
            var value = startNumber
            while value <= endNumber {
                sequence.append(value)
                value *= multipliedBy
            }
        }
        // 3. Set up the picker.
        self.label = Text(title)
        self._selection = selection
        self.numbers = sequence
        self.usesGroupingSeparator = usesGroupingSeparator
        self.singularSuffix = singularSuffix
        self.pluralSuffix = pluralSuffix
        self.unknownTitle = unknownTitle
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` whose numbers are produced by starting at `startNumber` and repeatedly multiplying by `multipliedBy` until reaching or exceeding `endNumber`, using a single suffix applied to all numbers.
    ///
    /// If you want to use a separate suffix for singular and plural numbers, use an initializer that takes a singular and plural suffix instead.
    public init(_ title: String, selection: Binding<Int>, startNumber: Int, multipliedBy: Int, endNumber: Int, usesGroupingSeparator: Bool = true, suffix: String? = nil, unknownTitle: String? = nil, noneTitle: String? = nil, unlimitedTitle: String? = nil) where Label == Text {
        // 1. Create an array to hold the numbers.
        var sequence: [Int] = []
        // 2. Add numbers to the array if they're greater than 0, multipliedBy is greater than 1, and endNumber is greater than or equal to startNumber. Start at startNumber and multiply by multipliedBy until the next number in the sequence is greater than or equal to endNumber (numbers greater than endNumber aren't included).
        if startNumber > 0 && multipliedBy >= 2 && endNumber >= startNumber {
            var value = startNumber
            while value <= endNumber { sequence.append(value); value *= multipliedBy }
        }
        // 3. Set up the picker.
        self.label = Text(title)
        self._selection = selection
        self.numbers = sequence
        self.usesGroupingSeparator = usesGroupingSeparator
        self.singularSuffix = suffix
        self.pluralSuffix = suffix
        self.unknownTitle = unknownTitle
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` whose numbers are produced by starting at `step` and repeatedly adding `step` until reaching or exceeding `endNumber` (inclusive when exactly equal).
    /// - Parameter label: The label for the picker.
    /// - Parameter selection: A `Binding` to a selection value.
    /// - Parameter step: The step size to skip-count by (e.g., 5 will produce 5, 10, 15, ...).
    /// - Parameter endNumber: The maximum value to include in the sequence.
    /// - Parameter usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    /// - Parameter singularSuffix: The suffix to be displayed after single numbers.
    /// - Parameter pluralSuffix: The suffix to be displayed after plural numbers.
    /// - Parameter unknownTitle: An optional title of the "unknown" option. If `nil`, this option isn't included.
    /// - Parameter noneTitle: An optional title of the "none" option. If `nil`, this option isn't included.
    /// - Parameter unlimitedTitle: An optional title of the "unlimited" option. If `nil`, this option isn't included.
    ///
    /// If you want to use the same suffix for every number, use an initializer that takes a single suffix instead.
    public init(@ViewBuilder label: @escaping (() -> Label), selection: Binding<Int>, skipCountingBy step: Int, to endNumber: Int, usesGroupingSeparator: Bool = true, singularSuffix: String, pluralSuffix: String, unknownTitle: String? = nil, noneTitle: String? = nil, unlimitedTitle: String? = nil) {
        // 1. Create an array to hold the numbers.
        var sequence: [Int] = []
        // 2. Add numbers to the array if step is greater than 0 and endNumber is greater than or equal to step.
        if step > 0 && endNumber >= step {
            var value = step
            while value <= endNumber {
                sequence.append(value)
                value += step
            }
        }
        // 3. Set up the picker.
        self._selection = selection
        self.label = label()
        self.numbers = sequence
        self.usesGroupingSeparator = usesGroupingSeparator
        self.singularSuffix = singularSuffix
        self.pluralSuffix = pluralSuffix
        self.unknownTitle = unknownTitle
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` whose numbers are produced by starting at `step` and repeatedly adding `step` until reaching or exceeding `endNumber`, using a single suffix applied to all numbers.
    ///
    /// If you want to use a separate suffix for singular and plural numbers, use an initializer that takes a singular and plural suffix instead.
    public init(@ViewBuilder label: @escaping (() -> Label), selection: Binding<Int>, skipCountingBy step: Int, to endNumber: Int, usesGroupingSeparator: Bool = true, suffix: String? = nil, unknownTitle: String? = nil, noneTitle: String? = nil, unlimitedTitle: String? = nil) {
        // 1. Create an array to hold the numbers.
        var sequence: [Int] = []
        // 2. Add numbers to the array if step is greater than 0 and endNumber is greater than or equal to step.
        if step > 0 && endNumber >= step {
            var value = step
            while value <= endNumber { sequence.append(value); value += step }
        }
        // 3. Set up the picker.
        self._selection = selection
        self.label = label()
        self.numbers = sequence
        self.usesGroupingSeparator = usesGroupingSeparator
        self.singularSuffix = suffix
        self.pluralSuffix = suffix
        self.unknownTitle = unknownTitle
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` whose numbers are produced by starting at `step` and repeatedly adding `step` until reaching or exceeding `endNumber` (inclusive when exactly equal).
    /// - Parameter title: The title for the picker.
    /// - Parameter selection: A `Binding` to a selection value.
    /// - Parameter step: The step size to skip-count by (e.g., 5 will produce 5, 10, 15, ...).
    /// - Parameter endNumber: The maximum value to include in the sequence.
    /// - Parameter usesGroupingSeparator: Whether to use a grouping separator. Defaults to `true`.
    /// - Parameter singularSuffix: The suffix to be displayed after single numbers.
    /// - Parameter pluralSuffix: The suffix to be displayed after plural numbers.
    /// - Parameter unknownTitle: An optional title of the "unknown" option. If `nil`, this option isn't included.
    /// - Parameter noneTitle: An optional title of the "none" option. If `nil`, this option isn't included.
    /// - Parameter unlimitedTitle: An optional title of the "unlimited" option. If `nil`, this option isn't included.
    ///
    /// If you want to use the same suffix for every number, use an initializer that takes a single suffix instead.
    public init(_ title: String, selection: Binding<Int>, skipCountingBy step: Int, to endNumber: Int, usesGroupingSeparator: Bool = true, singularSuffix: String, pluralSuffix: String, unknownTitle: String? = nil, noneTitle: String? = nil, unlimitedTitle: String? = nil) where Label == Text {
        // 1. Create an array to hold the numbers.
        var sequence: [Int] = []
        // 2. Add numbers to the array if step is greater than 0 and endNumber is greater than or equal to step.
        if step > 0 && endNumber >= step {
            var value = step
            while value <= endNumber {
                sequence.append(value)
                value += step
            }
        }
        // 3. Set up the picker.
        self.label = Text(title)
        self._selection = selection
        self.numbers = sequence
        self.usesGroupingSeparator = usesGroupingSeparator
        self.singularSuffix = singularSuffix
        self.pluralSuffix = pluralSuffix
        self.unknownTitle = unknownTitle
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` whose numbers are produced by starting at `step` and repeatedly adding `step` until reaching or exceeding `endNumber`, using a single suffix applied to all numbers.
    ///
    /// If you want to use a separate suffix for singular and plural numbers, use an initializer that takes a singular and plural suffix instead.
    public init(_ title: String, selection: Binding<Int>, skipCountingBy step: Int, to endNumber: Int, usesGroupingSeparator: Bool = true, suffix: String? = nil, unknownTitle: String? = nil, noneTitle: String? = nil, unlimitedTitle: String? = nil) where Label == Text {
        // 1. Create an array to hold the numbers.
        var sequence: [Int] = []
        // 2. Add numbers to the array if step is greater than 0 and endNumber is greater than or equal to step.
        if step > 0 && endNumber >= step {
            var value = step
            while value <= endNumber { sequence.append(value); value += step }
        }
        // 3. Set up the picker.
        self.label = Text(title)
        self._selection = selection
        self.numbers = sequence
        self.usesGroupingSeparator = usesGroupingSeparator
        self.singularSuffix = suffix
        self.pluralSuffix = suffix
        self.unknownTitle = unknownTitle
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    // MARK: - Body

    public var body: some View {
        Picker(selection: $selection) {
            if let noneTitle = noneTitle {
                Text(noneTitle).tag(0)
                Divider()
            }
            if let unknownTitle = unknownTitle {
                Text(unknownTitle).tag(-1)
                Divider()
            }
            ForEach(numbers, id: \.self) { number in
                Text(formattedNumberWithSuffix(number)).tag(number)
            }
            if let unlimitedTitle = unlimitedTitle {
                Divider()
                Text(unlimitedTitle).tag(Int.max)
            }
        } label: {
            label
        }
        .pickerStyle(.menu)
    }

    // This method returns number as a formatted string.
    func formattedNumber(_ number: Int) -> String {
        // 1. Convert the number to a string without formatting in case formatting returns nil.
        let numberAsString = "\(number)"
        // 2. Format the number.
        guard let formattedNumber = numberFormatter.string(from: number as NSNumber) else { return numberAsString }
        // 3. Return the formatted number.
        return formattedNumber
    }

    // This method returns a formatted number string with appropriate suffix if provided.
    func formattedNumberWithSuffix(_ number: Int) -> String {
        // 1. Format the number.
        let formattedNumber = formattedNumber(number)
        // 2. If suffixes are provided, return a string with the number and suffix. Otherwise, return just the number.
        if let singularSuffix = singularSuffix, let pluralSuffix = pluralSuffix {
            let suffix = (number == 1) ? singularSuffix : pluralSuffix
            return "\(formattedNumber) \(suffix)"
        } else {
            return formattedNumber
        }
    }

}

// MARK: - Preview

#Preview {
    CountPicker("Count", selection: .constant(5), numberRange: 1...10, singularSuffix: "Item", pluralSuffix: "Items")
}

// MARK: - Library Items

struct CountPickerLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(CountPicker("Count", selection: .constant(5), numbers: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]), visible: true, title: "Count Picker (Array)", category: .control, matchingSignature: "countpickerarray")
        LibraryItem(CountPicker("Count", selection: .constant(5), oneTo: 10), visible: true, title: "Count Picker (1 to Specified End Number)", category: .control, matchingSignature: "countpickerend")
        LibraryItem(CountPicker("Count", selection: .constant(5), numberRange: 1...10), visible: true, title: "Count Picker (Range)", category: .control, matchingSignature: "countpickerrange")
        LibraryItem(CountPicker("Count", selection: .constant(4), startNumber: 1, multipliedBy: 2, endNumber: 32), visible: true, title: "Count Picker (Multiples)", category: .control, matchingSignature: "countpickermultiples")
        LibraryItem(CountPicker("Count", selection: .constant(4), skipCountingBy: 5, to: 100), visible: true, title: "Count Picker (Skip-Counting)", category: .control, matchingSignature: "countpickerskip")
    }

}

