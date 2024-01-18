//
//  SAIAccessibleButton.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/16/24.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

// Code in this file only applies to iOS and visionOS. Start with #if os(iOS) || os(visionOS) and end with #endif.
#if os(iOS) || os(visionOS)
import UIKit

// SAI = SheftApps iOS
/// A subclass of `UIButton` designed for visual accessibility, with shadows and large text.
public class SAIAccessibleButton: UIButton {
    
    /// The text size of the button. Defaults to 40pt.
    ///
    /// Attempting to set the value of this property to less than 30pt will set it to 30pt.
    public var textSize: CGFloat = 40 {
        didSet {
            if textSize < 30 {
                textSize = 30
            }
            setNeedsDisplay()
        }
    }
    
    /// Whether the button has a shadow. Defaults to `true`.
    public var hasShadow: Bool = true
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        configureButtonDesign()
    }
    
    func configureButtonDesign() {
        configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: self.textSize)
            return outgoing
        }
        if hasShadow {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 2, height: 2)
            layer.shadowOpacity = 0.5
            layer.shadowRadius = 4
        }
    }
    
}
#endif
