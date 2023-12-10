//
//  FormSecureField.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 11/16/23.
//  Copyright © 2022-2023 SheftApps. All rights reserved.
//

import Foundation

/// A `SecureField` which always shows its title.
public struct FormSecureField: View {
    
    public var label: String
    
    @Binding public var text: String
    
    public init(_ label: String, text: Binding<String>) {
        self.label = label
        self._text = text
    }
    
    public var body: some View {
#if os(macOS)
        textField
#else
        HStack {
            Text(label)
                .multilineTextAlignment(.leading)
            textField
        }
#endif
    }
    
    public var textField: some View {
        SecureField(label, text: $text)
            .multilineTextAlignment(.trailing)
    }
}
