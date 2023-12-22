//
//  FormNumericTextField.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 11/16/23.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import SwiftUI

/// A numeric`TextField` which always shows its title.
public struct FormNumericTextField<N>: View where N: Numeric {
    
    /// The label of tht text field.
    public var label: String
    
    /// The text of the text field.
    @Binding public var value: N
    
    /// Creates a new `FormNumericTextField` with the given label string and value binding.
    public init(_ label: String, value: Binding<N>) {
        self.label = label
        self._value = value
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
        TextField(label, value: $value, formatter: NumberFormatter())
            .multilineTextAlignment(.trailing)
#if os(iOS) || os(tvOS) || os(visionOS)
            .keyboardType(.numberPad)
#endif
    }
    
}

#Preview {
    @State var age: Int = 1
    return FormNumericTextField("Age", value: $age)
}
