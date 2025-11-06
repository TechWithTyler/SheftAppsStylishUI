//
//  IdentifiableVoiceExtension.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/22/24.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
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
        let voiceName = self.name
        #if os(macOS)
        var quality: String {
            switch self.quality {
            case .enhanced:
                return " (Enhanced)"
            case .premium:
                return " (Premium)"
            default:
                return String()
            }
        }
        return voiceName + quality
        #else
        return voiceName
        #endif
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
