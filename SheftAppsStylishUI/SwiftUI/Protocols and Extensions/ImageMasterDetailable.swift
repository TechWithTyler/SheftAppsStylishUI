//
//  ImageMasterDetailable.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 2/13/26.
//  Copyright © 2026 SheftApps. All rights reserved.
//

// MARK: - Imports

import SwiftUI

// MARK: - Master-Detail Image Display Mode Enum

/// Display modes for images in SwiftUI views conforming to `ImageMasterDetailable`.
///
/// Implement the `size` property of conforming types to return a different value based on these cases.
public enum MasterDetailImageDisplayMode: Hashable {

    /// The image is used as a thumbnail (e.g. in a list view).
    case thumbnail

    /// The image is used as a normal image (e.g. in a detail view).
    case full

    /// The image is used as a backdrop (e.g. as a `SlickBackdropView`'s backdrop content.
    case backdrop

}

// MARK: - Master-Detail Image View Protocol

/// Properties for SwiftUI views which show a single image for use in master-detail views.
public protocol ImageMasterDetailable {

    /// The display mode of the image.
    var displayMode: MasterDetailImageDisplayMode { get }

    /// The size of the image.
    ///
    /// This property should return a different size based on `displayMode` (e.g. a larger size for an image in a detail view and a smaller size for that same image in a list view).
    var size: CGFloat { get }

}
