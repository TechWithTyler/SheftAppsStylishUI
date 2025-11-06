//
//  LoadingIndicator.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 11/6/23.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

// MARK: - Imports

import SwiftUI

/// A loading indicator with optional text (e.g., "Please wait…").
public struct LoadingIndicator<S: ProgressViewStyle>: View {

    // MARK: - Properties - Strings

	var message: String?

    // MARK: - Properties - Progress View Style

    var style: S

    // MARK: - Initialization

    /// Creates a new `LoadingIndicator` with the given style and optional text (e.g., "Please wait…").
    public init(message: String? = nil, style: S = .automatic) {
        self.message = message
        self.style = style
    }

    // MARK: - Body

    public var body: some View {
		HStack {
			ProgressView()
				.progressViewStyle(style)
#if os(macOS)
				.controlSize(.small)
#endif
			if let message = message {
				Text(message)
					.padding(.horizontal)
			}
		}
    }
	
}

#Preview("Loading Indicator Without Label") {
    LoadingIndicator()
}

#Preview("Loading Indicator With Label") {
    LoadingIndicator(message: "Please wait…")
}
