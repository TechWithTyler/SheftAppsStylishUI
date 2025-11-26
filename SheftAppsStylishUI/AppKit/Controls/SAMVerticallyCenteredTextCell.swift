//
//  SAMVerticallyCenteredTextCell.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 3/9/22.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

#if os(macOS)

// MARK: - Imports

import Cocoa
import Foundation

/// A subclass of `NSTextFieldCell` that is vertically center-aligned.
public class SAMVerticallyCenteredTextCell: NSTextFieldCell {

    // MARK: - Drawing

    override public func titleRect(forBounds bounds: NSRect) -> NSRect {
        return verticallyCenteredTextRect(for: bounds)
    }

    override public func drawInterior(withFrame frame: NSRect, in view: NSView) {
        let bounds = frame
        super.drawInterior(withFrame: titleRect(forBounds: bounds), in: view)
    }
    
    func verticallyCenteredTextRect(for bounds: NSRect) -> NSRect {
        // 1. Get the attributed string value. This is often just the stringValue converted to an NSAttributedString.
        let attrString = attributedStringValue
        // 2. Get the height of the string.
        let stringHeight: CGFloat = attrString.size().height
        // 3. Get the title rect.
        var titleRect: NSRect = super.titleRect(forBounds: bounds)
        // 4. Set the Y position and height.
        let oldOriginY = bounds.origin.y
        titleRect.origin.y = bounds.origin.y + (bounds.size.height - stringHeight) / 2.0
        titleRect.size.height = titleRect.size.height - (titleRect.origin.y - oldOriginY)
        // 5. Return the new rect.
        return titleRect
    }

}
#endif
