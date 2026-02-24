//
//  ColorComponents.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/22/23.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import Foundation

/// Adds initializers for creating `Color`s from RGB and RGBA values, as well as methods and properties for getting a `Color`'s red, green, blue, and alpha (opacity) components and working with `Color` bindings. This is useful when needing to convert a `Color` to/from `Double` values stored in persistent data (e.g. UserDefaults, Core Data, SwiftData).
extension Color {

    // MARK: - Type Aliases

    /// A 3-`Double` tuple represented as RGB.
    ///
    /// Use the `red`, `green`, and `blue` properties to get the respective components.
    public typealias RGB = (red: Double, green: Double, blue: Double)

    /// A 4-`Double` tuple represented as RGBA.
    ///
    /// Use the `red`, `green`, `blue`, and `alpha` properties to get the respective components.
    public typealias RGBA = (red: Double, green: Double, blue: Double, alpha: Double)

    // MARK: - Color Components Struct
    
    /// The red, green, blue, and opacity (alpha) components of a `Color`.
    public struct Components {

        /// The red component of the color.
        public let red: Double

        /// The green component of the color.
        public let green: Double

        /// The blue component of the color.
        public let blue: Double

        /// The alpha component of the color.
        public let alpha: Double

        /// Creates a new `Components` instance from the components of `color`.
        public init(fromColor color: Color) {
            // 1. Create a resolved version of the color to get its components.
            let resolved = color.resolve(in: EnvironmentValues())
            // 2. Set the componDoubleents to these resolved values.
            self.red = Double(resolved.red)
            self.green = Double(resolved.green)
            self.blue = Double(resolved.blue)
            self.alpha = Double(resolved.opacity)
        }

        /// Returns the components of a `Color` as an `RGB` tuple.
        ///
        /// Use the `red`, `green`, and `blue` properties to get the respective components.
        public func asRGB() -> RGB {
            let rgb = RGB(red: red, green: green, blue: blue)
            return rgb
        }

        /// Returns the components of a `Color` as an `RGBA` tuple.
        ///
        /// Use the `red`, `green`, `blue`, and `alpha` properties to get the respective components.
        public func asRGBA() -> RGBA {
            let rgba = RGBA(red: red, green: green, blue: blue, alpha: alpha)
            return rgba
        }

    }

    // MARK: - Properties - Color Components

    /// The red, green, blue, and alpha components of the color. Use `components.red`, `components.green`, `components.blue`, and `components.alpha` to get the desired color components, or use `asRGB()` or `asRGBA()` to get the components as an `RGB` or `RGBA` value..
    public var components: Components {
        return Components(fromColor: self)
    }

    // MARK: - RGB/RGBA Initializers

    /// Creates a new `Color` with the given `RGB` tuple.
    ///
    /// If you have an existing `RGBA` object you want to create a `Color` from, this initializer makes it simpler so you don't have to pass each component into the standard red/green/blue/opacity initializer. However, the standard initializer is preferred if you're creating a `Color` using color values directly.
    init(rgb: RGB) {
        self.init(red: rgb.red, green: rgb.green, blue: rgb.blue)
    }

    /// Creates a new `Color` with the given `RGBA` tuple.
    ///
    /// If you have an existing `RGB` object you want to create a `Color` from, this initializer makes it simpler so you don't have to pass each component into the standard red/green/blue initializer. However, the standard initializer is preferred if you're creating a `Color` using color values directly.
    init(rgba: RGBA) {
        self.init(red: rgba.red, green: rgba.green, blue: rgba.blue, opacity: rgba.alpha)
    }

    // MARK: - Binding Helper Methods

