//
//  ScrollableText.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 11/21/23.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import SwiftUI

/// A `Text` view that can scroll.
public struct ScrollableText: View {
    
    let text: String
    
    public init(_ text: String) {
        self.text = text
    }
    
    public var body: some View {
        ScrollView {
            Text(text)
                .padding()
        }
    }
}
