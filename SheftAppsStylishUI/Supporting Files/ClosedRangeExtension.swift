//
//  ClosedRangeExtension.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 1/22/24.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import Foundation

/// Static properties for getting a specific range of `Int` values.
public extension ClosedRange<Int> {
    
    /// A range consisting of all possible positive numbers, including 0.
    static var allPositivesIncludingZero: ClosedRange<Int> {
        return 0...Int.max
    }
    
    /// A range consisting of all possible positive numbers, excluding 0.
    static var allPositivesExcludingZero: ClosedRange<Int> {
        return 1...Int.max
    }
    
    /// A range consisting of all numbers from 0 to `maxValue`.
    static func zeroToMax(_ maxValue: Int) -> ClosedRange<Int> {
        return 0...maxValue
    }
    
    /// A range consisting of all numbers from 1 to `maxValue`.
    static func oneToMax(_ maxValue: Int) -> ClosedRange<Int> {
        return 1...maxValue
    }
    
}

/// Static properties for getting a specific range of `Float` values.
public extension ClosedRange<Float> {
    
    /// A range consisting of all possible positive numbers, including 0.
    static var allPositivesIncludingZero: ClosedRange<Float> {
        return 0...Float.greatestFiniteMagnitude
    }
    
    /// A range consisting of all possible positive numbers, excluding 0.
    static var allPositivesExcludingZero: ClosedRange<Float> {
        return 1...Float.greatestFiniteMagnitude
    }
    
    /// A range consisting of all numbers from 0 to `maxValue`.
    static func zeroToMax(_ maxValue: Float) -> ClosedRange<Float> {
        return 0...maxValue
    }
    
    /// A range consisting of all numbers from 1 to `maxValue`.
    static func oneToMax(_ maxValue: Float) -> ClosedRange<Float> {
        return 1...maxValue
    }
    
}

/// Static properties for getting a specific range of `Double` values.
public extension ClosedRange<Double> {
    
    /// A range consisting of all possible positive numbers, including 0.
    static var allPositivesIncludingZero: ClosedRange<Double> {
        return 0...Double.greatestFiniteMagnitude
    }
    
    /// A range consisting of all possible positive numbers, excluding 0.
    static var allPositivesExcludingZero: ClosedRange<Double> {
        return 1...Double.greatestFiniteMagnitude
    }
    
    /// A range consisting of all numbers from 0 to `maxValue`.
    static func zeroToMax(_ maxValue: Double) -> ClosedRange<Double> {
        return 0...maxValue
    }
    
    /// A range consisting of all numbers from 1 to `maxValue`.
    static func oneToMax(_ maxValue: Double) -> ClosedRange<Double> {
        return 1...maxValue
    }
    
}


