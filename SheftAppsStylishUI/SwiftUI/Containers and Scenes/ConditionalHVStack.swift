//
//  ConditionalHVStack.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 5/29/23.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import SwiftUI

/// A view that stacks content horizontally or vertically based on the horizontal size class of the environment.
///
/// If the horizontal size class of the environment (which describes the width of a view) is `UserInterfaceSizeClass.regular`, content is laid out horizontally. If it's `UserInterfaceSizeClass.compact`, content is laid out vertically.
public struct ConditionalHVStack<Content: View>: View {

    // MARK: - Properties - Horizontal Size Class

	@Environment(\.horizontalSizeClass) var horizontalSizeClass

    // MARK: - Properties - Booleans

    var isLazy: Bool

    // MARK: - Properties - Alignment

    var hAlignment: HorizontalAlignment

    var vAlignment: VerticalAlignment

    // MARK: - Properties - Floats

    var spacing: CGFloat? = nil

    // MARK: - Properties - Content

	var content: () -> Content

    // MARK: - Initialization

    /// Creates a new `ConditionalHVStack` with the given alignment, spacing, Boolean indicating whether it should be lazily rendered, and content.
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

    // MARK: - Body

	public var body: some View {
		// Returns the content as a VStack if the parent view/window is too narrow to fit the content in an HStack.
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

// MARK: - Preview

#Preview("Non-Lazy") {
    ConditionalHVStack {
			Text("This is an item.")
			Text("And this is another.")
			Text("Try changing the preview device and size. See how these items appear differently on different devices and window sizes?")
		}
		.multilineTextAlignment(.center)
        .padding()
        .fixedSize()
    }

#Preview("Lazy") {
    ConditionalHVStack(isLazy: true) {
            Text("This is an item.")
            Text("And this is another.")
            Text("Try changing the preview device and size. See how these items appear differently on different devices and window sizes?")
        }
        .multilineTextAlignment(.center)
        .padding()
        .fixedSize()
    }

// MARK: - Library Items

struct ConditionalHVStackLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(ConditionalHVStack(hAlignment: .center, vAlignment: .center, spacing: nil, isLazy: false, content: {
            Text("SheftAppsStylishUI")
            Text("makes it very easy")
            Text("For the SheftApps team to build")
            Text("their great apps!")
        }), visible: true, title: "Conditional Horizontal/Vertical Stack (Non-Lazy)", category: .layout, matchingSignature: "conditionalhvstack")
        LibraryItem(ConditionalHVStack(hAlignment: .center, vAlignment: .center, spacing: nil, isLazy: true, content: {
            Text("SheftAppsStylishUI")
            Text("makes it very easy")
            Text("For the SheftApps team to build")
            Text("their great apps!")
        }), visible: true, title: "Conditional Horizontal/Vertical Stack (Lazy)", category: .layout, matchingSignature: "conditionalhvstack")
    }

}
