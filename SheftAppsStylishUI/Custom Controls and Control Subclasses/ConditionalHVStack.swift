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

	public var content: () -> Content

	public init(@ViewBuilder content: @escaping () -> Content) {
		self.content = content
	}

	public var body: some View {
		// If on an iOS device or an iPad idiom Catalyst app, use a VStack so it fits on all screen sizes. Otherwise, use an HStack.
#if os(iOS)
		if UIDevice.current.userInterfaceIdiom == .mac {
			HStack(content: content)
		} else {
			VStack(content: content)
		}
#elseif os(macOS)
		HStack(content: content)
#endif
	}

}

struct ConditionalHVStack_Previews: PreviewProvider {
    static var previews: some View {
		ConditionalHVStack {
			Text("This is an item.")
			Text("And this is another.")
			Text("See how these items appear differently on different devices?")
		}
		.multilineTextAlignment(.center)
    }
}
