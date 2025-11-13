//
//  ColorComponents.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/22/23.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

// MARK: - Imports

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

// MARK: - Color Manipulation Protocols

/// Protocol for types that store colors as separate RGB component properties and need basic color manipulation helpers.
public protocol BaseColorManipulatable {
    // Required: The color component storage properties
    var mainColorRed: Double { get set }
    var mainColorGreen: Double { get set }
    var mainColorBlue: Double { get set }
    var secondaryColorRed: Double { get set }
    var secondaryColorGreen: Double { get set }
    var secondaryColorBlue: Double { get set }
    var accentColorRed: Double { get set }
    var accentColorGreen: Double { get set }
    var accentColorBlue: Double { get set }
    
    // Required: The color bindings (using Color.rgbBinding from this file)
    var mainColorBinding: Binding<Color> { get }
    var secondaryColorBinding: Binding<Color> { get }
    var accentColorBinding: Binding<Color> { get }
}

public extension BaseColorManipulatable {
    
    /// Copies the main color components to the secondary color.
    func setSecondaryColorToMain() {
        let components = mainColorBinding.wrappedValue.components
        secondaryColorRed = components.red
        secondaryColorGreen = components.green
        secondaryColorBlue = components.blue
    }
    
    /// Copies the main color components to the accent color.
    func setAccentColorToMain() {
        let components = mainColorBinding.wrappedValue.components
        accentColorRed = components.red
        accentColorGreen = components.green
        accentColorBlue = components.blue
    }
    
    /// Copies the secondary color components to the accent color.
    func setAccentColorToSecondary() {
        let components = secondaryColorBinding.wrappedValue.components
        accentColorRed = components.red
        accentColorGreen = components.green
        accentColorBlue = components.blue
    }
    
}

/// Protocol for types that have charge light colors and need manipulation helpers.
public protocol ChargeLightColorManipulatable {
    // Required: Charge light color component storage properties
    var chargeLightColorChargingRed: Double { get set }
    var chargeLightColorChargingGreen: Double { get set }
    var chargeLightColorChargingBlue: Double { get set }
    var chargeLightColorChargedRed: Double { get set }
    var chargeLightColorChargedGreen: Double { get set }
    var chargeLightColorChargedBlue: Double { get set }
    var chargeLightColorChargedAlpha: Double { get set }
    
    // Required: The charging color binding
    var chargeLightColorChargingBinding: Binding<Color> { get }
}

public extension ChargeLightColorManipulatable {
    
    /// Copies the charging color components to the charged color and sets alpha to 1.
    func setChargeLightChargedColorToCharging() {
        let components = chargeLightColorChargingBinding.wrappedValue.components
        chargeLightColorChargedRed = components.red
        chargeLightColorChargedGreen = components.green
        chargeLightColorChargedBlue = components.blue
        chargeLightColorChargedAlpha = 1
    }
    
}

/// Protocol for types that have corded receiver colors and need manipulation helpers.
public protocol CordedReceiverColorManipulatable {
    // Required: Corded receiver color component storage properties
    var cordedReceiverMainColorRed: Double { get set }
    var cordedReceiverMainColorGreen: Double { get set }
    var cordedReceiverMainColorBlue: Double { get set }
    var cordedReceiverSecondaryColorRed: Double { get set }
    var cordedReceiverSecondaryColorGreen: Double { get set }
    var cordedReceiverSecondaryColorBlue: Double { get set }
    var cordedReceiverAccentColorRed: Double { get set }
    var cordedReceiverAccentColorGreen: Double { get set }
    var cordedReceiverAccentColorBlue: Double { get set }
    
    // Required: The corded receiver color bindings
    var cordedReceiverMainColorBinding: Binding<Color> { get }
    var cordedReceiverSecondaryColorBinding: Binding<Color> { get }
}

public extension CordedReceiverColorManipulatable {
    
    /// Copies the corded receiver main color components to the secondary color.
    func setCordedReceiverSecondaryColorToMain() {
        let components = cordedReceiverMainColorBinding.wrappedValue.components
        cordedReceiverSecondaryColorRed = components.red
        cordedReceiverSecondaryColorGreen = components.green
        cordedReceiverSecondaryColorBlue = components.blue
    }
    
    /// Copies the corded receiver main color components to the accent color.
    func setCordedReceiverAccentColorToMain() {
        let components = cordedReceiverMainColorBinding.wrappedValue.components
        cordedReceiverAccentColorRed = components.red
        cordedReceiverAccentColorGreen = components.green
        cordedReceiverAccentColorBlue = components.blue
    }
    
    /// Copies the corded receiver secondary color components to the accent color.
    func setCordedReceiverAccentColorToSecondary() {
        let components = cordedReceiverSecondaryColorBinding.wrappedValue.components
        cordedReceiverAccentColorRed = components.red
        cordedReceiverAccentColorGreen = components.green
        cordedReceiverAccentColorBlue = components.blue
    }
    
}

/// Protocol for types that have key foreground/background colors and need to swap them.
public protocol KeyColorManipulatable {
    // Required: Key color component storage properties
    var keyBackgroundColorRed: Double { get set }
    var keyBackgroundColorGreen: Double { get set }
    var keyBackgroundColorBlue: Double { get set }
    var keyForegroundColorRed: Double { get set }
    var keyForegroundColorGreen: Double { get set }
    var keyForegroundColorBlue: Double { get set }
}

public extension KeyColorManipulatable {
    
    /// Swaps the key background and foreground color components.
    func swapKeyBackgroundAndForegroundColors() {
        let previousBackgroundRed = keyBackgroundColorRed
        let previousBackgroundGreen = keyBackgroundColorGreen
        let previousBackgroundBlue = keyBackgroundColorBlue
        keyBackgroundColorRed = keyForegroundColorRed
        keyBackgroundColorGreen = keyForegroundColorGreen
        keyBackgroundColorBlue = keyForegroundColorBlue
        keyForegroundColorRed = previousBackgroundRed
        keyForegroundColorGreen = previousBackgroundGreen
        keyForegroundColorBlue = previousBackgroundBlue
    }
    
}
