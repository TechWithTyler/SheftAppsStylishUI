//
//  WarningText.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/6/23.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import SwiftUI

@available(tvOS, unavailable)
@available(watchOS, unavailable)
/// Displays an exclamation mark triangle icon and the given text.
public struct WarningText: View {

    // MARK: - Properties - Strings

    // The text to display.
    var text: String

    // MARK: - Initialization

    /// Creates a new `WarningText` with the given text String.
    public init(_ text: String) {
        self.text = text
    }

    // MARK: - Body

    public var body: some View {
        HStack {
            Image(systemName: "info.circle")
                .accessibilityHidden(true)
            Text(text)
        }
        .font(.callout)
        .foregroundStyle(.secondary)
    }
}

#if !os(watchOS) && !os(tvOS)
#Preview {
    WarningText("This feature isn't available!")
}
#endif
