//
//  SAMVisualEffectViewSwiftUIRepresentable.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 2/15/23.
//  Copyright © 2022-2023 SheftApps. All rights reserved.
//

import SwiftUI

#if os(macOS)
/// An `NSVisualEffectView` for use in SwiftUI.
public struct SAMVisualEffectViewSwiftUIRepresentable<Content: View>: NSViewRepresentable {

	private let blendingMode: NSVisualEffectView.BlendingMode

	private let material: NSVisualEffectView.Material

	private let activeState: NSVisualEffectView.State

	private let content: Content
	
	/// Initializes an `SAMVisualEffectViewSwiftUIRepresentable`
	/// - Parameters:
	///   - blendingMode: The blending mode for the visual effect view.
	///   - material: The material for the visual effect view.
	///   - activeState: Whether the visual effect view should always show its material, never show its material, or show its material based on the active state of the window.
	///   - content: The SwiftUI content to display inside the visual effect view.
	///
	/**
	 Example: A visual effect view with a Text view inside it
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

	public func makeNSView(context: Context) -> NSVisualEffectView {
		let visualEffectView = NSVisualEffectView()
		visualEffectView.blendingMode = blendingMode
		return visualEffectView
	}

	public func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
		// Check if the hosting view already exists
		if let hostingView = nsView.subviews.first as? NSHostingView<Content> {
			// Update the hosting view with the new content
			hostingView.rootView = content
		} else {
			// If it doesn't exist, create a new hosting view and add it as a subview
			let hostingView = NSHostingView(rootView: content)
			hostingView.translatesAutoresizingMaskIntoConstraints = false
			nsView.addSubview(hostingView)
			NSLayoutConstraint.activate([
				hostingView.leadingAnchor.constraint(equalTo: nsView.leadingAnchor),
				hostingView.trailingAnchor.constraint(equalTo: nsView.trailingAnchor),
				hostingView.topAnchor.constraint(equalTo: nsView.topAnchor),
				hostingView.bottomAnchor.constraint(equalTo: nsView.bottomAnchor)
			])
		}
	}
}
#endif
