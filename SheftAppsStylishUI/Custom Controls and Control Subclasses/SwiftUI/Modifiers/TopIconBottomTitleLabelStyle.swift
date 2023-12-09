//
//  TopIconBottomTitleLabelStyle.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/1/23.
//  Copyright © 2022-2023 SheftApps. All rights reserved.
//

import SwiftUI

/// A label style that displays the icon at the top and the title at the bottom.
public struct TopIconBottomTitleLabelStyle: LabelStyle {
    
    public func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.icon
                .frame(minHeight: 20, maxHeight: 20)
            configuration.title
        }
        .frame(minWidth: 50, maxWidth: 50)
    }
    
}

public extension LabelStyle where Self == TopIconBottomTitleLabelStyle {
    
    /// A label style that displays the icon at the top and the title at the bottom.
    static var topIconBottomTitle: TopIconBottomTitleLabelStyle {
        return TopIconBottomTitleLabelStyle()
    }
    
}
