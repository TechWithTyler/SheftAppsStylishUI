//
//  SAIAccessibleButton.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/16/24.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

#if os(iOS) || os(visionOS)
import UIKit

public class SAIAccessibleButton: UIButton {
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        setFonts()
    }
    
    func setFonts() {
                configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                    var outgoing = incoming
                    outgoing.font = UIFont.systemFont(ofSize: 40)
                    return outgoing
                }
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowOffset = CGSize(width: 2, height: 2)
                layer.shadowOpacity = 0.5
                layer.shadowRadius = 4
            }
    
}
#endif
