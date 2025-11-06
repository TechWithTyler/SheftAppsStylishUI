//
//  TopIconBottomTitleLabelStyle.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/1/23.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

// MARK: - Imports

import SwiftUI

// MARK: - Label Style

/// A label style that displays the icon at the top and the title at the bottom.
public struct TopIconBottomTitleLabelStyle: LabelStyle {

    /// Creates a new `TopIconBottomTitleLabelStyle`.
    public init() {}

    @ViewBuilder
    public func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.icon
                .frame(minWidth: 20, maxWidth: 20, minHeight: 20, maxHeight: 20)
            configuration.title
        }
        .frame(minWidth: 50, maxWidth: 50, minHeight: 50, maxHeight: 50)
    }
    
}

// MARK: - LabelStyle Extension

public extension LabelStyle where Self == TopIconBottomTitleLabelStyle {
    
    /// A label style that displays the icon at the top and the title at the bottom.
    static var topIconBottomTitle: TopIconBottomTitleLabelStyle {
        return TopIconBottomTitleLabelStyle()
    }
    
}
