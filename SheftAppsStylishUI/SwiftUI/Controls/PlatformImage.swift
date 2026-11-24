//
//  PlatformImage.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 7/30/26.
//  Copyright © 2022-2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import SwiftUI
import ImageIO

// MARK: - PlatformImage

#if os(macOS)
public typealias PlatformImage = NSImage
#else
public typealias PlatformImage = UIImage
#endif

public extension PlatformImage {

    /// Creates a `PlatformImage` from the given data by decoding it to the given maximum pixel size.
    static func decodedImage(
        from data: Data,
        maxPixelSize: CGFloat
    ) async -> PlatformImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixelSize,
            kCGImageSourceCreateThumbnailWithTransform: true
        ]
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(
            source,
            0,
            options as CFDictionary
        ) else {
            return nil
        }
        #if os(macOS)
        return NSImage(cgImage: cgImage,
                       size: .zero)
        #else
        return UIImage(cgImage: cgImage)
        #endif
    }

}

// MARK: - Image Extension

public extension Image {

    /// Creates an `Image` from an `NSImage` on macOS or `UIImage` on other platforms.
    init(platformImage: PlatformImage) {
        #if os(macOS)
        self.init(nsImage: platformImage)
        #else
        self.init(uiImage: platformImage)
        #endif
    }

}

