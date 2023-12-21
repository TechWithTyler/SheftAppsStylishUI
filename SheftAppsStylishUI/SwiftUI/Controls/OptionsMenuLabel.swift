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

	public var title: String

	public var labelStyle: L

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


struct OptionsMenuLabel_Previews: PreviewProvider {
    static var previews: some View {
		OptionsMenuLabel()
    }
}
