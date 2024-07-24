//
//  FormSecureField.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 11/16/23.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import Foundation

/// A `SecureField` which always shows its title.
public struct FormSecureField<Label: View>: View {
    
    var label: Label
    
    @Binding var text: String
    
    /// Creates a new `FormSecureField` with the given label and text string binding.
    ///  - label: The `View` to display as the label of the text field.
    ///  - text: The text of the text field.
    public init(@ViewBuilder _ label: (() -> Label), text: Binding<String>) where Label == Text {
        self.label = label()
        self._text = text
    }
    
    /// Creates a new `FormSecureField` with the given label string and text string binding.
    ///  - label: The `String` to display as the label of the text field.
    ///  - text: The text of the text field.
    public init(_ label: String, text: Binding<String>) where Label == Text {
        self.label = Text(label)
        self._text = text
    }
    
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
    
    var textField: some View {
        SecureField(text: $text) {
            label
        }
            .multilineTextAlignment(.trailing)
    }
    
}

#Preview {
    @State var password: String = String()
    return FormSecureField("Password", text: $password)
}

struct FormSecureFieldLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(FormSecureField({
            Text("Secure Field")
        }, text: .constant("password123")), visible: true, title: "Form Secure Field (Label View)", category: .control, matchingSignature: "formsecurefield")
        LibraryItem(FormSecureField("Secure Field", text: .constant("password123")), visible: true, title: "Form Secure Field (Label String)", category: .control, matchingSignature: "formsecurefield")
    }

}

