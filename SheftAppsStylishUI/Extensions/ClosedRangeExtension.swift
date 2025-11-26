//
//  ClosedRangeExtension.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/22/24.
//  Copyright © 2022-2025 SheftApps. All rights reserved.
//

// MARK: - Imports

import Foundation

/// Static methods and properties for getting a specific range of numeric values.
public extension ClosedRange where Bound: Numeric & Comparable {

    // MARK: - Fixed Values

    private static var maxValue: Bound {
        if let intType = Bound.self as? any BinaryInteger.Type {
            return (intType.init(Int.max) as? Bound)!
        } else if let floatType = Bound.self as? any BinaryFloatingPoint.Type {
            return (floatType.init(Float.greatestFiniteMagnitude) as? Bound)!
        } else {
            fatalError("Unsupported type: \(type(of: Bound.self))")
        }
    }

    /// A range consisting of all possible positive numbers, including 0.
    static var allPositivesIncludingZero: ClosedRange<Bound> {
        return 0...maxValue
    }

    /// A range consisting of all possible positive numbers, excluding 0.
    static var allPositivesExcludingZero: ClosedRange<Bound> {
        return 1...maxValue
    }

    // MARK: - X To Max

    /// A range consisting of all numbers from 0 to `maxValue`.
    static func zeroToMax(_ maxValue: Bound) -> ClosedRange<Bound> {
        return 0...maxValue
    }

    /// A range consisting of all numbers from 1 to `maxValue`.
    static func oneToMax(_ maxValue: Bound) -> ClosedRange<Bound> {
        return 1...maxValue
    }

}
