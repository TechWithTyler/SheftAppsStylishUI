//
//  TopIconBottomTitleLabelStyle.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/1/23.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import SwiftUI

// MARK: - Label Style

/// A label style that displays the icon at the top and the title at the bottom.
public struct TopIconBottomTitleLabelStyle: LabelStyle {
    
    @ViewBuilder
    public func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.icon
                .frame(minHeight: 20, maxHeight: 20)
            configuration.title
        }
        .frame(minWidth: 50, maxWidth: 50, minHeight: 25, maxHeight: 25)
    }
    
}

// MARK: - LabelStyle Extension

public extension LabelStyle where Self == TopIconBottomTitleLabelStyle {
    
    /// A label style that displays the icon at the top and the title at the bottom.
    static var topIconBottomTitle: TopIconBottomTitleLabelStyle {
        return TopIconBottomTitleLabelStyle()
    }
    
}
