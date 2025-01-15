//
//  TextSizeSlider.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 8/13/24.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

import SwiftUI

/// A `Slider` designed for adjusting text size.
@available(tvOS, unavailable)
public struct TextSizeSlider: View {

    // MARK: - Properties - Strings

    var labelText: String

    var previewText: String?

    var textSizeSliderText: String {
        return "\(labelText): \(textSizeAsInt)pt"
    }

    // MARK: - Properties - Doubles

    @Binding var textSize: Double

    // MARK: - Properties - Integers

    var textSizeAsInt: Int {
        return Int(textSize)
    }

    // MARK: - Initialization

    /// Creates a new `TextSizeSlider` with the given label text `String`, text size `Double` binding, and optional preview text `String`.
    /// - Parameters:
    ///   - labelText: The text to display as the label for the slider.
    ///   - textSize: The text size `Double` to adjust.
    ///   - previewText: An optional `String` to display below the slider to preview the result.
    public init(labelText: String = "Text Size", textSize: Binding<Double>, previewText: String? = nil) {
        self.labelText = labelText
        self._textSize = textSize
        self.previewText = previewText
    }

    // MARK: - Body

    public var body: some View {
        Group {
#if os(macOS)
            // Sliders show their labels by default on macOS.
            textSizeSlider
#else
            VStack(spacing: 0) {
                Text(textSizeSliderText)
                    .padding(5)
                textSizeSlider
            }
#endif
            if let previewText = previewText {
                Text(previewText)
                    .font(.system(size: CGFloat(textSize)))
                    .animation(.default, value: textSize)
            }
        }
    }

    // MARK: - Slider

    @ViewBuilder
    var textSizeSlider: some View {
        Slider(value: $textSize, in: SATextViewFontSizeRange, step: 1) {
            Text(textSizeSliderText)
        } minimumValueLabel: {
            Image(systemName: "textformat.size.smaller")
                .accessibilityLabel("Smaller")
        } maximumValueLabel: {
            Image(systemName: "textformat.size.larger")
                .accessibilityLabel("Larger")
        }
        .accessibilityValue("\(textSizeAsInt)")
    }

}

// MARK: - Preview

#if !os(tvOS)
#Preview("Without Preview Text") {
    TextSizeSlider(labelText: "Text Size", textSize: .constant(SATextViewMinFontSize))
}

#Preview("With Preview Text") {
    TextSizeSlider(labelText: "Text Size", textSize: .constant(SATextViewMinFontSize), previewText: SATextSettingsPreviewString)
}
#endif
