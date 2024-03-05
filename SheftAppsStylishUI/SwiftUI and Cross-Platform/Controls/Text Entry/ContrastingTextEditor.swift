//
//  ContrastingTextEditor.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/24/24.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import SwiftUI

/// A `TextView` with a contrasting background instead of the system default scrollable content background.
@available(macOS 13, iOS 16, visionOS 1, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct ContrastingTextEditor: View {
    
    @Binding var text: String
    
    /// Creates a new `ContrastingTextView` with the given text String binding.
    public init(text: Binding<String>) {
        self._text = text
    }
    
    public var body: some View {
        TextEditor(text: $text)
        .scrollContentBackground(.hidden)
        .background(
            RoundedRectangle(cornerRadius: SATextViewCornerRadius)
                .fill(.quinary)
        )
    }
    
}

#if !os(tvOS) && !os(watchOS)
@available(macOS 13, iOS 16, visionOS 1, *)
#Preview {
    @State var text: String = "Text"
    return ContrastingTextEditor(text: $text)
        .frame(height: 100)
        .padding()
}
#endif
