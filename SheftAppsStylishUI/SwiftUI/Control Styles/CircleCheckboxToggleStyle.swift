//
//  CircleCheckboxToggleStyle.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 9/13/24.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

import SwiftUI

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
/// A toggle style that renders as a filled circle that shows a checkmark when turned on or a circle outline when turned off, often used for marking something as completed.
public struct CircleCheckboxToggleStyle: ToggleStyle {

    @State var pressed: Bool = false

    public func makeBody(configuration: Configuration) -> some View {
        Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
            .opacity(pressed ? 0.5 : 1)
            .animatedSymbolReplacement()
            .foregroundStyle(.white, configuration.isOn ? Color.accentColor : Color.primary)
            .focusable(interactions: .activate)
            .font(.system(size: 20, weight: configuration.isOn ? .bold : .light))
#if !os(watchOS)
            .onKeyPress(.space) {
                configuration.isOn.toggle()
                return .handled
            }
#endif
            .gesture(pressedState(configuration))
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

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
public extension ToggleStyle where Self == StateLabelCheckboxToggleStyle {

    /// A toggle style that renders as a filled circle that shows a checkmark when turned on or a circle outline when turned off, often used for marking something as completed.
    static var circleCheckbox: CircleCheckboxToggleStyle {
        CircleCheckboxToggleStyle()
    }

}

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
#Preview("On") {
    Toggle(isOn: .constant(true)) {
        Text("Toggle")
    }
    .toggleStyle(.circleCheckbox)
}

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
#Preview("Off") {
    Toggle(isOn: .constant(false)) {
        Text("Toggle")
    }
    .toggleStyle(.circleCheckbox)
}
