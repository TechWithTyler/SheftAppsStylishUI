//
//  HexStringExtension.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 3/1/24.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import Foundation

extension String {

    func cleanedForHex() -> String {
        if hasPrefix("0x") {
            return String(dropFirst(2))
        }
        if hasPrefix("#") {
            return String(dropFirst(1))
        }
        return self
    }

    func conforms(to pattern: String) -> Bool {
        let pattern = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pattern.evaluate(with: self)
    }
}
