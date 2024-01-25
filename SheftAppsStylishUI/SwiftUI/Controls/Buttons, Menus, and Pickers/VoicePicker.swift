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
    
    var sortedVoices: [AVSpeechSynthesisVoice] {
        return voices.sorted { voice1, voice2 in
            return voice2.name > voice1.name
        }
    }
    
    /// Creates a new `VoicePicker` with the given voice ID String binding, `AVSpeechSynthesisVoice` array, Boolean indicating whether to show the type of voice (system, custom, or personal), and label.
    /// Note - On 2022 or earlier OS versions, `showVoiceType` does nothing.
    public init(selectedVoiceID: Binding<String>, voices: [AVSpeechSynthesisVoice], showVoiceType: Bool = false, @ViewBuilder label: @escaping (() -> Label) = {Text("Voice")}) {
        self.label = label()
        self._selectedVoiceID = selectedVoiceID
        self.voices = voices
        self.showVoiceType = showVoiceType
    }
    
    /// Creates a new `VoicePicker` with the given title String, voice ID String binding, `AVSpeechSynthesisVoice` array, and Boolean indicating whether to show the type of voice (system, custom, or personal).
    /// - Note: On 2022 or earlier OS versions, `showVoiceType` does nothing.
    public init(_ title: String, selectedVoiceID: Binding<String>, voices: [AVSpeechSynthesisVoice], showVoiceType: Bool = false) where Label == Text {
        self.label = Text(title)
        self._selectedVoiceID = selectedVoiceID
        self.voices = voices
        self.showVoiceType = showVoiceType
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
    }
    
}

#Preview("With Voice Type") {
    @State var selectedVoiceID = "com.apple.ttsbundle.Samantha-compact"
    return VoicePicker(selectedVoiceID: $selectedVoiceID, voices: AVSpeechSynthesisVoice.speechVoices(), showVoiceType: true)
}

#Preview("Without Voice Type") {
    @State var selectedVoiceID = "com.apple.ttsbundle.Samantha-compact"
    return VoicePicker(selectedVoiceID: $selectedVoiceID, voices: AVSpeechSynthesisVoice.speechVoices(), showVoiceType: false)
}
