//
//  Globals.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 3/9/22.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import Foundation

// MARK: - Properties - Strings

/// A string that can be used to preview font/text settings in SheftApps apps.
public let SATextSettingsPreviewString: String = "The quick brown fox jumps over the lazy dog."

/// The identifier of the default voice, Samantha (formerly Samantha Compact), which is a voice that can't be deleted from the device.
public let SADefaultVoiceID = "com.apple.voice.compact.en-US.Samantha"

/// The key equivalent string for the return key.
public let SAReturnKeyEquivalentString: String = "\r"

/// The key equivalent string for the delete key.
public let SADeleteKeyEquivalentString: String = "\u{232B}"

/// The key equivalent string for the escape key.
public let SAEscapeKeyEquivalentString: String = "\u{1B}"

/// The name of the running app.
///
/// This variable returns the name of the bundle from which it's accessed, not SheftAppsStylishUI itself.
public var SAAppName: String {
    guard let appName = (Bundle.main.infoDictionary?[String(kCFBundleNameKey)] as? String) else {
        fatalError("Couldn't get the name of the running app.")
    }
    return appName
}

// MARK: - Properties - Doubles

/// The minimum font size for size-adjustable text in SheftApps apps.
public let SATextViewMinFontSize: Double = 14

/// The maximum font size for size-adjustable text in SheftApps apps.
public let SATextViewMaxFontSize: Double = 48

/// The range of font sizes for size-adjustable text in SheftApps apps.
public let SATextViewFontSizeRange: ClosedRange<Double> = SATextViewMinFontSize...SATextViewMaxFontSize

// MARK: - Properties - Floats

/// The corner radius for Liquid Glass panels in SheftApps apps.
public let SALiquidGlassPanelCornerRadius: CGFloat = 16

/// The padding amount for Liquid Glass panels in SheftApps apps.
public let SALiquidGlassPanelPaddingAmount: CGFloat = 8

/// The corner radius for text views in SheftApps apps.
public let SATextViewCornerRadius: CGFloat = 5

/// The corner radius for buttons in SheftApps apps.
public let SAButtonCornerRadius: CGFloat = 8

/// The corner radius for container views in SheftApps apps.
public let SAContainerViewCornerRadius: CGFloat = 5

/// A corner radius value that creates a circle (no corners) used for image views which display a person's photo in SheftApps apps.
public let SAPersonPhotoViewCornerRadius: CGFloat = 360

// MARK: - Properties - Booleans

/// Whether this app is a SheftApps app.
///
/// If the code checking the value of this computed variable belongs to a SheftApps app, it will return `true`.
var isSheftAppsApp: Bool {
    let copyrightOwner = "SheftApps"
    let appBundleCopyrightKey = "NSHumanReadableCopyright"
    return ((Bundle.main.infoDictionary?[appBundleCopyrightKey] as? String)?.contains(copyrightOwner))!
}

/// The help URL for the given app name.
///
/// Use this variable if the app's help content resides on techwithtyler20.weebly.com.
///
/// - Returns: A `URL` pointing to an app's help page. For example, for RandoFacto, the returned URL is "https://techwithtyler20.weebly.com/randofactohelp"
/// - Important: Attempting to access this variable from a non-SheftApps app will result in a runtime error.
public var SAAppHelpURL: URL {
    guard isSheftAppsApp else {
        fatalError("This help URL function is only designed for use in SheftApps apps.")
    }
    let appName = SAAppName
    guard let url = URL(string: "https://techwithtyler20.weebly.com/\((appName.lowercased()))help") else {
        fatalError("Failed to create help URL for \(appName).")
    }
    return url
}
