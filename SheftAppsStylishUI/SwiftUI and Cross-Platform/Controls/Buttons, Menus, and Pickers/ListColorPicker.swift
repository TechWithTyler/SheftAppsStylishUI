//
//  ListColorPicker.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/29/24.
//  Copyright © 2024 SheftApps. All rights reserved.
//

import SwiftUI

#if !os(tvOS) && !os(watchOS)
@available(macOS 14, iOS 17, visionOS 1, *)
public struct ListColorPicker<Label: View>: View {
    
    @Binding var selection: String
    
    var label: Label
    
    var colorNames: [String]
    
    var includeNoColorOption: Bool
    
    public init(colorNames: [String], selection: Binding<String>, includeNoColorOption: Bool = false, @ViewBuilder label: (() -> Label) = {Text("Color")}) {
        self.colorNames = colorNames
        self.includeNoColorOption = includeNoColorOption
        self._selection = selection
        self.label = label()
    }
    
    public init(_ title: String, colorNames: [String], selection: Binding<String>, includeNoColorOption: Bool = false) where Label == Text {
        self.colorNames = colorNames
        self.includeNoColorOption = includeNoColorOption
        self._selection = selection
        self.label = Text(title)
    }
    
    public var body: some View {
        HStack {
            Picker(selection: $selection) {
                ForEach(colorNames, id: \.self) { color in
                    Text(color).tag(color)
                }
                if includeNoColorOption {
                    Divider()
                    Text("None").tag(String())
                }
            } label: {
                label
            }
            
        }
    }
}

@available(macOS 14, iOS 17, visionOS 1, *)
#Preview {
    ListColorPicker("Color", colorNames: ["Red", "Orange", "Yellow", "Green", "Blue", "Purple", "Rose Gold", "Navy Blue"], selection: .constant("Red"))
}

#endif
