//
//  FormTextField.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 11/16/23.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import SwiftUI

/// A `TextField` which always shows its title.
public struct FormTextField<Label: View>: View {

    // MARK: - Properties - Label

    var label: Label

    // MARK: - Properties - Strings

    @Binding var text: String

    // MARK: - Initialization

    /// Creates a new `FormTextField` with the given label and text string binding.
    /// - Parameters:
    ///   - label: The `View` to display as the label of the text field.
    ///   - text: The text of the text field.
    public init(@ViewBuilder _ label: (() -> Label), text: Binding<String>) where Label == Text {
        self.label = label()
        self._text = text
    }
    
    /// Creates a new `FormTextField` with the given label string and text string binding.
    /// - Parameters:
    ///   - label: The `String` to display as the label of the text field.
    ///   - text: The text of the text field.
    public init(_ label: String, text: Binding<String>) where Label == Text {
        self.label = Text(label)
        self._text = text
    }

    // MARK: - Body

    public var body: some View {
#if os(macOS)
        textField
#else
        HStack {
            label
                .multilineTextAlignment(.leading)
            textField
                .multilineTextAlignment(.trailing)
        }
#endif
    }

    // MARK: - Text Field

    var textField: some View {
        TextField(text: $text) {
            label
        }
    }
    
}

// MARK: - Preview

#Preview {
    @Previewable @State var email: String = String()
    return FormTextField("Email", text: $email)
}

// MARK: - Library Items

struct FormTextFieldLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(FormTextField({
            Text("Text Field")
        }, text: .constant("SheftAppsStylishUI")), visible: true, title: "Form Text Field (Label View)", category: .control, matchingSignature: "formtextfield")
        LibraryItem(FormTextField("Text Field", text: .constant("SheftAppsStylishUI")), visible: true, title: "Form Text Field (Label String)", category: .control, matchingSignature: "formtextfield")
    }

}
