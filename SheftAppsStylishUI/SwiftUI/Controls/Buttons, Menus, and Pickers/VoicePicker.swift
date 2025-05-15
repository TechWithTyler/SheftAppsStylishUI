//
//  VoicePicker.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/22/24.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
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
    /// Note - On 2022 OS versions, `showVoiceType` does nothing.
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
    ///   - action: The action to perform upon selecting a voice (e.g. speaking a sample message using the new voice). A `String` representing the selected voice ID is passed to this closure.
    /// - Note: On 2022 OS versions, `showVoiceType` does nothing.
    public init(_ title: String, selectedVoiceID: Binding<String>, voices: [AVSpeechSynthesisVoice], showVoiceType: Bool = false,  onVoiceChanged action: ((String) -> Void)? = nil) where Label == Text {
        self.label = Text(title)
        self._selectedVoiceID = selectedVoiceID
        self.voices = voices
        self.showVoiceType = showVoiceType
        self.action = action
    }
    public var body: some View {
        VStack {
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
        }
        #if os(visionOS)
        .onChange(of: selectedVoiceID) { oldVoice, newVoice in
            action?(newVoice)
        }
        #else
        .onChange(of: selectedVoiceID) { voice in
            action?(voice)
        }
        #endif
    }
    
}

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
#Preview("With Voice Type") {
    @Previewable @State var selectedVoiceID = SADefaultVoiceID
    return VoicePicker(selectedVoiceID: $selectedVoiceID, voices: AVSpeechSynthesisVoice.speechVoices(), showVoiceType: true) { voiceID in

    }
}

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
#Preview("Without Voice Type") {
    @Previewable @State var selectedVoiceID = SADefaultVoiceID
    return VoicePicker(selectedVoiceID: $selectedVoiceID, voices: AVSpeechSynthesisVoice.speechVoices(), showVoiceType: false) { voiceID in
    }
}

struct VoicePickerLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(VoicePicker("Voice", selectedVoiceID: .constant(SADefaultVoiceID), voices: AVSpeechSynthesisVoice.speechVoices()), visible: true, title: "Voice Picker", category: .control, matchingSignature: "voicepicker")
    }

}
