//
//  ColorComponents.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/22/23.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

import Foundation

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
/// Adds a property to get a `Color`'s red, green, blue, and opacity (alpha) components.
extension Color: @retroactive Identifiable {
    
    /// The ID of the color, which is the sum of all its component values.
    public var id: Double {
        return components.red + components.green + components.blue + components.opacity
    }
    
    /// The red, green, blue, and opacity (alpha) components of a `Color`.
    public struct Components {
        
        /// The red component of the color.
        public let red: Double
        
        /// The green component of the color.
        public let green: Double
        
        /// The blue component of the color.
        public let blue: Double
        
        /// The opacity (alpha) component of the color.
        public let opacity: Double
        
        /// Creates a new `ColorComponents` instance from the components of `color`.
        public init(fromColor color: Color) {
            let resolved = color.resolve(in: EnvironmentValues())
            self.red = Double(resolved.red)
            self.green = Double(resolved.green)
            self.blue = Double(resolved.blue)
            self.opacity = Double(resolved.opacity)
        }
        
    }

    /// The red, green, blue, and opacity (alpha) components of the color. Use `components.red`, `components.green`, `components.blue`, and `components.opacity` to get the desired color components.
    public var components: Components {
        return Components(fromColor: self)
    }
    
}
