//
//  PickerToggleStyle.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/21/23.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import SwiftUI

// MARK: - Toggle Style

/// A `ToggleStyle` that renders as a `Picker` with the given `PickerStyle`.
///
/// - Important: `PalettePickerStyle` isn't supported as its labels can only be `Image`. Attempting to use it will result in a runtime error.
public struct PickerToggleStyle<P: PickerStyle>: ToggleStyle {
    
    /// A pair of opposing words to use as the title of a picker toggle's on state and off state options (e.g., "On" and "Off").
    public enum LabelPair {
        
        /// A label pair that uses "On" for the on state item and "Off" for the off state item.
        case onOff
        
        /// A label pair that uses "Yes" for the on state item and "No" for the off state item.
        case yesNo
        
        /// A label pair that uses `onState` for the on state item and `offState` for the off state item.
        case custom(onState: String, offState: String)

        /// The label to use for a picker's on state item.
        var onLabel: String {
            switch self {
            case .onOff:
                return "On"
            case .yesNo:
                return "Yes"
            case .custom(let onState, _):
                return onState
            }
        }

        /// The label to use for a picker's off state item.
        var offLabel: String {
            switch self {
            case .onOff:
                return "Off"
            case .yesNo:
                return "No"
            case .custom(_, let offLabel):
                return offLabel
            }
        }
        
    }
    
    /// The pair of opposing words to use as the title of the picker's on state and off state options (e.g., "On" and "Off").
    var labelPair: LabelPair
    
    /// The style of the picker.
    var style: P
    
    /// Creates a new `PickerToggleStyle` with the given picker style and on/off state words.
    public init(style: P = .automatic, labelPair: LabelPair = .onOff) {
        if #available(macOS 14, iOS 17, visionOS 1, *) {
            if style is PalettePickerStyle {
                fatalError("Palette picker style can't be used as a toggle style.")
            }
        }
        self.labelPair = labelPair
        self.style = style
    }
    
    @ViewBuilder
    public func makeBody(configuration: Configuration) -> some View {
        Picker(selection: configuration.$isOn) {
            Text(labelPair.onLabel).tag(true)
            Text(labelPair.offLabel).tag(false)
        } label: {
            if style is DefaultPickerStyle || style is MenuPickerStyle {
                configuration.label
            } else {
                configuration.label
                .accessibilityAction {
                    configuration.isOn.toggle()
                }
            }
        }
        .pickerStyle(style)
    }
    
}

// MARK: - ToggleStyle Extension - Default Picker

public extension ToggleStyle where Self == PickerToggleStyle<DefaultPickerStyle> {
    
    /// A toggle style that renders as a context-dependent picker.
    static func automaticPicker(labelPair: PickerToggleStyle<DefaultPickerStyle>.LabelPair = .onOff) -> PickerToggleStyle<DefaultPickerStyle> {
        return PickerToggleStyle(style: .automatic, labelPair: labelPair)
    }
    
}

// MARK: - ToggleStyle Extension - Menu Picker

public extension ToggleStyle where Self == PickerToggleStyle<MenuPickerStyle> {
    
    /// A toggle style that renders as a menu.
    static func menu(labelPair: PickerToggleStyle<MenuPickerStyle>.LabelPair = .onOff) -> PickerToggleStyle<MenuPickerStyle> {
        return PickerToggleStyle(style: .menu, labelPair: labelPair)
    }
    
}

// MARK: - ToggleStyle Extension - Segmented Picker

public extension ToggleStyle where Self == PickerToggleStyle<SegmentedPickerStyle> {
    
    /// A toggle style that renders as a segmented picker.
    static func segmented(labelPair: PickerToggleStyle<SegmentedPickerStyle>.LabelPair = .onOff) -> PickerToggleStyle<SegmentedPickerStyle> {
        return PickerToggleStyle(style: .segmented, labelPair: labelPair)
    }
    
}

// MARK: - ToggleStyle Extension - Inline Picker

public extension ToggleStyle where Self == PickerToggleStyle<InlinePickerStyle> {
    
    /// A toggle style that renders as an inline picker.
    static func inlinePicker(labelPair: PickerToggleStyle<InlinePickerStyle>.LabelPair = .onOff) -> PickerToggleStyle<InlinePickerStyle> {
        return PickerToggleStyle(style: .inline, labelPair: labelPair)
    }
    
}

// MARK: - ToggleStyle Extension - Navigation Link Picker

#if !os(macOS)
@available(iOS 16, tvOS 16, watchOS 9, visionOS 1, *)
public extension ToggleStyle where Self == PickerToggleStyle<NavigationLinkPickerStyle> {
    
    /// A toggle style that renders as a navigation link picker.
    static func navigationLink(labelPair: PickerToggleStyle<NavigationLinkPickerStyle>.LabelPair = .onOff) -> PickerToggleStyle<NavigationLinkPickerStyle> {
        return PickerToggleStyle(style: .navigationLink, labelPair: labelPair)
    }
    
}

// MARK: - ToggleStyle Extension - Wheel Picker

public extension ToggleStyle where Self == PickerToggleStyle<WheelPickerStyle> {
    
    /// A toggle style that renders as a wheel picker.
    static func wheel(labelPair: PickerToggleStyle<WheelPickerStyle>.LabelPair = .onOff) -> PickerToggleStyle<WheelPickerStyle> {
        return PickerToggleStyle(style: .wheel, labelPair: labelPair)
    }
    
}
#else

// MARK: - ToggleStyle Extension - Radio Group Picker

public extension ToggleStyle where Self == PickerToggleStyle<RadioGroupPickerStyle> {
    
    /// A toggle style that renders as a radio group.
    static func radioGroup(labelPair: PickerToggleStyle<RadioGroupPickerStyle>.LabelPair = .onOff) -> PickerToggleStyle<RadioGroupPickerStyle> {
        return PickerToggleStyle(style: .radioGroup, labelPair: labelPair)
    }
    
}
#endif

#Preview("Automatic Picker") {
    @State var on: Bool = false
    return Toggle("Toggle", isOn: $on)
        .toggleStyle(.automaticPicker(labelPair: .onOff))
}

#Preview("Menu Picker") {
    @State var on: Bool = false
    return Toggle("Toggle", isOn: $on)
        .toggleStyle(.menu(labelPair: .onOff))
}

#Preview("Inline Picker") {
    @State var on: Bool = false
    return Toggle("Toggle", isOn: $on)
        .toggleStyle(.inlinePicker(labelPair: .onOff))
}

#Preview("Segmented Picker") {
    @State var on: Bool = false
    return Toggle("Toggle", isOn: $on)
        .toggleStyle(.segmented(labelPair: .onOff))
}

#if !os(macOS)
@available(iOS 16, tvOS 16, watchOS 9, visionOS 1, *)
#Preview("Navigation Link Picker") {
    @State var on: Bool = false
    return NavigationStack {
        List {
            Toggle("Toggle", isOn: $on)
                .toggleStyle(.navigationLink(labelPair: .onOff))
        }
    }
}

#Preview("Wheel Picker") {
    @State var on: Bool = false
    return Toggle("Toggle", isOn: $on)
        .toggleStyle(.wheel(labelPair: .onOff))
}
#else
#Preview("Radio Group Picker") {
    @State var on: Bool = false
    return Toggle("Toggle", isOn: $on)
        .toggleStyle(.radioGroup(labelPair: .onOff))
}
#endif
