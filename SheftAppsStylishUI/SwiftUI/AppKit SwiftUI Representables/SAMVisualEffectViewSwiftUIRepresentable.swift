//
//  SAMVisualEffectViewSwiftUIRepresentable.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 2/15/23.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

#if os(macOS)

// MARK: - Imports

import SwiftUI

/// An `NSVisualEffectView` for use in SwiftUI.
public struct SAMVisualEffectViewSwiftUIRepresentable<Content: View>: NSViewRepresentable {

    // MARK: - Properties - Blending Mode

    let blendingMode: NSVisualEffectView.BlendingMode

    // MARK: - Properties - Material

    let material: NSVisualEffectView.Material

    // MARK: - Properties - Active State

    let activeState: NSVisualEffectView.State

    // MARK: - Properties - Content

    let content: Content

    // MARK: - Initialization

    /// Creates an `SAMVisualEffectViewSwiftUIRepresentable` with the given blending mode, material, active state, and content.
    /// - Parameters:
    ///   - blendingMode: The blending mode of the visual effect view, which determines whether the material should blur content from behind or within the window.
    ///   - material: The material of the visual effect view.
    ///   - activeState: Whether the visual effect view should always show its material, never show its material, or show its material based on the active state of the window. `active` is recommended for panels and settings windows.
    ///   - content: The SwiftUI content to display inside the visual effect view.
    ///
    /**
     Example: A visual effect view with a `Text` view inside it
     ```
        SAMVisualEffectViewSwiftUIRepresentable {
            Text("This is some text.")
        }
     ```
     */
    public init(blendingMode: NSVisualEffectView.BlendingMode = .behindWindow, material: NSVisualEffectView.Material = .underWindowBackground, activeState: NSVisualEffectView.State = .followsWindowActiveState, @ViewBuilder content: () -> Content) {
        self.blendingMode = blendingMode
        self.material = material
        self.activeState = activeState
        self.content = content()
    }

    // MARK: - NSViewRepresentable

    public func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.blendingMode = blendingMode
        visualEffectView.material = material
        visualEffectView.state = activeState
        return visualEffectView
    }

    public func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        // 1. Check if the hosting view already exists, and update it with new content if so.
        if let hostingView = nsView.subviews.first as? NSHostingView<Content> {
            hostingView.rootView = content
        } else {
            // 2. If it doesn't exist, create a new hosting view with the SwiftUI view content and add it as a subview.
            let hostingView = NSHostingView(rootView: content)
            hostingView.translatesAutoresizingMaskIntoConstraints = false
            nsView.addSubview(hostingView)
            // 3. Add constraints to the hosting view so it fills the visual effect view.
            NSLayoutConstraint.activate([
                hostingView.leadingAnchor.constraint(equalTo: nsView.leadingAnchor),
                hostingView.trailingAnchor.constraint(equalTo: nsView.trailingAnchor),
                hostingView.topAnchor.constraint(equalTo: nsView.topAnchor),
                hostingView.bottomAnchor.constraint(equalTo: nsView.bottomAnchor)
            ])
        }
    }
}

// MARK: - Preview

#Preview {
    SAMVisualEffectViewSwiftUIRepresentable {
        Text("This is some text.")
    }
}

// MARK: - Library Items

struct SAMVisualEffectViewSwiftUIRepresentableLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(SAMVisualEffectViewSwiftUIRepresentable(blendingMode: .behindWindow, material: .underWindowBackground, activeState: .followsWindowActiveState) {
            Text("This is some text.")
        }, visible: true, title: "SheftAppsStylishUI macOS Visual Effect View", category: .layout, matchingSignature: "visualeffectview")
    }

}
#endif
