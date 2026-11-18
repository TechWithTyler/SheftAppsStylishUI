//
//  WiderString.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 11/16/26.
//  Copyright © 2026 SheftApps. All rights reserved.
//

import Foundation

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
public typealias PlatformFont = NSFont
#elseif canImport(UIKit)
import UIKit
public typealias PlatformFont = UIFont
#endif

extension String {

    /// Returns the width of the longest `String` in `strings`.
    ///
    /// - parameter strings: An array of 'String's whose widths should be compared.
    /// This method is useful when you want the frame of a label to remain consistent regardless of the width of the text it's showing.
    public static func widthOfLongest(in strings: [String], forTextStyle textStyle: PlatformFont.TextStyle = .body) -> CGFloat? {
        // 1. Get the font attribute for the given text style.
        let font = PlatformFont.preferredFont(forTextStyle: textStyle)
        let attributes: [NSAttributedString.Key : Any] = [.font : font]
        // 2. Create an array containing the widths of all strings.
        let widths = strings.map {
            return $0.size(withAttributes: attributes).width
        }
        // 3. If we can get the max width, round it up and return it. If not, return nil.
        if let maxWidth = widths.max() {
            let maxWidthRoundedUp = ceil(maxWidth)
            return maxWidthRoundedUp
        } else {
            return nil
        }
    }

}

