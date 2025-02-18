//
//  PlayButton.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 2/18/25.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

import SwiftUI

/// A borderless `Button` used as a play/stop button.
@available(tvOS 17, *)
public struct PlayButton: View {

    var action: (() -> Void)

    var playTitle: String

    var stopTitle: String

    var isPlaying: Bool

    /// Creates a new `PlayButton` with the given titles, Boolean value indicating whether the button should show as "playing" or "stopped", and the given action closure.
    /// - Parameter playTitle: The title of the button when it's in the "stopped" state.
    /// - Parameter stopTitle: The title of the button when it's in the "playing" state.
    /// - Parameter isPlaying: A Boolean value indicating whether the button should appear in the "playing" state (`true`) or "stopped" state (`false`).
    /// - Parameter action: The action of the button.
    ///
    /// The action of the button should start or stop the playing of something (e.g., an audio file) and toggle the value of `isPlaying`.
    public init(playTitle: String = "Play", stopTitle: String = "Stop", isPlaying: Bool, action: @escaping () -> Void) {
        self.playTitle = playTitle
        self.stopTitle = stopTitle
        self.action = action
        self.isPlaying = isPlaying
    }

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

@available(tvOS 17, *)
#Preview {
    let isPlaying: Bool = false
    PlayButton(isPlaying: isPlaying) {

    }
    .padding()
}

@available(tvOS 17, *)
struct PlayButtonLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(PlayButton(isPlaying: false, action: {
            
        }), visible: true, title: "Play Button", category: .control, matchingSignature: "playbutton")
    }

}
