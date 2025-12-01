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

/// Adds `Identifiable` conformance and other properties to `AVSpeechSynthesisVoice`
extension AVSpeechSynthesisVoice: @retroactive Identifiable {

    // MARK: - Properties - Strings

    public var id: String { identifier }
    
    /// The voice's name including its quality if available (e.g., "Samantha (Enhanced)")
    public var nameIncludingQuality: String {
        let enhancedSuffix = " (Enhanced)"
        let premiumSuffix = " (Premium)"
        let voiceName = self.name
        if voiceName.contains(premiumSuffix) || voiceName.contains(enhancedSuffix) {
            return voiceName
        } else {
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
    public var isSystemVoice: Bool {
        return identifier.hasPrefix("com.apple") && !isPersonalVoice
    }

    /// Whether this voice is a personal voice.
    public var isPersonalVoice: Bool {
        return voiceTraits.contains(.isPersonalVoice)
    }

    /// Whether this voice is a custom voice that isn't a personal voice.
    public var isCustomVoice: Bool {
        return !isSystemVoice
    }

}
