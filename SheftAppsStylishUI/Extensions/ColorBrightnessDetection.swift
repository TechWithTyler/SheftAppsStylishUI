//
//  ColorBrightnessDetection.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 4/9/26.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

#if os(macOS)

import Cocoa

public extension NSColor {

    /// Whether the color is dark.
    var isDark: Bool {
        // 1. Define the color components.
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        // 2. Get the color components using the RGB color space.
        usingColorSpace(.deviceRGB)?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        // 3. Determine the luminance using a standard luminance formula
        let luminance = (0.299 * red + 0.587 * green + 0.114 * blue)
        // 4. Return whether the color is dark by checking if luminance is less than 0.5.
        return luminance < 0.5
    }

}
#else

import UIKit

public extension UIColor {

    /// Whether the color is dark.
    var isDark: Bool {
        // 1. Define the color components.
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        // 2. Get the color components.
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        // 3. Determine the luminance using a standard luminance formula.
        let luminance = (0.299 * red + 0.587 * green + 0.114 * blue)
        // 4. Return whether the color is dark by checking if luminance is less than 0.5.
        return luminance < 0.5
    }

}
#endif
