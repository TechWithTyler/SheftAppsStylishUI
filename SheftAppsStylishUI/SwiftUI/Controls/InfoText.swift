//
//  InfoText.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/6/23.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import SwiftUI

@available(tvOS, unavailable)
@available(watchOS, unavailable)
/// Displays an info icon and the given text.
public struct InfoText: View {

    // MARK: - Properties - Strings
    
    // The text to display.
    var text: String
    
    // The number of lines in the text.
    var lines: [String] {
        return text.components(separatedBy: .newlines)
    }
    
    // MARK: - Initialization
    
    /// Creates a new `InfoText` with the given text String.
    ///
    /// If `text` has multiple lines, each line is displayed as a separate `Text` view within a `List`.
    public init(_ text: String) {
        self.text = text
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack {
            Image(systemName: "info.circle")
                .accessibilityHidden(true)
            if lines.count == 1 {
                Text(text)
            } else {
                VStack(alignment: .listRowSeparatorLeading) {
                    List(lines, id: \.self) { line in
                        Text(line)
                            .listRowSeparator(.hidden)
                    }
                }
            }
        }
        .font(.callout)
        .foregroundStyle(.secondary)
    }
}

// MARK: - Preview

#if !os(watchOS) && !os(tvOS)
#Preview("Single-line") {
    InfoText("Info about an item.")
        .padding()
}

#Preview("Multi-line") {
    InfoText("Selecting this option does this.\nSelecting that option does that.")
}

// MARK: - Library Items

struct InfoTextLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(InfoText("Info Text"), visible: true, title: "Info Text", category: .control, matchingSignature: "infotext")
    }

}


#endif
