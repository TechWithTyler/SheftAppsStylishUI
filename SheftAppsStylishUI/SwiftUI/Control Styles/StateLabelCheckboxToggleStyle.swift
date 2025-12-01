//
//  StateLabelCheckboxToggleStyle.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/17/24.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import SwiftUI

/// A toggle style that renders as a rectangular or circular checkbox and shows a label indicating the current state (e.g., "On" or "Off").
@available(tvOS, unavailable)
public struct StateLabelCheckboxToggleStyle: ToggleStyle {

    // MARK: - Enums - State Label Pair

    /// A pair of opposing words to use as the state label for a `Toggle` with the `StateLabelCheckboxToggleStyle`.
    ///
    /// The width of the checkbox is determined by the longest of the 2 state labels (often the off state label), so shorter labels are recommended for a better appearance.
    public enum StateLabelPair {
        
        /// The checkbox's state label shows "On" in the on state and 'Off" in the off state.
        case onOff
        
        /// The checkbox's state label shows "Yes" in the on state and 'No" in the off state.
        case yesNo

        /// The checkbox's state label shows "Enabled" in the on state and 'Disabled" in the off state.
        case enabledDisabled

        /// The checkbox's state label shows "Allowed" in the on state and 'Disallowed" in the off state.
        case allowedDisallowed

        /// The checkbox's state label shows "Blocked" in the on state and 'Unblocked" in the off state.
        case blockedUnblocked

        /// The checkbox's state label shows `onLabel` in the on state and `offLabel` in the off state.
        ///
        /// - Note: While the width of the checkbox is determined by the longest of the 2 state labels, shorter labels are recommended.
        case custom(onLabel: String, offLabel: String)
        
        /// The checkbox's on state label.
        var onLabel: String {
            switch self {
            case .onOff:
                return "On"
            case .yesNo:
                return "Yes"
            case .enabledDisabled:
                return "Enabled"
            case .allowedDisallowed:
                return "Allowed"
            case .blockedUnblocked:
                return "Blocked"
            case .custom(let onLabel, _):
                return onLabel
            }
        }
        
        /// The checkbox's off state label.
        var offLabel: String {
            switch self {
            case .onOff:
                return "Off"
            case .yesNo:
                return "No"
            case .enabledDisabled:
                return "Disabled"
            case .allowedDisallowed:
                return "Disallowed"
            case .blockedUnblocked:
                return "Unblocked"
            case .custom(_, let offLabel):
                return offLabel
            }
        }
        
    }

    // MARK: - Enums - Checkbox Shape

    /// Possible shapes for a `Toggle` with the `StateLabelCheckboxToggleStyle`.
    public enum CheckboxShape: String {

        /// The checkbox has a rounded square shape.
        case square

        /// The checkbox has a rounded rectangle shape.
        case rectangle
        
        /// The checkbox has a circular shape.
        case circle

        /// The checkbox has a shield shape.
        case shield

    }

    // MARK: - Properties - Booleans

    @State var pressed: Bool = false

    let fill: Bool

    // MARK: - Properties - State Label Pair

    let stateLabelPair: StateLabelPair

    // MARK: - Properties - Checkbox Shape

    let shape: CheckboxShape

    // MARK: - Properties - Floats

    var fittingWidth: CGFloat {
        // 1. Calculate the width needed to fit the state label based on the character count of the longest label. In some cases, the off state label is longer than the on state label, so we use the maximum of the two.
        let longestLabelCount = max(stateLabelPair.onLabel.count, stateLabelPair.offLabel.count)
        let width = CGFloat(longestLabelCount) * 10 // Assuming an average character width of 10 points.
        // 2. Return the width.
        return width
    }

    // MARK: - Initialization

    /// Creates a new `StateLabelCheckboxToggleStyle` with the given pair of opposing state words, shape, and Boolean indicating whether the checkbox has a background fill.
    @available(visionOS, unavailable)
    public init(stateLabelPair: StateLabelPair, shape: CheckboxShape = .rectangle, fill: Bool = true) {
        self.stateLabelPair = stateLabelPair
        self.shape = shape
        self.fill = fill
    }
    
    /// Creates a new `StateLabelCheckboxToggleStyle` with the given pair of opposing state words, a circular shape, and Boolean indicating whether the checkbox has a background fill.
    @available(visionOS 1, *)
    @available(macOS, unavailable)
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public init(stateLabelPair: StateLabelPair, fill: Bool = true) {
        self.stateLabelPair = stateLabelPair
        self.shape = .circle
        self.fill = fill
    }

