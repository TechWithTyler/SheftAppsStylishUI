//
//  BackgroundExtensionEffectModifier.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 6/11/25.
//  Copyright © 2025 SheftApps. All rights reserved.
//

import SwiftUI

// MARK: - Backwards-Compatible Background Extension Effect Modifier

@available(visionOS, unavailable)
public struct BackwardsCompatibleBackgroundExtensionEffectModifier: ViewModifier {

    public func body(content: Content) -> some View {
        if #available(macOS 26, iOS 26, tvOS 26, watchOS 26, *) {
            content
                .backgroundExtensionEffect()
        } else {
            content
        }
        
    }
    
}

// MARK: - View Extension

@available(visionOS, unavailable)
public extension View {

    /// Adds a background extension effect to this view on version 26 or later.
    @ViewBuilder
    func backwardsCompatibleBackgroundExtensionEffect() -> some View {
        modifier(BackwardsCompatibleBackgroundExtensionEffectModifier())
    }

}
