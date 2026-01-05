//
//  ClosedRangeExtension.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/22/24.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import Foundation

public extension Numeric where Self: Comparable & Strideable {

    static var maxValue: Self {
        if let intType = Self.self as? any BinaryInteger.Type {
            return intType.init(Int.max) as! Self
        } else if let floatType = Self.self as? any BinaryFloatingPoint.Type {
            return floatType.init(Float.greatestFiniteMagnitude) as! Self
        } else {
            fatalError("Unsupported type: \(Self.self)")
        }
    }
}

/// Static methods and properties for getting a specific `ClosedRange` of numeric values.
public extension ClosedRange where Bound: Numeric & Comparable & Strideable {

    // MARK: - Fixed Values

    /// A `ClosedRange` consisting of all possible positive numbers, including 0.
    static var allPositivesIncludingZero: ClosedRange<Bound> {
        return 0...Bound.maxValue
    }

    /// A `ClosedRange` consisting of all possible positive numbers, excluding 0.
    static var allPositivesExcludingZero: ClosedRange<Bound> {
        return 1...Bound.maxValue
    }

    // MARK: - X To Max

    /// A `ClosedRange` consisting of all numbers from 0 to `maxValue`.
    static func zeroToMax(_ maxValue: Bound) -> ClosedRange<Bound> {
        return 0...maxValue
    }

    /// A `ClosedRange` consisting of all numbers from 1 to `maxValue`.
    static func oneToMax(_ maxValue: Bound) -> ClosedRange<Bound> {
        return 1...maxValue
    }

}

/// Static methods and properties for getting a specific `Range` of numeric values.
public extension Range where Bound: Numeric & Comparable & Strideable {

    // MARK: - X To But Not Including

    /// A `Range` consisting of all numbers from 0 to, but not including, `maxValue`.
    static func zeroToButNotIncluding(_ maxValue: Bound) -> Range<Bound> {
        return 0..<maxValue
    }

    /// A `Range` consisting of all numbers from 1 to, but not including, `maxValue`.
    static func oneToButNotIncluding(_ maxValue: Bound) -> Range<Bound> {
        return 1..<maxValue
    }

}