    /// Creates a binding to a `Color` backed by 3 `Double` components (red, green, and blue values).
    /// - Parameters:
    ///   - get: Closure returning current red, green, and blue components as an `RGB` object.
    ///   - set: Closure receiving new `RGB` object with the given red, green, and blue components.
    /// - Returns: A `Binding<Color>` with the given color values.
    /// - Note: If a `Color` needs to have an alpha component, use `rgbaBinding(get:set:)` or `rgbaQuantizedAlphaBinding(get:set:)` instead.
    public static func rgbBinding(get: @escaping () -> RGB, set: @escaping (RGB) -> Void) -> Binding<Color> {
        // A binding is a get-only property that runs code when its value is changed by setting the property that's passed as its value.
        Binding<Color> {
            // 1. Initialize an RGB tuple from the binding's getter.
            let rgb = get()
            // 2. Create and return a Color from that tuple's values.
            let color = Color(rgb: rgb)
            return color
        } set: { newColor in
            // 3. When the value of the property changes, set the components of the color to the components of its new value.
            let components = newColor.components
            let rgb = components.asRGB()
            set(rgb)
        }
    }

    /// Creates a binding to a `Color` backed by RGBA where alpha is stored as a `Double` from 0.0 to 1.0.
    /// - Parameters:
    ///   - get: Closure returning current red, green, blue, and alpha components as an `RGBA` object.
    ///   - set: Closure receiving new `RGBA` object with the given red, green, blue, and alpha components.
    /// - Returns: A `Binding<Color>` with the given color values.
    /// - Note: If a `Color`'s alpha component needs to be exactly 0 or 1, use `rgbaQuantizedAlphaBinding(get:set:)` instead.
    public static func rgbaBinding(get: @escaping () -> RGBA, set: @escaping (RGBA) -> Void) -> Binding<Color> {
        Binding<Color> {
            // 1. Initialize an RGBA tuple from the binding's getter.
            let rgba = get()
            // 2. Create and return a Color from that tuple's values.
            let color = Color(rgba: rgba)
            return color
        } set: { newColor in
            // 3. When the value of the property changes, set the components of the color to the components of its new value.
            let components = newColor.components
            let rgba = RGBA(components.red, components.green, components.blue, components.alpha)
            set(rgba)
        }
    }

    /// Creates a binding to a `Color` where alpha is quantized to 0 or 1 using rounding to nearest even.
    /// - Parameters:
    ///   - get: Closure returning current red, green, blue, and alpha components as an `RGBA` object.
    ///   - set: Closure receiving new `RGBA` object with the given red, green, blue, and alpha components.
    /// - Returns: A `Binding<Color>` with the given color values.
    ///
    /// Useful for color properties that conceptually represent presence/absence using opacity. For example, Phonepedia uses an alpha value of 0 to indicate that a phone doesn't have a corded receiver.
    /// - Note: If a `Color`'s alpha component needs to be between 0 and 1, use `rgbaBinding(get:set:)` instead.
    public static func rgbaQuantizedAlphaBinding(get: @escaping () -> RGBA, set: @escaping (RGBA) -> Void) -> Binding<Color> {
        Binding<Color> {
            // 1. Initialize an RGBA tuple from the binding's getter.
            let rgba = get()
            // 2. Round the alpha value to the nearest whole number. For example, an alpha value of 0.75 becomes 0.8 which becomes 1, and 0.25 becomes 0.3 which becomes 0. The conversion to Int forces the rounded value to become a whole number.
            let quantizedA = Double(Int(rgba.alpha.rounded(.toNearestOrEven)))
            let rgbQuantizedA = RGBA(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: quantizedA)
            // 3. Create and return a Color from that tuple's values.
            let color = Color(rgba: rgbQuantizedA)
            return color
        } set: { newColor in
            // 4. When the value of the property changes, set the components of the color to the components of its new value, again rounding the alpha value to the nearest whole number.
            let components = newColor.components
            let quantizedAlpha = Double(Int(components.alpha.rounded(.toNearestOrEven)))
            let rgbQuantizedA = RGBA(components.red, components.green, components.blue, quantizedAlpha)
            set(rgbQuantizedA)
        }
    }

}
