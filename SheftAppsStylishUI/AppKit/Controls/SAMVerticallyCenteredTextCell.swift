//
//  SAMVerticallyCenteredTextCell.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 3/9/22.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

#if os(macOS)
import Cocoa
import Foundation

/// A subclass of `NSTextFieldCell` that is vertically center-aligned.
public class SAMVerticallyCenteredTextCell: NSTextFieldCell {

    override public func titleRect(forBounds bounds: NSRect) -> NSRect {
        return verticallyCenteredText(for: bounds)
    }

    override public func drawInterior(withFrame frame: NSRect, in view: NSView) {
        let bounds = frame
        super.drawInterior(withFrame: titleRect(forBounds: bounds), in: view)
    }
    
    func verticallyCenteredText(for bounds: NSRect) -> NSRect {
        let attrString = attributedStringValue
        let stringHeight: CGFloat = attrString.size().height
        var titleRect: NSRect = super.titleRect(forBounds: bounds)
        let oldOriginY = bounds.origin.y
        titleRect.origin.y = bounds.origin.y + (bounds.size.height - stringHeight) / 2.0
        titleRect.size.height = titleRect.size.height - (titleRect.origin.y - oldOriginY)
        return titleRect
    }

}
#endif
