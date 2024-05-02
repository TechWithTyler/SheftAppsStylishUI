//
//  ContrastingTextEditor.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/24/24.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import SwiftUI

/// A `TextView` with a contrasting background instead of the system default scrollable content background.
#if !os(tvOS) && !os(watchOS)
@available(macOS 13, iOS 16, visionOS 1, *)
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
@available(macOS 13, iOS 16, visionOS 1, *)
#Preview {
    @State var text: String = "Text"
    return ContrastingTextEditor(text: $text)
        .frame(height: 100)
        .padding()
}

@available(macOS 13, iOS 16, visionOS 1, *)
struct ContrastingTextEditorLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(ContrastingTextEditor(text: .constant("SheftAppsStylishUI")), visible: true, title: "Contrasting Text Editor", category: .control, matchingSignature: "contrastingtexteditor")
    }

}
#endif
