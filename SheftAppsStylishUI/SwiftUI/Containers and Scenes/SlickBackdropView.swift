//
//  SlickBackdropView.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 5/12/23.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

import SwiftUI

/// A view composed of background and foreground content, with a translucent material in-between.
///
/// For master-detail UIs with a small image in the list row and a large image in the detail view, containing the detail view within a `SlickBackdropView` with the image as its `backdropContent` can give your UI an ultra-slick look and a sense of context.
public struct SlickBackdropView<BackdropContent: View, ForegroundContent: View>: View {

    // MARK: - Properties - Content

    @ViewBuilder var foregroundContent: ForegroundContent

    @ViewBuilder var backdropContent: BackdropContent

    // MARK: - Properties - System Theme

	@Environment(\.colorScheme) var systemTheme
    
    // MARK: - Properties - Booleans

	@Environment(\.accessibilityReduceTransparency) var reduceTransparency

    /// Creates a new `SlickBackdropView` with the given foreground content and backdrop content.
    ///
    /// - parameter foregroundContent: The main content of the view.
    /// - parameter backdropContent: The content to blur behind the foreground content.
    ///
    /// - Important: Don't include interactive UI (e.g. buttons, sliders, or text fields) in `backdropContent`.
    public init(@ViewBuilder foregroundContent: () -> ForegroundContent, @ViewBuilder backdropContent: () -> BackdropContent) {
        self.backdropContent = backdropContent()
        self.foregroundContent = foregroundContent()
    }

    // MARK: - Body

    public var body: some View {
		if !reduceTransparency {
                ZStack {
                    // Backdrop content
                    backdropContent
                    // Foreground content
                    foregroundContent
                        .background(.ultraThickMaterial)
                }
		} else {
            foregroundContent
		}
    }
}

#Preview {
    SlickBackdropView {
        VStack {
            Spacer()
            Text("I can make your UI look and feel way too slick and beautiful!")
                .padding()
            Spacer()
        }
    } backdropContent: {
        Image(systemName: "photo.stack.fill")
            .font(.system(size: 200))
    }

}

struct SlickBackdropViewLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(SlickBackdropView {
            Text("This is some text.")
        } backdropContent: {
            Image(systemName: "photo.stack.fill")
        }, visible: true, title: "Slick Backdrop View", category: .layout, matchingSignature: "slickbackdropview")
    }

}