    // MARK: - Body

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            VStack {
                Image(systemName: configuration.isOn ? "checkmark.\(shape)\(fill ? ".fill" : String())" : "\(shape)\(fill ? ".fill" : String())")
                    .symbolRenderingMode(.hierarchical)
                    .animatedSymbolReplacement()
                    .foregroundStyle((configuration.isOn ? Color.accentColor : .gray.opacity(0.3))
                        .opacity(pressed ? 0.5 : 1), Color.white, Color.accentColor)
                    .font(.system(size: 24))
                    .focusable(interactions: .activate)
                #if !os(watchOS)
                    .onKeyPress(.space) {
                        configuration.isOn.toggle()
                        return .handled
                    }
                #endif
                Text(configuration.isOn ? stateLabelPair.onLabel : stateLabelPair.offLabel)
            }
            .frame(width: fittingWidth)
            // Hide the image from accessibility features so the label is used instead of the image name.
            .accessibilityHidden(true)
        }
        .accessibilityValue(configuration.isOn ? stateLabelPair.onLabel : stateLabelPair.offLabel)
        .gesture(pressedState(configuration))
        .accessibilityAction {
            configuration.isOn.toggle()
        }

    }

    // MARK: - Pressed State

    func pressedState(_ configuration: Configuration) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                withAnimation(.smooth(duration: 0.2)) {
                    // Unhighlight the checkbox if dragging too far from the location at which it was pressed. 5 pixels away from the start location is assumed to be outside the frame.
                    let draggingOutsideFrame = value.location.x > value.startLocation.x + 5 || value.location.y > value.startLocation.y + 5 || value.location.x < value.startLocation.x - 5 || value.location.y < value.startLocation.y - 5
                    if draggingOutsideFrame {
                        pressed = false
                    } else {
                        pressed = true
                    }
                }
            }
            .onEnded { value in
                if pressed {
                    withAnimation(.bouncy(duration: 0.5)) {
                        pressed = false
                        configuration.isOn.toggle()
                    }
                }
            }
    }

}

// MARK: - ToggleStyle Extensions

#if !os(tvOS)
#if !os(visionOS)
public extension ToggleStyle where Self == StateLabelCheckboxToggleStyle {
    
    /// A toggle style that renders as a square, rectangular, or circular checkbox and shows a label indicating the current state (e.g., "On" or "Off").
    /// - Parameter stateLabelPair: The pair of opposing words to use for the checkbox's state label (e.g., "On" and "Off").
    /// - Parameter shape: The shape of the checkbox.
    /// - Parameter fill: Whether the checkbox has a background fill.
    static func stateLabelCheckbox(stateLabelPair: StateLabelCheckboxToggleStyle.StateLabelPair, shape: StateLabelCheckboxToggleStyle.CheckboxShape = .square, fill: Bool = true) -> StateLabelCheckboxToggleStyle {
        StateLabelCheckboxToggleStyle(stateLabelPair: stateLabelPair, shape: shape, fill: fill)
    }
    
}
#else
public extension ToggleStyle where Self == StateLabelCheckboxToggleStyle {
    
    /// A toggle style that renders as a circular checkbox and shows a label indicating the current state (e.g., "On" or "Off").
    /// - Parameter stateLabelPair: The pair of opposing words to use for the checkbox's state label (e.g., "On" and "Off").
    /// - Parameter fill: Whether the checkbox has a background fill.
    static func stateLabelCheckbox(stateLabelPair: StateLabelCheckboxToggleStyle.StateLabelPair, fill: Bool = true) -> StateLabelCheckboxToggleStyle {
        StateLabelCheckboxToggleStyle(stateLabelPair: stateLabelPair, fill: fill)
    }
    
}
#endif

// MARK: - Preview

#if !os(visionOS)
#Preview("Filled Square") {
    @Previewable @State var isOn: Bool = false
    Toggle(isOn: $isOn) {
        Text("Toggle")
    }
    .toggleStyle(.stateLabelCheckbox(stateLabelPair: .onOff, shape: .square, fill: true))
}

#Preview("Square") {
    @Previewable @State var isOn: Bool = false
    Toggle(isOn: $isOn) {
        Text("Toggle")
    }
    .toggleStyle(.stateLabelCheckbox(stateLabelPair: .onOff, shape: .square, fill: false))
}

#Preview("Filled Rect") {
    @Previewable @State var isOn: Bool = false
    Toggle(isOn: $isOn) {
        Text("Toggle")
    }
    .toggleStyle(.stateLabelCheckbox(stateLabelPair: .onOff, shape: .rectangle, fill: true))
}

#Preview("Rect") {
    @Previewable @State var isOn: Bool = false
    Toggle(isOn: $isOn) {
        Text("Toggle")
    }
    .toggleStyle(.stateLabelCheckbox(stateLabelPair: .onOff, shape: .rectangle, fill: false))
}

#Preview("Filled Shield") {
    @Previewable @State var isOn: Bool = false
    Toggle(isOn: $isOn) {
        Text("Toggle")
    }
    .toggleStyle(
        .stateLabelCheckbox(
            stateLabelPair: .blockedUnblocked,
            shape: .shield,
            fill: true
        )
    )
}

#Preview("Shield") {
    @Previewable @State var isOn: Bool = false
    Toggle(isOn: $isOn) {
        Text("Toggle")
    }
    .toggleStyle(
        .stateLabelCheckbox(
            stateLabelPair: .blockedUnblocked,
            shape: .shield,
            fill: false
        )
    )
}
#endif

#Preview("Filled Circle") {
    @Previewable @State var isOn: Bool = false
    Toggle(isOn: $isOn) {
        Text("Toggle")
    }
    #if os(visionOS)
    .toggleStyle(.stateLabelCheckbox(stateLabelPair: .onOff, fill: true))
    #else
    .toggleStyle(.stateLabelCheckbox(stateLabelPair: .onOff, shape: .circle, fill: true))
    #endif
}

#Preview("Circle") {
    @Previewable @State var isOn: Bool = false
    Toggle(isOn: $isOn) {
        Text("Toggle")
    }
#if os(visionOS)
.toggleStyle(.stateLabelCheckbox(stateLabelPair: .onOff, fill: true))
#else
.toggleStyle(.stateLabelCheckbox(stateLabelPair: .onOff, shape: .circle, fill: false))
#endif
}
#endif
