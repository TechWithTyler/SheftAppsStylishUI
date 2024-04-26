//
//  VoicePicker.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/22/24.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import SwiftUI
import AVFoundation

/// A `Picker` for selecting a voice.
public struct VoicePicker<Label: View>: View {
    
    var label: Label
    
    @Binding var selectedVoiceID: String
    
    var voices: [AVSpeechSynthesisVoice]
    
    var showVoiceType: Bool

    var action: ((String) -> Void)?

    var sortedVoices: [AVSpeechSynthesisVoice] {
        return voices.sorted { voice1, voice2 in
            return voice2.name > voice1.name
        }
    }
    
    /// Creates a new `VoicePicker` with the given voice ID String binding, `AVSpeechSynthesisVoice` array, Boolean indicating whether to show the type of voice (system, custom, or personal), and label.
    /// Note - On 2022 or earlier OS versions, `showVoiceType` does nothing.
    /// - Parameters:
    ///   - selectedVoiceID: A `String` binding representing an ID string of an `AVSpeechSynthesisVoice`.
    ///   - voices: An array of `AVSpeechSynthesisVoice`s from which a voice can be selected.
    ///   - showVoiceType: Whether the type of voice is shown alongside the voice name (requires 2023 or later OS versions).
    ///   - action: The action to perform upon selecting a voice (e.g. speaking a sample message using the new voice).
    ///   - label: The label for the picker.
    public init(selectedVoiceID: Binding<String>, voices: [AVSpeechSynthesisVoice], showVoiceType: Bool = false, onVoiceChanged action: ((String) -> Void)? = nil, @ViewBuilder label: @escaping (() -> Label) = {Text("Voice")}) {
        self.label = label()
        self._selectedVoiceID = selectedVoiceID
        self.voices = voices
        self.showVoiceType = showVoiceType
        self.action = action
    }
    
    /// Creates a new `VoicePicker` with the given title String, voice ID String binding, `AVSpeechSynthesisVoice` array, and Boolean indicating whether to show the type of voice (system, custom, or personal).
    /// - Parameters:
    ///   - title: The title of the picker.
    ///   - selectedVoiceID: A `String` binding representing an ID string of an `AVSpeechSynthesisVoice`.
    ///   - voices: An array of `AVSpeechSynthesisVoice`s from which a voice can be selected.
    ///   - showVoiceType: Whether the type of voice is shown alongside the voice name (requires 2023 or later OS versions).
    ///   - action: The action to perform upon selecting a voice (e.g. speaking a sample message using the new voice).
    /// - Note: On 2022 or earlier OS versions, `showVoiceType` does nothing.
    public init(_ title: String, selectedVoiceID: Binding<String>, voices: [AVSpeechSynthesisVoice], showVoiceType: Bool = false,  onVoiceChanged action: ((String) -> Void)? = nil) where Label == Text {
        self.label = Text(title)
        self._selectedVoiceID = selectedVoiceID
        self.voices = voices
        self.showVoiceType = showVoiceType
        self.action = action
    }
    
    public var body: some View {
        Picker(selection: $selectedVoiceID) {
            ForEach(sortedVoices) { voice in
                    if #available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *), showVoiceType {
                            Text("\(voice.nameIncludingQuality) - \(voice.voiceType)")
                                .tag(voice.identifier)
                    } else {
                        Text(voice.nameIncludingQuality)
                            .tag(voice.identifier)
                    }
            }
        } label: {
            label
        }
        .onChange(of: selectedVoiceID) { voice in
            action?(voice)
        }
    }
    
}

#Preview("With Voice Type") {
    @State var selectedVoiceID = "com.apple.voice.compact.en-US.Samantha"
    return VoicePicker(selectedVoiceID: $selectedVoiceID, voices: AVSpeechSynthesisVoice.speechVoices(), showVoiceType: true) { voiceID in

    }
}

#Preview("Without Voice Type") {
    @State var selectedVoiceID = "com.apple.voice.compact.en-US.Samantha"
    return VoicePicker(selectedVoiceID: $selectedVoiceID, voices: AVSpeechSynthesisVoice.speechVoices(), showVoiceType: false) { voiceID in
    }
}
