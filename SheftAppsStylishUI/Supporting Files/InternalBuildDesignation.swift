//
//  InternalBuildDesignation.swift
//  SheftAppsStylishUI
//
//  Created by Tyler Sheft on 12/9/23.
//  Copyright © 2022-2024 SheftApps. All rights reserved.
//

import Foundation

// MARK: - SheftApps Team Internal Build Designation

/// Adds a method to append " (SheftApps Team Internal Build)" to String objects.
public extension String {
    
    /**
     Appends " (SheftApps Team Internal Build)" to `self`.
     
     This designation is useful for window titles and feedback titles, so people who look at an app can know whether the shown build is internal (unreleased, in-development). This designation makes sure people know that the build they're seeing doesn't exactly (or in some cases, at all) represent what the released version will have.
     
     For example, RandoFacto went through many different UI designs/layouts between the start of development in November 2022 and public release in November 2023, before settling on the sidebar-based design used in the final release.
     An app's final build is created by archiving the given app. Builds created by building the app normally will be marked as internal.
     
     Internal vs final build is determined by the build configuration (Debug or Release).
     
     - Important: Attempts to call this method in release builds will result in a runtime error, so you must make sure to wrap it in a `#if(DEBUG)` compiler directive block.
     */
    mutating func appendSheftAppsTeamInternalBuildDesignation() {
#if(DEBUG)
        append(" (SheftApps Team Internal Build)")
#else
        fatalError("The SheftApps Team Internal Build designation is supposed to appear only in internal builds. Please wrap this function call in a #if(DEBUG) block. Don't release this broken build as the final!")
#endif
    }
    
}
