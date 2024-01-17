//
//  SAMButtonSwiftUIRepresentable.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/16/24.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

#if os(macOS)
import SwiftUI

/// A custom `NSViewRepresentable` that represents an `SAMButton`.
public struct SAMButtonSwiftUIRepresentable: NSViewRepresentable {

    /// The title of the button.
    public var title: String

    /// The action that should be triggered when the button is clicked.
    public var action: (() -> Void)

    /// Whether the border should only be visible when the mouse is hovering over the button.
    @Binding public var borderOnHover: Bool

    /// Initializes the `SAMButtonSwiftUIRepresentable`.
    ///
    /// - Parameters:
    ///   - title: The title of the button.
    ///   - borderOnHover: Whether the border should only be visible when the mouse is hovering over the button. Defaults to `false`.
    ///   - action: The action that should be triggered when the button is clicked.
    public init(title: String, borderOnHover: Binding<Bool> = .constant(false), action: @escaping (() -> Void)) {
        self._borderOnHover = borderOnHover
        self.title = title
        self.action = action
    }

    /// Makes an `NSView` representation of the `SAMButton`.
    ///
    /// - Parameter context: The context in which the representable is created.
    /// - Returns: An `SAMButton`.
    public func makeNSView(context: Context) -> SAMButton {
        let button = SAMButton(frame: .zero)
        button.title = title
        button.target = context.coordinator
        button.action = #selector(Coordinator.buttonClicked)
        // Add Auto Layout constraints to set the button's height to 24 pixels
        button.setContentHuggingPriority(.required, for: .vertical)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return button
    }

    /// Updates the `NSView` representation of the `SAMButton`.
    ///
    /// - Parameters:
    ///   - button: The `SAMButton` to be updated.
    ///   - context: The context in which the representable is updated.
    public func updateNSView(_ button: SAMButton, context: Context) {
        button.title = title
        button.showsBorderOnlyWhileMouseInside = borderOnHover
        SheftAppsStylishUI.addTrackingArea(to: button)
    }

    /// Makes a `Coordinator` for the `SAMButton`.
    ///
    /// - Returns: A `Coordinator`.
    public func makeCoordinator() -> Coordinator {
        return Coordinator(action: action)
    }

    /// The `Coordinator` for the `SAMButton`.
    public class Coordinator: NSObject {

        /// The action that should be triggered when the button is clicked.
        public var action: (() -> Void)

        /// Initializes the `Coordinator`.
        ///
        /// - Parameter action: The action that should be triggered when the button is clicked.
        public init(action: @escaping (() -> Void)) {
            self.action = action
        }

        /// Triggers the action when the button is clicked.
        @objc func buttonClicked() {
            action()
        }
    }
}

#Preview("SwiftUI SAMButtonSwiftUIRepresentable") {
    SAMButtonSwiftUIRepresentable(title: "Button") {
        NSSound.beep()
    }
}
#endif
