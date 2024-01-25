//
//  IdentifiableVoiceExtension.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/22/24.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import Foundation
import AVFoundation

/// Adds `Identifiable` conformance and other properties to `AVSpeechSynthesisVoice`
extension AVSpeechSynthesisVoice: Identifiable {
    
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
    @available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
    public var voiceType: String {
        if voiceTraits.contains(.isPersonalVoice) {
            return "Personal Voice"
        } else if identifier.hasPrefix("com.apple") {
            return "System Voice"
        } else {
            return "Custom Voice"
        }
    }
    
}
