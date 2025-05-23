//
//  StateLabelCheckboxToggleStyle.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/17/24.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

#if !os(tvOS)
import SwiftUI

// MARK: - Toggle Style

/// A toggle style that renders as a rectangular or circular checkbox and shows a label indicating the current state (e.g., "On" or "Off).
@available(macOS 14, iOS 17, watchOS 10, visionOS 1, *)
public struct StateLabelCheckboxToggleStyle: ToggleStyle {
    
    /// A pair of opposing words to use as the state label for a `Toggle` with the `StateLabelCheckboxToggleStyle`.
    public enum StateLabelPair {
        
        /// The checkbox's state label shows "On" in the on state and 'Off" in the off state.
        case onOff
        
        /// The checkbox's state label shows "Yes" in the on state and 'No" in the off state.
        case yesNo
        
        /// The checkbox's state label shows `onLabel` in the on state and `offLabel` in the off state.
        case custom(onLabel: String, offLabel: String)
        
        /// The checkbox's on state label.
        var onLabel: String {
            switch self {
            case .onOff:
                return "On"
            case .yesNo:
                return "Yes"
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
            case .custom(_, let offLabel):
                return offLabel
            }
        }
        
    }
    
    /// Possible shapes for a `Toggle` with the `StateLabelCheckboxToggleStyle`.
    public enum CheckboxShape: String {

        /// The checkbox has a rounded square shape.
        case square

        /// The checkbox has a rounded rectangle shape.
        case rectangle
        
        /// The checkbox has a circular shape.
        case circle
        
    }
    
    @State var pressed: Bool = false
    
    let stateLabelPair: StateLabelPair
    
    let shape: CheckboxShape
    
    let fill: Bool
    
    /// Creates a new `StateLabelCheckboxToggleStyle` with the given pair of opposing state words, shape, and Boolean indicating whether the checkbox has a background fill.
    @available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
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
            // Hide the image from accessibility features so the label is used instead of the image name.
            .accessibilityHidden(true)
        }
        .accessibilityValue(configuration.isOn ? stateLabelPair.onLabel : stateLabelPair.offLabel)
        .gesture(pressedState(configuration))
        .accessibilityAction {
            configuration.isOn.toggle()
        }

    }
    
    func pressedState(_ configuration: Configuration) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                withAnimation(.smooth(duration: 0.2)) {
                    // Unhighlight the checkbox if dragging too far from the location at which it was pressed.
                    if value.location.x > value.startLocation.x + 5 || value.location.y > value.startLocation.y + 5 || value.location.x < value.startLocation.x - 5 || value.location.y < value.startLocation.y - 5 {
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

// MARK: - ToggleStyle Extension

#if !os(visionOS)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
public extension ToggleStyle where Self == StateLabelCheckboxToggleStyle {
    
    /// A toggle style that renders as a rectangular or circular checkbox and shows a label indicating the current state (e.g., "On" or "Off").
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

#if !os(visionOS)
@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
#Preview("Filled Square") {
    @Previewable @State var isOn: Bool = false
    Toggle(isOn: $isOn) {
        Text("Toggle")
    }
    .toggleStyle(.stateLabelCheckbox(stateLabelPair: .onOff, shape: .square, fill: true))
}

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
#Preview("Square") {
    @Previewable @State var isOn: Bool = false
    Toggle(isOn: $isOn) {
        Text("Toggle")
    }
    .toggleStyle(.stateLabelCheckbox(stateLabelPair: .onOff, shape: .square, fill: false))
}

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
#Preview("Filled Rect") {
    @Previewable @State var isOn: Bool = false
    Toggle(isOn: $isOn) {
        Text("Toggle")
    }
    .toggleStyle(.stateLabelCheckbox(stateLabelPair: .onOff, shape: .rectangle, fill: true))
}

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
#Preview("Rect") {
    @Previewable @State var isOn: Bool = false
    Toggle(isOn: $isOn) {
        Text("Toggle")
    }
    .toggleStyle(.stateLabelCheckbox(stateLabelPair: .onOff, shape: .rectangle, fill: false))
}
#endif

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
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

@available(macOS 14, iOS 17, watchOS 10, visionOS 1, *)
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
