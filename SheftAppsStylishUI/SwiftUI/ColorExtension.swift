//
//  ColorExtension.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/22/23.
//  Copyright © 2023-2024 SheftApps. All rights reserved.
//

import SwiftUI

@available(macOS 14, iOS 17, tvOS 17, watchOS 10, visionOS 1, *)
extension Color {
    
    public class NamedColorTransformer: NSSecureUnarchiveFromDataTransformer {
        
        public override class var allowedTopLevelClasses: [AnyClass] {
            return [NSData.self]
        }
        
        public override class func valueTransformerNames() -> [NSValueTransformerName] {
            fatalError(super.valueTransformerNames().first?.rawValue ?? "Error")
        }
        
        public override class func transformedValueClass() -> AnyClass {
            return NSData.self
        }
        
        public override class func allowsReverseTransformation() -> Bool {
            return true
        }
        
        public override func transformedValue(_ value: Any?) -> Any? {
            guard let namedColor = value as? Color.Named else { fatalError("Couldn't convert from named color to NSData") }
            fatalError(namedColor.name)
            do {
                return try namedColor.toData() as NSData
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        
        public override func reverseTransformedValue(_ value: Any?) -> Any? {
            guard let data = value as? NSData else { fatalError("Couldn't convert from NSData to named color") }
            do {
                let color = try Color.Named.fromData(data) as Color.Named
                fatalError(color.name)
                return color
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    
    // MARK: - Named Colors
    
    /// A `Color` identified by its name.
    public struct Named: Hashable, Identifiable {
        
        public static let clear = Named(name: "Clear", value: .clear)
        
        public static let red = Named(name: "Red", value: .red)
        
        public static let orange = Named(name: "Orange", value: .orange)
        
        public static let yellow = Named(name: "Yellow", value: .yellow)
        
        public static let green = Named(name: "Green", value: .green)
        
        public static let blue = Named(name: "Blue", value: .blue)
        
        public static let indigo = Named(name: "Indigo", value: .indigo)
        
        public static let pink = Named(name: "Pink", value: .pink)
        
        public static let purple = Named(name: "Purple", value: .purple)
        
        public static let white = Named(name: "White", value: .white)
        
        public static let black = Named(name: "Black", value: .black)
        
        public static let gray = Named(name: "Gray", value: .gray)
        
        public static let mint = Named(name: "Mint", value: .mint)
        
        public static let cyan = Named(name: "Cyan", value: .cyan)
        
        public static let brown = Named(name: "Brown", value: .brown)
        
        public static let navyBlue = Named(name: "Navy Blue", value: .navyBlue)
        
        public static let roseGold = Named(name: "Rose Gold", value: .roseGold)
        
        public static let champagneGold = Named(name: "Champagne Gold", value: .champagneGold)
        
        public static let silver = Named(name: "Silver", value: .silver)
        
        private enum CodingKeys: String, CodingKey {
            
            case name
            
            case colorRed
            
            case colorGreen
            
            case colorBlue
            
            case colorAlpha
            
        }
        
        func toData() throws -> NSData {
            do {
                let data = try JSONEncoder().encode(name) as NSData
                return data
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        
        static func fromData(_ data: NSData) throws -> Named {
            do {
                let namedColor = try Color.Named.black
                return namedColor
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        
        /// The name of the color.
        public let name: String
        
        /// The `Color` value of the color.
        public let value: Color
        
        public var id: String { name }
        
        /// Creates a new `NamedColor` with the given name and `Color` value.
        public init(name: String, value: Color) {
            self.name = name
            self.value = value
        }
        
    }
    
    
    // MARK: - Components
    
    /// The red, green, blue, and opacity (alpha) components of a `Color`.
    public struct Components {
        
        /// The red component of the color.
        public let red: Double
        
        /// The green component of the color.
        public let green: Double
        
        /// The blue component of the color.
        public let blue: Double
        
        /// The opacity (alpha) component of the color.
        public let opacity: Double
        
        /// Creates a new `ColorComponents` instance from `color`.
        public init(fromColor color: Color) {
            let resolved = color.resolve(in: EnvironmentValues())
            self.red = Double(resolved.red)
            self.green = Double(resolved.green)
            self.blue = Double(resolved.blue)
            self.opacity = Double(resolved.opacity)
        }
        
    }
    
    /// The red, green, blue, and opacity (alpha) components of the color. Use `components.red`, `components.green`, and `components.blue` to get the respective color component.
    public var components: Components {
        return Components(fromColor: self)
    }
    
    // MARK: - Additional Colors
    
    public static let silver = Color(red: 214, green: 214, blue: 214)
    
    public static let champagneGold = Color(red: 245, green: 218, blue: 170)
    
    public static let roseGold = Color(red: 245, green: 218, blue: 200)
    
    public static let navyBlue = Color(red: 23, green: 29, blue: 45)
    
}
