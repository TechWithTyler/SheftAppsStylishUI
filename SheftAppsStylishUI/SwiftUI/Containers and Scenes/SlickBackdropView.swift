//
//  SlickBackdropView.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 5/12/23.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import SwiftUI

/// A view composed of background and foreground content, with a translucent material in-between.
///
/// For master-detail UIs with a small image in the list row and a large image in the detail view, containing the detail view within a `SlickBackdropView` with the image as its `backdropContent` can give your UI an ultra-slick look and a sense of context.
public struct SlickBackdropView<BackdropContent: View, ForegroundContent: View>: View {

    // MARK: - Properties - Content

    @ViewBuilder var foregroundContent: ForegroundContent

    @ViewBuilder var backdropContent: BackdropContent

    // MARK: - Properties - Material

    var material: Material

    // MARK: - Properties - System Theme

	@Environment(\.colorScheme) var systemTheme
    
    // MARK: - Properties - Booleans

	@Environment(\.accessibilityReduceTransparency) var reduceTransparency

    // MARK: - Initialization

    /// Creates a new `SlickBackdropView` with the given foreground content and backdrop content.
    ///
    /// - parameter material: The `Material` to use for the backdrop effect. Defaults to `Material.regularMaterial`.
    /// - parameter foregroundContent: The main content of the view.
    /// - parameter backdropContent: The content to blur behind the foreground content.
    ///
    /// - Important: Don't include interactive UI (e.g. buttons, sliders, or text fields) in `backdropContent`.
    ///
    /// Choose a `Material` based on how much you want your backdrop content (e.g., an oversized version of a foreground image) to shine. For example, Phonepedia uses a `SlickBackdropView` in its detail view to show a blurred, oversized version of a phone's image behind the detail view, giving a sense of context and an ultra-slick look and feel.
    public init(material: Material = .regularMaterial, @ViewBuilder foregroundContent: () -> ForegroundContent, @ViewBuilder backdropContent: () -> BackdropContent) {
        self.backdropContent = backdropContent()
        self.foregroundContent = foregroundContent()
        self.material = material
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geometry in
            if !reduceTransparency {
                ZStack {
                    // Backdrop content
                    backdropContent
                        .padding()
                    .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                    #if !os(visionOS)
                    .backwardsCompatibleBackgroundExtensionEffect()
                    #endif
                    // Foreground content
                    foregroundContent
                        .background(material)
                }
            } else {
                foregroundContent
            }
        }
    }
}

// MARK: - Preview

#Preview {

    @Previewable @State var selectedMaterial: Double = 0

    let imageName = "photo.stack.fill"

    var material: Material {
        switch selectedMaterial {
            // Based on the selectedMaterial Int, choose one of the SwiftUI Material values.
        case 0: return .ultraThinMaterial
        case 1: return .thinMaterial
        case 2: return .regularMaterial
        case 3: return .thickMaterial
        default: return .ultraThickMaterial
        }
    }

    SlickBackdropView(material: material) {
        VStack {
            Spacer()
            Image(systemName: imageName)
                .font(.system(size: 50))
            Text("I can make your UI look and feel way too slick and beautiful!")
                .padding()
            Slider(value: $selectedMaterial, in: 0...4, step: 1) {
                Text("Material")
            } minimumValueLabel: {
                Text("Thin")
            } maximumValueLabel: {
                Text("Thick")
            }
            .padding()
            Spacer()
        }
    } backdropContent: {
        Image(systemName: imageName)
            .font(.system(size: 200))
    }

}

// MARK: - Library Items

struct SlickBackdropViewLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(SlickBackdropView {
            Text("This is some text.")
        } backdropContent: {
            Image(systemName: "photo.stack.fill")
        }, visible: true, title: "Slick Backdrop View", category: .layout, matchingSignature: "slickbackdropview")
    }

}
