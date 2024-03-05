//
//  ColorHexExtension.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 3/1/24.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

#if os(macOS)
import AppKit

public typealias CrossPlatformNativeColor = NSColor
#else

import UIKit

public typealias CrossPlatformNativeColor = UIColor
#endif

public extension CrossPlatformNativeColor {
    
    /// Creates a new `CrossPlatformNativeColor` with the given hexadecimal    `UInt64` and alpha value.
    convenience init(hexInt hex: UInt64, alpha: CGFloat = 1) {
        // The >> operator is called the bit shift right operator. and the & operator is called the bitwise AND operator.
        let r = CGFloat((hex >> 16) & 0xFF) / 255
        let g = CGFloat((hex >> 8) & 0xFF) / 255
        let b = CGFloat((hex >> 0) & 0xFF) / 255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    /// Creates a new `CrossPlatformNativeColor` with the given hexadecimal `String` and alpha value.
    ///
    /// `hexString` is converted to the corresponding `Int` value and passed to `init(hexInt:alpha:)`
    convenience init?(hexString hex: String, alpha: CGFloat = 1) {
        let hex = hex.cleanedForHex()
        let hexRegex = "[a-fA-F0-9]+"
        guard hex.conforms(to: hexRegex) else { return nil }
        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0
        guard scanner.scanHexInt64(&hexNumber) else { return nil }
        self.init(hexInt: hexNumber, alpha: alpha)
    }
    
}

public extension Color {
    
    /// Returns `self`'s hexadecimal `String` value.
    var hex: String? {
        // 1. Create variables and constants.
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alphaValue: CGFloat = 0
        let hexFormatString = "#%02lX%02lX%02lX%02lX"
        // 2. Convert Color to CrossPlatformNativeColor
        let crossPlatformColor = CrossPlatformNativeColor(self)
        #if os(macOS)
            .usingColorSpace(.deviceRGB)!
        #endif
        // 3. Extract the RGBA components from the color.
        crossPlatformColor.getRed(&red, green: &green, blue: &blue, alpha: &alphaValue)
        return String(format: hexFormatString,
                      lroundf(Float(red) * 255),
                      lroundf(Float(green) * 255),
                      lroundf(Float(blue) * 255),
                      lroundf(Float(alphaValue) * 255))
    }
    
    /// Creates a new `Color` with the given hexadecimal `UInt64` and alpha value.
    init(hexInt hex: UInt64, alpha: CGFloat = 1) {
        let color = CrossPlatformNativeColor(hexInt: hex, alpha: alpha)
        self.init(color)
    }
    
    /// Creates a new `Color` with the given hexadecimal `String` and alpha value.
    ///
    /// `hexString` is converted to the corresponding `Int` value and passed to `init(hexInt:alpha:)`
    init?(hexString hex: String, alpha: CGFloat = 1) {
        guard
            let color = CrossPlatformNativeColor(hexString: hex, alpha: alpha)
        else { return nil }
        self.init(color)
    }
    
}
