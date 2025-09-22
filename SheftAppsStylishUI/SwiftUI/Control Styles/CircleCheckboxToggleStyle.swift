//
//  CircleCheckboxToggleStyle.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 9/13/24.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

#if !os(tvOS)
import SwiftUI

/// A toggle style that renders as a filled circle with a checkmark when turned on or a circle outline when turned off, often used for marking something as completed.
public struct CircleCheckboxToggleStyle: ToggleStyle {

    @State var pressed: Bool = false

    /// Creates a new `CircleCheckboxToggleStyle`.
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            LabeledContent {
                    Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                        .opacity(pressed ? 0.5 : 1)
                        .animatedSymbolReplacement()
                        .foregroundStyle(configuration.isOn ? .white : .primary, Color.accentColor)
                        .focusable(interactions: .activate)
                        .font(.system(size: 20, weight: configuration.isOn ? .bold : .light))
#if !os(watchOS)
                        .onKeyPress(.space) {
                            configuration.isOn.toggle()
                            return .handled
                        }
#endif
                // Hide the image from accessibility features so the label is used instead of the image name.
                .accessibilityHidden(true)
            } label: {
                configuration.label
            }
        }
        .gesture(pressedState(configuration))
            .accessibilityAction {
                configuration.isOn.toggle()
            }
    }

    func pressedState(_ configuration: Configuration) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                withAnimation(.smooth(duration: 0.2)) {
                    // Unhighlight the checkbox if dragging too far from the location at which it was pressed. 5 pixels away from the start location is assumed to be outside the frame.
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

public extension ToggleStyle where Self == CircleCheckboxToggleStyle {

    /// A toggle style that renders as a filled circle that shows a checkmark when turned on or a circle outline when turned off, often used for marking something as completed.
    static var circleCheckbox: CircleCheckboxToggleStyle {
        CircleCheckboxToggleStyle()
    }

}

#Preview {
    @Previewable @State var isOn: Bool = false
    Toggle(isOn: $isOn) {
        Text("Toggle")
    }
    .toggleStyle(.circleCheckbox)
}
#endif
