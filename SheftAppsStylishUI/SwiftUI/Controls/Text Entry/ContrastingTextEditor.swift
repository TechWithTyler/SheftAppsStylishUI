//
//  ContrastingTextEditor.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/24/24.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import SwiftUI

/// A `TextView` with a contrasting background instead of the system default scrollable content background.
@available(watchOS, unavailable)
@available(tvOS, unavailable)
public struct ContrastingTextEditor: View {

    // MARK: - Properties - Strings

    @Binding var text: String

    // MARK: - Initialization

    /// Creates a new `ContrastingTextView` with the given text String binding.
    public init(text: Binding<String>) {
        self._text = text
    }

    // MARK: - Body

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

// MARK: - Preview

#Preview {
    @Previewable @State var text: String = "Text"
    return ContrastingTextEditor(text: $text)
        .frame(height: 100)
        .padding()
}

// MARK: - Library Items

struct ContrastingTextEditorLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(ContrastingTextEditor(text: .constant("SheftAppsStylishUI")), visible: true, title: "Contrasting Text Editor", category: .control, matchingSignature: "contrastingtexteditor")
    }

}
#endif
