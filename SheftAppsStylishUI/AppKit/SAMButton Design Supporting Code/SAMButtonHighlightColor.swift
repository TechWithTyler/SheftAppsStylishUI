//
//  SAMButtonHighlightColor.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 4/22/22.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

#if os(macOS)
// This file only applies to SAMButton/SAMPopup colors. These UI elements are only available to macOS apps, so we wrap the entire file in a #if os(macOS) block.
import Foundation
import Cocoa

extension NSColor {

	// Returns a highlight color that matches that of standard NSButtons.
	func themeAwareButtonHighlightColor(theme: String) -> NSColor {
        if self == SAMButtonBorderableNormalHighlightColor {
            return withAlphaComponent(0.25)
		} else if theme.contains("Dark") {
				return hueColorWithBrightnessAmount(amount: 1.25)
			} else {
				return hueColorWithBrightnessAmount(amount: 0.75)
		}
	}

	// Lightens or darkens self by amount.
	func hueColorWithBrightnessAmount(amount: CGFloat) -> NSColor {
        // 1. Define the HSBA properties.
		// These properties are set based on getHue(_:saturation:brightness:alpha:). As it's a method with UnsafeSomethingPointer (in this case UnsafeMutablePointer) arguments, changes to an argument's value will affect the original value that was passed as the argument. "Unsafe" means it's accessing raw memory, which can cause issues if you're not careful.
		var hue       : CGFloat = 0
		var saturation: CGFloat = 0
		var brightness: CGFloat = 0
		var alpha     : CGFloat = 0
        // 2. Make sure we can convert self to the sRGB color space. If we can't, throw a fatal error.
		guard let sRGBSelf = self.usingColorSpace(.sRGB) else { fatalError("Failed to convert color space for \(self) while attempting to lighten/darken by \(amount).") }
        // 3. Pass the HSBA properties into the getHue(_:saturation:brightness:alpha:) method, which will update their values.
        // Use & when passing a value to an UnsafeSomethingPointer or inout parameter.
		sRGBSelf.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        // 4. Multiply brightness by amount to get the new brightness value.
        let newBrightness = brightness * amount
        // 5. Create and return a new NSColor object with the new values.
        let color = NSColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
        return color
	}

}
#endif
