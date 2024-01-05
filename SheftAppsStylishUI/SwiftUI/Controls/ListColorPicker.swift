//
//  ListColorPicker.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/4/24.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import SwiftUI

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
/// A `Picker` that displays a list of named colors and an optional "None" option.
public struct ListColorPicker<Label: View>: View {
    
    /// The label of the color picker.
    var label: Label
    
    /// The currently selected `NamedColor`.
    @Binding var selection: Color.Named
    
    /// Whether the list shows a "None" option.
    var allowNoColor: Bool
    
    /// The colors to show in the list.
    var colors: [Color.Named]
    
    /// Creates a new `ListColorPicker` with the given `Color` array, selection binding, Boolean value indicating whether a "None" option should be displayed, and label.
    public init(colors: [Color.Named], selection: Binding<Color.Named>, allowNoColor: Bool = false, @ViewBuilder label: @escaping (() -> Label)) {
        self.label = label()
        self.colors = colors
        self.allowNoColor = allowNoColor
        self._selection = selection
    }
    
    /// Creates a new `ListColorPicker` with the given title, `Color` array, selection binding, and Boolean value indicating whether a "None" option should be displayed.
    public init(_ title: String, colors: [Color.Named], selection: Binding<Color.Named>, allowNoColor: Bool = false) where Label == Text {
        self.label = Text(title)
        self.colors = colors
        self.allowNoColor = allowNoColor
        self._selection = selection
    }
    
    public var body: some View {
            Picker(selection: $selection) {
                ForEach(colors) { color in
                        Text(color.name).tag(color)
                }
            } label: {
                label
            }
    }
    
}

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
#Preview("None Not Supported") {
    @State var selectedColor: Color.Named = .red
    return ListColorPicker("Color", colors: [
        .red,
        Color.Named(name: "Rose Gold", value: .roseGold)
    ], selection: $selectedColor, allowNoColor: false)
}

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
#Preview("None Supported") {
    @State var selectedColor: Color.Named = .red
    return ListColorPicker("Color", colors: [
        .red,
        Color.Named(name: "Rose Gold", value: .roseGold)
    ], selection: $selectedColor, allowNoColor: true)
}
