//
//  ConditionalHVStack.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 5/29/23.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import SwiftUI

/// A view that stacks content horizontally or vertically based on the horizontal size class of the environment.
///
/// If the horizontal size class of the environment is `.regular`, content is laid out horizontally. If it's `.compact`, content is laid out vertically.
public struct ConditionalHVStack<Content: View>: View {

    /// The view's current horizontal size class, describing how wide it is.
	@Environment(\.horizontalSizeClass) var horizontalSizeClass

    /// The content of the stack.
	public var content: () -> Content

    /// Creates a new `ConditionalHVStack` with the given content.
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

#Preview {		
    ConditionalHVStack {
			Text("This is an item.")
			Text("And this is another.")
			Text("Try changing the preview device and size. See how these items appear differently on different devices and window sizes?")
		}
		.multilineTextAlignment(.center)
        .padding()
        .fixedSize()
    }
