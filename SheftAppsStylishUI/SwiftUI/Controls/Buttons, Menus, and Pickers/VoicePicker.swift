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

    /// Ways to display voices in a `VoicePicker`.
    public enum VoiceDisplayMode {
        /// Shows only the name and quality of the voice (e.g. "Samantha (Enhanced)").
        case nameOnly
        /// Shows the name and quality of the voice along with the type of voice (e.g. "Samantha (Enhanced) - System Voice").
        case nameAndType
        /// Groups voices by type (Personal, Custom, System) and shows only the name and quality of the voice (e.g. "Samantha (Enhanced)" under the "System" section).
        case groupByType
    }

    var label: Label
    
    @Binding var selectedVoiceID: String
    
    var voices: [AVSpeechSynthesisVoice]
    
    var voiceDisplayMode: VoiceDisplayMode = .groupByType

    var action: ((String) -> Void)?

    var sortedVoices: [AVSpeechSynthesisVoice] {
        return voices.sorted { voice1, voice2 in
            return voice2.nameIncludingQuality > voice1.nameIncludingQuality
        }
    }

    var containsPersonalVoices: Bool {
        return !sortedVoices.filter({$0.isPersonalVoice}).isEmpty
    }

    var containsCustomVoices: Bool {
        return !sortedVoices.filter({!$0.isSystemVoice && !$0.isPersonalVoice}).isEmpty
    }

    /// Creates a new `VoicePicker` with the given voice ID String binding, `AVSpeechSynthesisVoice` array, voice display mode, and label.
    /// - Parameters:
    ///   - selectedVoiceID: A `String` binding representing an ID string of an `AVSpeechSynthesisVoice`.
    ///   - voices: An array of `AVSpeechSynthesisVoice`s from which a voice can be selected.
    ///   - voiceDisplayMode: How to present the voice list: name and quality only, name, quality, and type, or name and quality only, grouped by type.
    ///   - action: The action to perform upon selecting a voice (e.g. speaking a sample message using the new voice). A `String` representing the selected voice ID is passed to this closure.
    ///   - label: The label for the picker.
    public init(selectedVoiceID: Binding<String>, voices: [AVSpeechSynthesisVoice], voiceDisplayMode: VoiceDisplayMode = .groupByType, onVoiceChanged action: ((String) -> Void)? = nil, @ViewBuilder label: @escaping (() -> Label) = {Text("Voice")}) {
        self.label = label()
        self._selectedVoiceID = selectedVoiceID
        self.voices = voices
        self.voiceDisplayMode = voiceDisplayMode
        self.action = action
    }
    
    /// Creates a new `VoicePicker` with the given title String, voice ID String binding, `AVSpeechSynthesisVoice` array, and voice display mode.
    /// - Parameters:
    ///   - title: The title of the picker.
    ///   - selectedVoiceID: A `String` binding representing an ID string of an `AVSpeechSynthesisVoice`.
    ///   - voices: An array of `AVSpeechSynthesisVoice`s from which a voice can be selected.
    ///   - voiceDisplayMode: How to present the voice list: name and quality only, name, quality, and type, or name and quality only, grouped by type.
    ///   - action: The action to perform upon selecting a voice (e.g. speaking a sample message using the new voice). A `String` representing the selected voice ID is passed to this closure.
    public init(_ title: String, selectedVoiceID: Binding<String>, voices: [AVSpeechSynthesisVoice], voiceDisplayMode: VoiceDisplayMode = .groupByType,  onVoiceChanged action: ((String) -> Void)? = nil) where Label == Text {
        self.label = Text(title)
        self._selectedVoiceID = selectedVoiceID
        self.voices = voices
        self.voiceDisplayMode = voiceDisplayMode
        self.action = action
    }

    public var body: some View {
        VStack {
            Picker(selection: $selectedVoiceID) {
                if voiceDisplayMode == .groupByType {
                    if containsPersonalVoices {
                        Section("Personal") {
                            ForEach(sortedVoices.filter({$0.isPersonalVoice})) { voice in
                                voiceItem(for: voice)
                            }
                        }
                    }
                    if containsCustomVoices {
                        Section("Custom") {
                            ForEach(sortedVoices.filter({$0.isCustomVoice})) { voice in
                                voiceItem(for: voice)
                            }
                        }
                    }
                    Section("System") {
                        ForEach(sortedVoices.filter({$0.isSystemVoice})) { voice in
                            voiceItem(for: voice)
                        }
                    }
                } else {
                    ForEach(sortedVoices) { voice in
                        voiceItem(for: voice)
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
        .onChange(of: selectedVoiceID) { oldVoice, newVoice in
            action?(newVoice)
        }
        #endif
    }

    @ViewBuilder
    func voiceItem(for voice: AVSpeechSynthesisVoice) -> some View {
        if voiceDisplayMode == .nameAndType {
            Text("\(voice.nameIncludingQuality) - \(voice.voiceType)")
                .tag(voice.identifier)
        } else {
            Text(voice.nameIncludingQuality)
                .tag(voice.identifier)
        }
    }

}

#Preview("Name and Quality Only") {
    @Previewable @State var selectedVoiceID = SADefaultVoiceID
    return VoicePicker(selectedVoiceID: $selectedVoiceID, voices: AVSpeechSynthesisVoice.speechVoices(), voiceDisplayMode: .nameOnly) { voiceID in

    }
}

#Preview("Name, Quality, and Type") {
    @Previewable @State var selectedVoiceID = SADefaultVoiceID
    return VoicePicker(selectedVoiceID: $selectedVoiceID, voices: AVSpeechSynthesisVoice.speechVoices(), voiceDisplayMode: .nameAndType) { voiceID in
    }
}

#Preview("Name and Quality Only, Group By Type") {
    @Previewable @State var selectedVoiceID = SADefaultVoiceID
    return VoicePicker(selectedVoiceID: $selectedVoiceID, voices: AVSpeechSynthesisVoice.speechVoices(), voiceDisplayMode: .groupByType) { voiceID in
    }
}

struct VoicePickerLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(VoicePicker("Voice", selectedVoiceID: .constant(SADefaultVoiceID), voices: AVSpeechSynthesisVoice.speechVoices()), visible: true, title: "Voice Picker", category: .control, matchingSignature: "voicepicker")
    }

}
