//
//  Globals.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 3/9/22.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import Foundation

// MARK: - Properties - Strings

/// A string that can be used to preview font/text settings in SheftApps apps.
public let SATextSettingsPreviewString: String = "The quick brown fox jumps over the lazy dog."

/// The key equivalent string for the return key.
public let SAReturnKeyEquivalentString: String = "\r"

/// The key equivalent string for the delete key.
public let SADeleteKeyEquivalentString: String = "\u{232B}"

/// The key equivalent string for the escape key.
public let SAEscapeKeyEquivalentString: String = "\u{1B}"

// MARK: - Properties - Doubles

/// The minimum font size for text in SheftApps apps.
public let SATextViewMinFontSize: Double = 14

/// The maximum font size for text in SheftApps apps.
public let SATextViewMaxFontSize: Double = 48

/// The range of font sizes for text in SheftApps apps.
public let SATextViewFontSizeRange: ClosedRange<Double> = SATextViewMinFontSize...SATextViewMaxFontSize

// MARK: - Properties - Floats

/// The corner radius for text views in SheftApps apps.
public let SATextViewCornerRadius: CGFloat = 5

/// The corner radius for buttons in SheftApps apps.
public let SAButtonCornerRadius: CGFloat = 5

/// The corner radius for container views in SheftApps apps.
public let SAContainerViewCornerRadius: CGFloat = 5

/// A corner radius value that creates a circle (no corners) used for image views which display a person's photo in SheftApps apps.
public let SAPersonPhotoViewCornerRadius: CGFloat = 360
