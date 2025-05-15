//
//  ScrollableText.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 11/21/23.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

import SwiftUI

/// A `Text` view that can scroll.
public struct ScrollableText: View {
    
    let text: String
    
    /// Creates a new `ScrollableText` with the given text.
    public init(_ text: String) {
        self.text = text
    }
    
    public var body: some View {
        ScrollView {
            Text(text)
                .padding()
        }
    }
    
}

#Preview {
    ScrollableText("I'm some scrollable text. The longest word in the English language is pneumonoultramicroscopicsilicovolcanoconiosis. The quick brown fox jumps over the lazy dog. SheftAppsStylishUI was created in March 2022 to make creating UI for SheftApps apps even easier.")
        .font(.system(size: 36))
}

struct ScrollableTextLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(ScrollableText("SheftAppsStlishUI provides views, controls, and modifiers to help the SheftApps team build their great apps. You can use these components in your apps to make developing them that one bit easier."), visible: true, title: "Scrollable Text", category: .control, matchingSignature: "scrollabletext")
    }

}
