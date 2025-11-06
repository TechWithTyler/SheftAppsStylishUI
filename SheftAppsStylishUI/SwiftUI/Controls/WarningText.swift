//
//  WarningText.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/6/23.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

// MARK: - Imports

import SwiftUI

@available(tvOS, unavailable)
@available(watchOS, unavailable)
/// Displays an exclamation mark triangle icon and the given text.
///
/// You can use SwiftUI modifiers like `.font(_:)`, `.foregroundStyle(_:)`, and `.symbolVariant(_:)` to customize the design of the text and icon.
public struct WarningText: View {

    /// A prefix to show in a `WarningText`.
    public enum Prefix: String {

        /// Prefix "IMPORTANT:"
        case importantUrgent = "IMPORTANT:"

        /// Prefix "Important:"
        case important = "Important:"

        /// Prefix "WARNING:"
        case warningUrgent = "WARNING:"

        /// Prefix "Warning:"
        case warning = "Warning:"

    }

    // MARK: - Properties - Strings

    // The text to display.
    var text: String

    var prefix: Prefix?

    // MARK: - Initialization

    /// Creates a new `WarningText` with the given text String and optional prefix.
    public init(_ text: String, prefix: Prefix? = nil) {
        self.text = text
        self.prefix = prefix
    }

    // MARK: - Body

    public var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle")
                .accessibilityHidden(true)
                .symbolRenderingMode(.multicolor)
                .imageScale(.large)
            if let prefix = prefix?.rawValue {
                Text("\(prefix) \(text)")
            } else {
                Text(text)
            }
        }
        .font(.callout)
        .foregroundStyle(.secondary)
    }
}

#if !os(watchOS) && !os(tvOS)
#Preview("No Prefix") {
    WarningText("This feature isn't available!")
        .padding()
}

#Preview("Prefix \"\(WarningText.Prefix.warning.rawValue)\"") {
    WarningText("Too many bugs!", prefix: .warning)
        .padding()
}

#Preview("Prefix \"\(WarningText.Prefix.warningUrgent.rawValue)\"") {
    WarningText("Danger!", prefix: .warningUrgent)
        .padding()
}

#Preview("Prefix \"\(WarningText.Prefix.important.rawValue)\"") {
    WarningText("This can't be undone!", prefix: .important)
        .padding()
}

#Preview("Prefix \"\(WarningText.Prefix.importantUrgent.rawValue)\"") {
    WarningText("This can't be undone!", prefix: .importantUrgent)
        .padding()
}
#endif
