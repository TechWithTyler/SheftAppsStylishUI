//
//  IdentifiableVoiceExtension.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/22/24.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import Foundation
import AVFoundation

/// Adds `Identifiable` conformance and other properties to `AVSpeechSynthesisVoice`.
extension AVSpeechSynthesisVoice: @retroactive Identifiable {

    // MARK: - Properties - Strings

    /// The ID of the voice.
    public var id: String { return identifier }

    /// The voice's name including its quality if available (e.g., "Samantha (Enhanced)").
    ///
    /// If the voice's name already includes a quality suffix, this property returns the voice name as is.
    public var nameIncludingQuality: String {
        // 1. Define the quality suffixes.
        let enhancedSuffix = " (Enhanced)"
        let premiumSuffix = " (Premium)"
        // 2. Get the voice name.
        let voiceName = self.name
        let voiceNameContainsSuffix = voiceName.contains(premiumSuffix) || voiceName.contains(enhancedSuffix)
        if voiceNameContainsSuffix {
            // 3. If the voice name already contains one of these suffixes, return the voice name as is.
            return voiceName
        } else {
            // 4. Otherwise, use the quality to determine the suffix to add.
            var quality: String {
                switch self.quality {
                case .enhanced:
                    return enhancedSuffix
                case .premium:
                    return premiumSuffix
                default:
                    return String()
                }
            }
            // 5. Return the name including the suffix.
            return voiceName + quality
        }
    }

    /// A string describing the type of voice (system, custom, or personal).
    public var voiceType: String {
        if isPersonalVoice {
            return "Personal Voice"
        } else if isSystemVoice {
            return "System Voice"
        } else {
            return "Custom Voice"
        }
    }

    // MARK: - Properties - Booleans

    /// Whether this voice is a system voice.
    ///
    /// The identifiers of system voices always begin with "com.apple".
    public var isSystemVoice: Bool {
        return identifier.hasPrefix("com.apple") && !isPersonalVoice
    }

    /// Whether this voice is a personal voice.
    public var isPersonalVoice: Bool {
        return voiceTraits.contains(.isPersonalVoice)
    }

    /// Whether this voice is a custom voice (i.e. a voice not provided by the system) that isn't a personal voice.
    public var isCustomVoice: Bool {
        return !isSystemVoice
    }

}
