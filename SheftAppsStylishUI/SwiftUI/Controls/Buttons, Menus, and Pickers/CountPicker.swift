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
public struct CountPicker<Label: View, SelectionValue: Hashable>: View {

    // MARK: - Properties - Label

    var label: Label

    // MARK: - Properties - Selection

    @Binding var selection: SelectionValue

    // MARK: - Properties - Integers

    var numbers: [Int]

    // MARK: - Properties - Strings

    var noneTitle: String?

    var unlimitedTitle: String?

    // MARK: - Initialization

    /// Creates a new `CountPicker` with the given label, selection binding, numbers array, optional "none" option title, and optional "unlimited" option title.
    /// - Parameter label: The label for the picker.
    /// - Parameter selection: A `Binding` to a selection value.
    /// - Parameter numbers: An array of numbers to include in the picker.
    /// - Parameter noneTitle: An optional title of the "none" option. If nil, this option isn't included.
    /// - Parameter unlimitedTitle: An optional title of the "unlimited" option. If nil, this option isn't included.
    public init(@ViewBuilder label: @escaping (() -> Label), selection: Binding<SelectionValue>, numbers: [Int], noneTitle: String? = nil, unlimitedTitle: String? = nil) where Label == Text {
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
    /// - Parameter noneTitle: An optional title of the "none" option. If nil, this option isn't included.
    /// - Parameter unlimitedTitle: An optional title of the "unlimited" option. If nil, this option isn't included.
    public init(_ title: String, selection: Binding<SelectionValue>, numbers: [Int], noneTitle: String? = nil, unlimitedTitle: String? = nil) where Label == Text {
        self.label = Text(title)
        self._selection = selection
        self.numbers = numbers
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
    CountPicker("Count", selection: .constant(5), numbers: [1,2,3,4,5,6,7,8,9,10])
}

// MARK: - Library Items

struct CountPickerLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(CountPicker("Count", selection: .constant(5), numbers: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]), visible: true, title: "Count Picker", category: .control, matchingSignature: "countpicker")
    }

}
