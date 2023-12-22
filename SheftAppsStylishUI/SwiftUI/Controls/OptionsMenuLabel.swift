//
//  OptionsMenuLabel.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 5/29/23.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import SwiftUI

// MARK: - Options Menu Label

/// A label that can be used in an options menu which displays an ellipsis icon and/or the given title.
public struct OptionsMenuLabel<L: LabelStyle>: View {

    /// The title of the options menu label.
	public var title: String

    /// The style of the options menu label.
	public var labelStyle: L

    /// Creates an `OptionsMenuLabel` with the givven title and style.
	public init(title: String = "Options", labelStyle: L = .automatic) {
		self.title = title
		self.labelStyle = labelStyle
	}

	public var body: some View {
		HStack {
			Label {
				Text(title)
			} icon: {
				Image(systemName: "ellipsis.circle")
			}
			.labelStyle(labelStyle)
		}
	}

}

#Preview {
    OptionsMenuLabel()
}
