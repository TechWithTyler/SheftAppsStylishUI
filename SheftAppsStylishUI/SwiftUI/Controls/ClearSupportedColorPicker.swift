//
//  ClearSupportedColorPicker.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/22/23.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import SwiftUI

/// A `ColorPicker` with a `Button` that sets its color to `Color.clear`.
///
/// When `selection` is set to a value other than `Color.clear`, a checkmark appears to the right of the color picker. When `selection` is set to `Color.clear`, a checkmark appears to the right of the "no color" button.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct ClearSupportedColorPicker<ClearButtonContent: View, Label: View>: View {
    
    var label: Label
    
    @Binding var selection: Color
    
    var clearButtonContent: ClearButtonContent
    
    /// Creates a new `ClearSupportedColorPicker` with the given selection binding, label, and optional "no color" button content. If "no color" button content isn't provided, it will default to a `Text` view with the text "No Color".
    public init(selection: Binding<Color>, @ViewBuilder label: @escaping (() -> Label), @ViewBuilder clearButtonContent: @escaping (() -> ClearButtonContent) = {Text("No Color")}) {
        self.label = label()
        self._selection = selection
        self.clearButtonContent = clearButtonContent()
    }
    
    /// Creates a new `ClearSupportedColorPicker` with the given title string, selection binding, and optional "no color" button content. If "no color" button content isn't provided, it will default to a `Text` view with the text "No Color".
    public init(_ title: String, selection: Binding<Color>, @ViewBuilder clearButtonContent: @escaping (() -> ClearButtonContent) = {Text("No Color")}) where Label == Text {
        self.label = Text(title)
        self._selection = selection
        self.clearButtonContent = clearButtonContent()
    }
    
    public var body: some View {
#if !os(tvOS) && !os(watchOS)
        HStack {
            label
            HStack {
                Spacer()
                ColorPicker(selection: $selection, supportsOpacity: true) { EmptyView() }
                    Image(systemName: selection != .clear ? "checkmark.circle.fill" : "circle")
                    .animatedSymbolReplacement()
                    .accessibilityLabel("Color - \(selection != .clear ? "Selected" : "Not Selected")")
            }
            Divider()
            HStack {
                Button {
                    selection = .clear
                } label: {
                    clearButtonContent
                }
                #if !os(macOS)
                .buttonStyle(.borderless)
                #endif
                Image(systemName: selection == .clear ? "checkmark.circle.fill" : "circle")
                    .animatedSymbolReplacement()
                    .accessibilityLabel("No Color - \(selection == .clear ? "Selected" : "Not Selected")")
            }
        }
#endif
    }
    
}

#if !os(tvOS) && !os(watchOS)
#Preview {
    @State var color: Color = .black
    return Form {
        ClearSupportedColorPicker("Color", selection: $color)
    }
}
#endif
