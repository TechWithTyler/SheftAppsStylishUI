//
//  ContinuousButtonModifier.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/9/23.
//

import Foundation

// MARK: - SwiftUI UI Code - Continuous Button Modifier

/// A view modifier that applies a button repeat behavior to buttons within this view on supported OS versions.
public struct ContinuousButtonModifier: ViewModifier {
    
    @ViewBuilder
    public func body(content: Content) -> some View {
        if #available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *) {
            content.buttonRepeatBehavior(.enabled)
        } else {
            content
        }
    }
    
}

// MARK: - View Extension

public extension View {
    
    /// Modifies a `Button` to continuously send its action on supported OS versions.
    @ViewBuilder
    func continuousButton() -> some View {
        modifier(ContinuousButtonModifier())
    }
    
}
