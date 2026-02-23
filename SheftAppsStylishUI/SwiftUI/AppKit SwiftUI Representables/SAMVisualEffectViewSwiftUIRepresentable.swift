//
//  SAMVisualEffectViewSwiftUIRepresentable.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 2/15/23.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

#if os(macOS)

// MARK: - Imports

import SwiftUI

/// An `NSVisualEffectView` for use in SwiftUI.
///
/// Fun fact: This component was introduced 2 days after SkippyNums' start of development!
// NSViewRepresentable allows an NSView to be placed (hosted) in a SwiftUI view. NSViewControllerRepresentable hosts the view created by an NSViewController in a SwiftUI view.
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
    ///   - blendingMode: The blending mode of the visual effect view, which determines whether the material should blur content from behind or within the window. Defaults to `NSVisualEffectView.BlendingMode.behindWindow`.
    ///   - material: The material of the visual effect view. Defaults to `NSVisualEffectVIew.Material.underWindowBackground`.
    ///   - activeState: Whether the visual effect view should always show its material, never show its material, or show its material based on the active state of the window. `NSVisualEffectView.State.active` is recommended for panels and settings windows. Defaults to `NSVisualEffectView.State.followsWindowActiveState`
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

    /// Makes an `NSView` representation of the `NSVisualEffetView`.
    ///
    /// - Parameter context: The context in which the representable is created.
    /// - Returns: An `NSVisualEffectView`.
    public func makeNSView(context: Context) -> NSVisualEffectView {
        // 1. Create an NSVisualEffectView.
        let visualEffectView = NSVisualEffectView(frame: .zero)
        // 2. Configure the blending mode, material, and active state.
        visualEffectView.blendingMode = blendingMode
        visualEffectView.material = material
        visualEffectView.state = activeState
        // 3. Return the visual effect view.
        return visualEffectView
    }

    /// Updates the `NSView` representation of the `NSVisualEffectView`.
    ///
    /// - Parameters:
    ///   - visualEffectView: The `NSVisualEffectView` to be updated.
    ///   - context: The context in which the representable is updated.
    public func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context) {
        // 1. Check if the hosting view already exists, and update it with new content if so.
        if let hostingView = visualEffectView.subviews.first as? NSHostingView<Content> {
            hostingView.rootView = content
        } else {
            // 2. If it doesn't exist, create a new hosting view with the SwiftUI view content and add it as a subview.
            let hostingView = NSHostingView(rootView: content)
            hostingView.translatesAutoresizingMaskIntoConstraints = false
            visualEffectView.addSubview(hostingView)
            // 3. Add constraints to the hosting view so it fills the visual effect view.
            NSLayoutConstraint.activate([
                hostingView.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor),
                hostingView.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor),
                hostingView.topAnchor.constraint(equalTo: visualEffectView.topAnchor),
                hostingView.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor)
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
