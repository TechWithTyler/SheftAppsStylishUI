//
//  TopIconBottomTitleLabelStyle.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/1/23.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import SwiftUI

/// A label style that displays the icon at the top and the title at the bottom.
public struct TopIconBottomTitleLabelStyle: LabelStyle {

    // MARK: - Body

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

// To make a control style available as a static property on a SomethingStyle, it's declared in an extension of that SomethingStyle (in this case, LabelStyle). The where clause makes the methods and properties declared in the extension only available to this specific type adopting the protocol (in this case, TopIconBottomTitleLabelStyle). This is because extensions of protocols define methods and properties on its conforming types, not the protocol itself. This can't simply be an extension to that SomethingStyle since the somethingStyle(_:) modifiers can take in any SomethingStyle.
public extension LabelStyle where Self == TopIconBottomTitleLabelStyle {
    
    /// A label style that displays the icon at the top and the title at the bottom.
    static var topIconBottomTitle: TopIconBottomTitleLabelStyle {
        return TopIconBottomTitleLabelStyle()
    }
    
}
