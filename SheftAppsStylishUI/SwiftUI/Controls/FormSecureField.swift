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
    
    /// The label of tht text field.
    public var label: Label
    
    /// The text of the text field.
    @Binding public var text: String
    
    /// Creates a new `FormSecureField` with the given label and text string binding.
    public init(@ViewBuilder _ label: (() -> Label), text: Binding<String>) where Label == Text {
        self.label = label()
        self._text = text
    }
    
    /// Creates a new `FormSecureField` with the given label string and text string binding.
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
        }
#endif
    }
    
    public var textField: some View {
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
