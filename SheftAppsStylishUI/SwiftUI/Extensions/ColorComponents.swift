//
//  ColorComponents.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/22/23.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

import Foundation

/// Adds a property to get a `Color`'s red, green, blue, and opacity (alpha) components. This is useful when needing to convert a `Color` to/from `Double` values stored in persistent data (e.g. UserDefaults, Core Data, SwiftData).
extension Color: @retroactive Identifiable {

    // MARK: - Color Components Struct
    
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

        /// Creates a new `Components` instance from the components of `color`.
        public init(fromColor color: Color) {
            // 1. Create a resolved version of the color to get its componenets.
            let resolved = color.resolve(in: EnvironmentValues())
            // 2. Set the components to these resolved values.
            self.red = Double(resolved.red)
            self.green = Double(resolved.green)
            self.blue = Double(resolved.blue)
            self.opacity = Double(resolved.opacity)
        }

    }

    // MARK: - Properties - Doubles

    /// The ID of the color, which is the sum of all its component values.
    public var id: Double {
        let sumOfAllComponents = components.red + components.green + components.blue + components.opacity
        return sumOfAllComponents
    }

    // MARK: - Properties - Color Components

    /// The red, green, blue, and opacity (alpha) components of the color. Use `components.red`, `components.green`, `components.blue`, and `components.opacity` to get the desired color components.
    public var components: Components {
        return Components(fromColor: self)
    }

    // MARK: - Binding Helper Functions

    /// Creates a binding to a `Color` backed by 3 `Double` components (red, green, blue).
    /// - Parameters:
    ///   - get: Closure returning current (r, g, b) components.
    ///   - set: Closure receiving new (r, g, b) components.
    /// - Returns: A `Binding<Color>` with the given color values.
    public static func rgbBinding(get: @escaping () -> (Double, Double, Double), set: @escaping (Double, Double, Double) -> Void) -> Binding<Color> {
        Binding<Color> {
            let (r, g, b) = get()
            return Color(red: r, green: g, blue: b)
        } set: { newColor in
            let components = newColor.components
            set(components.red, components.green, components.blue)
        }
    }

    /// Creates a binding to a `Color` backed by RGBA where alpha is stored as a `Double` from 0.0 to 1.0.
    /// - Parameters:
    ///   - get: Closure returning current (r, g, b, a) components.
    ///   - set: Closure receiving new (r, g, b, a) components.
    /// - Returns: A `Binding<Color>` with the given color values.
    public static func rgbaBinding(get: @escaping () -> (Double, Double, Double, Double), set: @escaping (Double, Double, Double, Double) -> Void) -> Binding<Color> {
        Binding<Color> {
            let (r, g, b, a) = get()
            return Color(red: r, green: g, blue: b, opacity: a)
        } set: { newColor in
            let components = newColor.components
            set(components.red, components.green, components.blue, components.opacity)
        }
    }

    /// Creates a binding to a Color where alpha is quantized to 0 or 1 using rounding to nearest even.
    /// Useful for properties that conceptually represent presence/absence using opacity.
    public static func rgbaQuantizedAlphaBinding(get: @escaping () -> (Double, Double, Double, Double), set: @escaping (Double, Double, Double, Double) -> Void) -> Binding<Color> {
        Binding<Color> {
            let (r, g, b, a) = get()
            return Color(red: r, green: g, blue: b, opacity: Double(Int(a.rounded(.toNearestOrEven))))
        } set: { newColor in
            let components = newColor.components
            let quantizedA = Double(Int(components.opacity.rounded(.toNearestOrEven)))
            set(components.red, components.green, components.blue, quantizedA)
        }
    }

}
