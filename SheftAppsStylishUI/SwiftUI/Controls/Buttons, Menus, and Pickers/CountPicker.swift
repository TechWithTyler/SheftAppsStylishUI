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

    /// The array of numbers to include in the picker.
    var numbers: [Int]

    // MARK: - Properties - Strings

    /// An optional title to display as the option for setting the value to 0.
    var noneTitle: String?

    /// An optional title to display as the option for setting the value to `Int.max`.
    var unlimitedTitle: String?

    // MARK: - Initialization

    /// Creates a new `CountPicker` with the given label, selection binding, numbers array, optional "none" option title, and optional "unlimited" option title.
    /// - Parameter label: The label for the picker.
    /// - Parameter selection: A `Binding` to a selection value.
    /// - Parameter numbers: An array of numbers to include in the picker.
    /// - Parameter noneTitle: An optional title of the "none" option. If `nil`, this option isn't included.
    /// - Parameter unlimitedTitle: An optional title of the "unlimited" option. If `nil`, this option isn't included.
    public init(@ViewBuilder label: @escaping (() -> Label), selection: Binding<Int>, numbers: [Int], noneTitle: String? = nil, unlimitedTitle: String? = nil) {
        self._selection = selection
        self.label = label()
        self.numbers = numbers
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` with the given title, selection binding, numbers array, optional "none" option title, and optional "unlimited" option title.
    /// - Parameter title: The title for the picker.
    /// - Parameter selection: A `Binding` to a selection value.
    /// - Parameter numbers: An array of numbers to include in the picker.
    /// - Parameter noneTitle: An optional title of the "none" option. If `nil`, this option isn't included.
    /// - Parameter unlimitedTitle: An optional title of the "unlimited" option. If `nil`, this option isn't included.
    public init(_ title: String, selection: Binding<Int>, numbers: [Int], noneTitle: String? = nil, unlimitedTitle: String? = nil) where Label == Text {
        self.label = Text(title)
        self._selection = selection
        self.numbers = numbers
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` with the given label, selection binding, number range, optional "none" option title, and optional "unlimited" option title.
    /// - Parameter label: The label for the picker.
    /// - Parameter selection: A `Binding` to a selection value.
    /// - Parameter numberRange: A range of numbers to include in the picker.
    /// - Parameter noneTitle: An optional title of the "none" option. If `nil`, this option isn't included.
    /// - Parameter unlimitedTitle: An optional title of the "unlimited" option. If `nil`, this option isn't included.
    public init(@ViewBuilder label: @escaping (() -> Label), selection: Binding<Int>, numberRange: ClosedRange<Int>, noneTitle: String? = nil, unlimitedTitle: String? = nil) {
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
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` with the given title, selection binding, number range, optional "none" option title, and optional "unlimited" option title.
    /// - Parameter title: The title for the picker.
    /// - Parameter selection: A `Binding` to a selection value.
    /// - Parameter numberRange: A range of numbers to include in the picker.
    /// - Parameter noneTitle: An optional title of the "none" option. If `nil`, this option isn't included.
    /// - Parameter unlimitedTitle: An optional title of the "unlimited" option. If `nil`, this option isn't included.
    public init(_ title: String, selection: Binding<Int>, numberRange: ClosedRange<Int>, noneTitle: String? = nil, unlimitedTitle: String? = nil) where Label == Text {
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
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` whose numbers are produced by starting at `startNumber` and repeatedly multiplying by `multipliedBy` until reaching or exceeding `endNumber` (inclusive when exactly equal).
    /// - Parameter label: The label for the picker.
    /// - Parameter selection: A `Binding` to a selection value.
    /// - Parameter startNumber: The starting number of the sequence.
    /// - Parameter multipliedBy: The multiplier applied to each subsequent value.
    /// - Parameter endNumber: The maximum value to include in the sequence.
    /// - Parameter noneTitle: An optional title of the "none" option. If `nil`, this option isn't included.
    /// - Parameter unlimitedTitle: An optional title of the "unlimited" option. If `nil`, this option isn't included.
    public init(@ViewBuilder label: @escaping (() -> Label), selection: Binding<Int>, startNumber: Int, multipliedBy: Int, endNumber: Int, noneTitle: String? = nil, unlimitedTitle: String? = nil) {
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
        self.noneTitle = noneTitle
        self.unlimitedTitle = unlimitedTitle
    }

    /// Creates a new `CountPicker` whose numbers are produced by starting at `startNumber` and repeatedly multiplying by `multipliedBy` until reaching or exceeding `endNumber` (inclusive when exactly equal).
    /// - Parameter title: The title for the picker.
    /// - Parameter selection: A `Binding` to a selection value.
    /// - Parameter startNumber: The starting number of the sequence.
    /// - Parameter multipliedBy: The multiplier applied to each subsequent value.
    /// - Parameter endNumber: The maximum value to include in the sequence.
    /// - Parameter noneTitle: An optional title of the "none" option. If `nil`, this option isn't included.
    /// - Parameter unlimitedTitle: An optional title of the "unlimited" option. If `nil`, this option isn't included.
    public init(_ title: String, selection: Binding<Int>, startNumber: Int, multipliedBy: Int, endNumber: Int, noneTitle: String? = nil, unlimitedTitle: String? = nil) where Label == Text {
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
            ForEach(numbers, id: \.self) { number in
                Text("\(number)").tag(number)
            }
            if let unlimitedTitle = unlimitedTitle {
                Divider()
                Text(unlimitedTitle).tag(Int.max)
            }
        } label: {
            label
        }
    }

}

// MARK: - Preview

#Preview {
    CountPicker("Count", selection: .constant(5), numberRange: 1...10)
}

// MARK: - Library Items

struct CountPickerLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(CountPicker("Count", selection: .constant(5), numbers: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]), visible: true, title: "Count Picker (Array)", category: .control, matchingSignature: "countpickerarray")
        LibraryItem(CountPicker("Count", selection: .constant(5), numberRange: 1...10), visible: true, title: "Count Picker (Range)", category: .control, matchingSignature: "countpickerrange")
        LibraryItem(CountPicker("Count", selection: .constant(4), startNumber: 1, multipliedBy: 2, endNumber: 32), visible: true, title: "Count Picker (Multiples)", category: .control, matchingSignature: "countpickermultiples")
    }

}
