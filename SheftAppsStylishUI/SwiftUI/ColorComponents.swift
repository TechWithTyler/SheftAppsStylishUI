//
//  ColorComponents.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/22/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import Foundation

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
public extension Color {
    
    /// The red, green, blue, and opacity (alpha) components of the color. Use `components.red`, `components.green`, and `components.blue` to get the respective color component.
    var components: Components {
        return Components(fromColor: self)
    }
    
    /// The red, green, blue, and opacity (alpha) components of a `Color`.
    struct Components {
        
        /// The red component of the color.
        public let red: Double
        
        /// The green component of the color.
        public let green: Double
        
        /// The blue component of the color.
        public let blue: Double
        
        /// The opacity (alpha) component of the color.
        public let opacity: Double
        
        /// Creates a new `ColorComponents` instance from `color`.
        public init(fromColor color: Color) {
            let resolved = color.resolve(in: EnvironmentValues())
            self.red = Double(resolved.red)
            self.green = Double(resolved.green)
            self.blue = Double(resolved.blue)
            self.opacity = Double(resolved.opacity)
        }
        
    }
    
}
