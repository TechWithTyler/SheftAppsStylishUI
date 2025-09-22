//
//  SAIAccessibleButton.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/16/24.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

// Code in this file only applies to iOS and visionOS. Start with #if os(iOS) || os(visionOS) and end with #endif.
#if os(iOS) || os(visionOS)
import UIKit

// SAI = SheftApps iOS
/// A subclass of `UIButton` designed for visual accessibility, with large text, an optional monospaced font, and an optional shadow.
public class SAIAccessibleButton: UIButton {
    
    /// The text size of the button. Defaults to 40pt.
    ///
    /// - Important: Attempting to set the value of this property to anything less than 30pt will set it to 30pt. `SAIAccessibleButton` is designed for visual accessibility and therefore its font size can't be set to a value less than 30pt. Use `UIButton` if you don't want to force a visually-accessible design.
    public var textSize: CGFloat = 40 {
        didSet {
            if textSize < 30 {
                textSize = 30
            }
            setNeedsDisplay()
        }
    }

    /// Whether the button's title should use a monospaced font.
    ///
    /// Set this property to true if visually-clear button titles are crucial in your design.
    public var usesMonospacedFont: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    /// Whether the button has a shadow. Defaults to `true`.
    public var hasShadow: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        configureButtonDesign()
    }
    
    func configureButtonDesign() {
        // 1. Pass the button's configuration through a UIConfigurationTextAttributesTransformer to configure its font.
        configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { [self] incoming in
            var outgoing = incoming
            outgoing.font = usesMonospacedFont ? UIFont(name: "Verdana", size: self.textSize) : UIFont.systemFont(ofSize: self.textSize)
            return outgoing
        }
        // 2. If hasShadow is true, configure the shadow.
        if hasShadow {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 2, height: 2)
            layer.shadowOpacity = 0.5
            layer.shadowRadius = 4
        }
        // 3. Set the preferredBehavioralStyle to the iPad idiom even if running in the Mac idiom--the macOS button design interferes with the intended design of SAIAccessibleButtons.
        preferredBehavioralStyle = .pad
    }
    
}

#Preview {
    let button = SAIAccessibleButton(frame: CGRect(x: 50, y: 50, width: 200, height: 200))
    button.setTitle("Button", for: .normal)
    button.backgroundColor = .tintColor
    button.hasShadow = true
    return button
}

#endif
