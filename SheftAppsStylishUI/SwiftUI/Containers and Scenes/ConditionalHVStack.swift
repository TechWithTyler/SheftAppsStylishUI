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

    var isLazy: Bool

    var hAlignment: HorizontalAlignment

    var vAlignment: VerticalAlignment

    var spacing: CGFloat? = nil

	var content: () -> Content

    /// Creates a new `ConditionalHVStack` with the given alignment, spacing, Boolean indicating whether it should be lazily loaded, and content.
    /// - Parameters:
    ///   - hAlignment: The horizontal alignment to use when rendering as a `VStack`/`LazyVStack`.
    ///   - vAlignment: The vertical alignment to use when rendering as an `HStack`/`LazyHStack`.
    ///   - spacing: The spacing between items in the stack.
    ///   - isLazy: Whether the stack should be lazily rendered (i.e., don't render content until it's visible onscreen).
    ///   - content: The content of the stack.
    public init(hAlignment: HorizontalAlignment = .center, vAlignment: VerticalAlignment = .center, spacing: CGFloat? = nil, isLazy: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.spacing = spacing
        self.vAlignment = vAlignment
        self.hAlignment = hAlignment
        self.isLazy = isLazy
	}

	public var body: some View {
		// Returns the content as a VStack if the window is too small to fit the content in an HStack.
        if isLazy {
            if horizontalSizeClass == .compact {
                LazyVStack(alignment: hAlignment, spacing: spacing, content: content)
            } else {
                LazyHStack(alignment: vAlignment, spacing: spacing, content: content)
            }
        } else {
            if horizontalSizeClass == .compact {
                VStack(alignment: hAlignment, spacing: spacing, content: content)
            } else {
                HStack(alignment: vAlignment, spacing: spacing, content: content)
            }
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
