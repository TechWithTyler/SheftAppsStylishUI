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
    
    var sortedVoices: [AVSpeechSynthesisVoice] {
        return voices.sorted { voice1, voice2 in
            return voice2.name > voice1.name
        }
    }
    
    /// Creates a new `VoicePicker` with the given voice ID String binding, `AVSpeechSynthesisVoice` array, and label.
    public init(selectedVoiceID: Binding<String>, voices: [AVSpeechSynthesisVoice], @ViewBuilder label: @escaping (() -> Label) = {Text("Voice")}) {
        self.label = label()
        self._selectedVoiceID = selectedVoiceID
        self.voices = voices
    }
    
    /// Creates a new `VoicePicker` with the given title String, voice ID String binding, and `AVSpeechSynthesisVoice` array.
    public init(_ title: String, selectedVoiceID: Binding<String>, voices: [AVSpeechSynthesisVoice]) where Label == Text {
        self.label = Text(title)
        self._selectedVoiceID = selectedVoiceID
        self.voices = voices
    }
    
    public var body: some View {
        Picker(selection: $selectedVoiceID) {
            ForEach(sortedVoices) { voice in
                Text(voice.nameIncludingQuality)
                    .tag(voice.identifier)
            }
        } label: {
            label
        }
    }
    
}

#Preview {
    @State var selectedVoiceID = "com.apple.ttsbundle.Samantha.compact"
    return VoicePicker(selectedVoiceID: $selectedVoiceID, voices: AVSpeechSynthesisVoice.speechVoices())
}
