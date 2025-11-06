//
//  ListColorPicker.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/29/24.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

// MARK: - Imports

import SwiftUI

#if !os(tvOS) && !os(watchOS)
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

#Preview {
    ListColorPicker("Color", colorNames: ["Red", "Orange", "Yellow", "Green", "Blue", "Purple", "Rose Gold", "Navy Blue"], selection: .constant("Red"))
}


struct ListColorPickerLibraryProvider: LibraryContentProvider {

    var views: [LibraryItem] {
        LibraryItem(ListColorPicker("Color", colorNames: ["Red", "Orange", "Yellow", "Green", "Blue", "Purple"], selection: .constant("Red")), visible: true, title: "List Color Picker", category: .control, matchingSignature: "listcolorpicker")
    }

}
#endif
