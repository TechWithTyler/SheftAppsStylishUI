//
//  ConditionalHVStack.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 5/29/23.
//  Copyright © 2022-2023 SheftApps. All rights reserved.
//

import SwiftUI

// MARK: - Conditional Horizontal/Vertical Stack

public struct ConditionalHVStack<Content: View>: View {

	@Environment(\.horizontalSizeClass) var horizontalSizeClass

	public var content: () -> Content

	public init(@ViewBuilder content: @escaping () -> Content) {
		self.content = content
	}

	public var body: some View {
		// Returns the content as a VStack if the window is too small to fit the content in an HStack.
		if horizontalSizeClass == .compact {
			VStack(content: content)
		} else {
			HStack(content: content)
		}
	}

}

struct ConditionalHVStack_Previews: PreviewProvider {
    static var previews: some View {
		ConditionalHVStack {
			Text("This is an item.")
			Text("And this is another.")
			Text("See how these items appear differently on different devices and window sizes?")
		}
		.multilineTextAlignment(.center)
    }
}
