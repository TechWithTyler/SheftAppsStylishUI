//
//  ColorComponents.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/22/23.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import Foundation

/// Adds methods and properties for getting a `Color`'s red, green, blue, and alpha (opacity) components and working with `Color` bindings. This is useful when needing to convert a `Color` to/from `Double` values stored in persistent data (e.g. UserDefaults, Core Data, SwiftData).
extension Color {

    // MARK: - Type Aliases

    /// A `Double` value represented as a red color value.
    public typealias Red = Double

    /// A `Double` value represented as a green color value.
    public typealias Green = Double

    /// A `Double` value represented as a blue color value.
    public typealias Blue = Double

    /// A `Double` value represented as a color's alpha value.
    public typealias Alpha = Double

    /// A tuple represented as RGB.
    public typealias RGB = (Red, Green, Blue)

    /// A tuple represented as RGBA.
    public typealias RGBA = (Red, Green, Blue, Alpha)

    // MARK: - Color Components Struct
    
    /// The red, green, blue, and opacity (alpha) components of a `Color`.
    public struct Components {

        /// The red component of the color.
        public let red: Red

        /// The green component of the color.
        public let green: Green

        /// The blue component of the color.
        public let blue: Blue

        /// The opacity (alpha) component of the color.
        public let opacity: Alpha

        /// Creates a new `Components` instance from the components of `color`.
        public init(fromColor color: Color) {
            // 1. Create a resolved version of the color to get its components.
            let resolved = color.resolve(in: EnvironmentValues())
            // 2. Set the components to these resolved values.
            self.red = Red(resolved.red)
            self.green = Green(resolved.green)
            self.blue = Blue(resolved.blue)
            self.opacity = Alpha(resolved.opacity)
        }

    }

    // MARK: - Properties - Color Components

    /// The red, green, blue, and opacity (alpha) components of the color. Use `components.red`, `components.green`, `components.blue`, and `components.opacity` to get the desired color components.
    public var components: Components {
        return Components(fromColor: self)
    }

    // MARK: - Binding Helper Methods

    /// Creates a binding to a `Color` backed by `Red`, `Green`, and `Blue` components.
    /// - Parameters:
    ///   - get: Closure returning current red, green, and blue components.
    ///   - set: Closure receiving new red, green, and blue components.
    /// - Returns: A `Binding<Color>` with the given color values.
    /// - Note: If a `Color` needs to have an alpha component, use `rgbaBinding(get:set:)` or `rgbaQuantizedAlphaBinding(get:set:)` instead.
    public static func rgbBinding(get: @escaping () -> RGB, set: @escaping (Red, Green, Blue) -> Void) -> Binding<Color> {
        // A binding is a get-only property that runs code when its value is changed by setting the property that's passed as its value.
        Binding<Color> {
            // 1. Initialize an RGB tuple from the binding's getter.
            let (r, g, b) = get()
            // 2. Create and return a Color from that tuple's values.
            let color = Color(red: r, green: g, blue: b)
            return color
        } set: { newColor in
            // 3. When the value of the property changes, set the components of the color to the components of its new value.
            let components = newColor.components
            set(components.red, components.green, components.blue)
        }
    }

    /// Creates a binding to a `Color` backed by RGBA where alpha is stored as a `Double` from 0.0 to 1.0.
    /// - Parameters:
    ///   - get: Closure returning current red, green, blue, and alpha components.
    ///   - set: Closure receiving new red, green, blue, and alpha components.
    /// - Returns: A `Binding<Color>` with the given color values.
    /// - Note: If a `Color`'s alpha component needs to be exactly 0 or 1, use `rgbaQuantizedAlphaBinding(get:set:)` instead.
    public static func rgbaBinding(get: @escaping () -> RGBA, set: @escaping (Red, Green, Blue, Alpha) -> Void) -> Binding<Color> {
        Binding<Color> {
            // 1. Initialize an RGBA tuple from the binding's getter.
            let (r, g, b, a) = get()
            // 2. Create and return a Color from that tuple's values.
            let color = Color(red: r, green: g, blue: b, opacity: a)
            return color
        } set: { newColor in
            // 3. When the value of the property changes, set the components of the color to the components of its new value.
            let components = newColor.components
            set(components.red, components.green, components.blue, components.opacity)
        }
    }

    /// Creates a binding to a `Color` where alpha is quantized to 0 or 1 using rounding to nearest even.
    /// - Parameters:
    ///   - get: Closure returning current red, green, blue, and alpha components.
    ///   - set: Closure receiving new red, green, blue, and alpha components.
    /// - Returns: A `Binding<Color>` with the given color values.
    ///
    /// Useful for color properties that conceptually represent presence/absence using opacity.
    /// - Note: If a `Color`'s alpha component needs to be between 0 and 1, use `rgbaBinding(get:set:)` instead.
    public static func rgbaQuantizedAlphaBinding(get: @escaping () -> RGBA, set: @escaping (Red, Green, Blue, Alpha) -> Void) -> Binding<Color> {
        Binding<Color> {
            // 1. Initialize an RGBA tuple from the binding's getter.
            let (r, g, b, a) = get()
            // 2. Round the alpha value to the nearest whole number. For example, an alpha value of 0.75 becomes 0.8 which becomes 1, and 0.25 becomes 0.3 which becomes 0. The conversion to Int forces the rounded value to become a whole number.
            let quantizedA = Double(Int(a.rounded(.toNearestOrEven)))
            // 3. Create and return a Color from that tuple's values.
            let color = Color(red: r, green: g, blue: b, opacity: quantizedA)
            return color
        } set: { newColor in
            // 4. When the value of the property changes, set the components of the color to the components of its new value, again rounding the alpha value to the nearest whole number.
            let components = newColor.components
            let quantizedAlpha = Double(Int(components.opacity.rounded(.toNearestOrEven)))
            set(components.red, components.green, components.blue, quantizedAlpha)
        }
    }

}
