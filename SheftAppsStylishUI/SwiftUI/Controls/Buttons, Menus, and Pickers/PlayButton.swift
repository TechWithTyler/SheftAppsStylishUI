//
//  PlayButton.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 2/18/25.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

// MARK: - Imports

import SwiftUI

/// A borderless `Button` used as a play/stop button.
public struct PlayButton: View {

    // MARK: - Properties - Action

    var action: (() -> Void)

    // MARK: - Properties - Strings

    var playTitle: String

    var stopTitle: String

    // MARK: - Properties - Booleans

    var isPlaying: Bool

    // MARK: - Initialization

    /// Creates a new `PlayButton` with the given titles, Boolean value indicating whether the button should show as "playing" or "stopped", and the given action closure.
    /// - Parameter playTitle: The title of the button when it's in the "stopped" state.
    /// - Parameter stopTitle: The title of the button when it's in the "playing" state.
    /// - Parameter isPlaying: A Boolean value indicating whether the button should appear in the "playing" state (`true`) or "stopped" state (`false`).
    /// - Parameter action: The action of the button.
    ///
    /// The action of the button should start or stop the playing of something (e.g., an audio file) and toggle the value of `isPlaying`.
    ///
    /// If `playTitle` and `stopTitle` are the same other than the words "Play"/"Stop" (e.g. "Play Sample" and "Stop Sample"), consider using the initializer that takes a single noun `String` instead.
    public init(playTitle: String = "Play", stopTitle: String = "Stop", isPlaying: Bool, action: @escaping () -> Void) {
        self.playTitle = playTitle
        self.stopTitle = stopTitle
        self.action = action
        self.isPlaying = isPlaying
    }

    /// Creates a new `PlayButton` with the given noun String, Boolean value indicating whether the button should show as "playing" or "stopped", and the given action closure.
    /// - Parameter noun: A noun describing what to play/stop.
    /// - Parameter isPlaying: A Boolean value indicating whether the button should appear in the "playing" state (`true`) or "stopped" state (`false`).
    /// - Parameter action: The action of the button.
    ///
    /// The action of the button should start or stop the playing of something (e.g., an audio file) and toggle the value of `isPlaying`.
    /// To use a fully-custom title, use the initializer that takes 2 title `String`s instead.
    public init(noun: String, isPlaying: Bool, action: @escaping () -> Void) {
        self.playTitle = "Play \(noun)"
        self.stopTitle = "Stop \(noun)"
        self.action = action
        self.isPlaying = isPlaying
    }

    // MARK: - Body

    public var body: some View {
        Button {
            action()
        } label: {
            Label(isPlaying ? stopTitle : playTitle, systemImage: isPlaying ? "stop.fill" : "play.fill")
        }
        .animatedSymbolReplacement()
        .buttonStyle(.borderless)
        #if os(iOS)
        .hoverEffect(.highlight)
        #endif
    }

}

// MARK: - Preview

#Preview("Simple Play/Stop") {
    let isPlaying: Bool = false
    PlayButton(isPlaying: isPlaying) {

    }
    .padding()
}

#Preview("Custom Titles") {
    let isPlaying: Bool = false
    PlayButton(playTitle: "Play Sample", stopTitle: "Stop Playing", isPlaying: isPlaying) {

    }
    .padding()
}

#Preview("Noun") {
    let isPlaying: Bool = false
    PlayButton(noun: "Sample", isPlaying: isPlaying) {

    }
    .padding()
}

// MARK: - Library Items

struct PlayButtonLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(PlayButton(isPlaying: false, action: {
            
        }), visible: true, title: "Play Button (Simple Play/Stop)", category: .control, matchingSignature: "playbutton")
        LibraryItem(PlayButton(playTitle: "Play", stopTitle: "Stop Playing", isPlaying: false, action: {

        }), visible: true, title: "Play Button (Custom Titles)", category: .control, matchingSignature: "playbutton")
        LibraryItem(PlayButton(noun: "Sample", isPlaying: false, action: {

        }), visible: true, title: "Play Button (Noun)", category: .control, matchingSignature: "playbutton")
    }

}
