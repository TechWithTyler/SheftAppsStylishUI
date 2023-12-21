//
//  SAMButtonHighlightColor.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 4/22/22.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

#if os(macOS)
// This file only applies to SAMButton/SAMPopup colors. These UI elements are only available to macOS apps, so we wrap the entire file in a #if os(macOS) block.
import Foundation
import Cocoa

extension NSColor {

	// Returns a highlight color that matches that of standard NSButtons.
	func themeAwareButtonHighlightColor(theme: String) -> NSColor {
		if self == .gray {
			return withAlphaComponent(0.2)
		} else if theme == "Graphite" {
			return withAlphaComponent(0.75)
		} else if theme.contains("Dark") {
				return hueColorWithBrightnessAmount(amount: 1.25)
			} else {
				return hueColorWithBrightnessAmount(amount: 0.75)
		}
	}

	// Lightens or darkens self by amount.
	func hueColorWithBrightnessAmount(amount: CGFloat) -> NSColor {
		// These properties are set based on getHue(_:saturation:brightness:alpha:). As it's a method with inout arguments, changes to an argument's value will affect the original value that was passed as the argument.
		var hue         : CGFloat = 0
		var saturation  : CGFloat = 0
		var brightness  : CGFloat = 0
		var alpha       : CGFloat = 0
		guard let convertedColorSpaceSelf = self.usingColorSpace(.sRGB) else { fatalError("Failed to convert color space for \(self) while attempting to lighten/darken by \(amount).") }
		convertedColorSpaceSelf.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
		return NSColor(hue: hue, saturation: saturation, brightness: brightness * amount, alpha: alpha)
	}

}
#endif
