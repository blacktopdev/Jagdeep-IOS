//
//  SleepPreferences.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 3/12/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

class SleepPreferences: ObservableObject {
    struct Keys {
        static let installedBuildNumber = "installedBuildNumber"
//        static let hasShownBaselineCalculated = "hasShownBaselineCalculated"
    }

    // MARK: Build Attributes

    lazy var bundleIdentifier: String = {
        return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? ""
    }()

    lazy var versionNumber: String = {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }()

    lazy var buildNumber: Int = {
        if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return Int(version) ?? 0
        }
        return 0
    }()

    /// Check if a breaking change migration is necessary, optionally marking it handled.
    /// It continues to return false until handled, either via the `isHandled` flag, or by calling `didMigrateBreakingChange()`.
    /// - Parameters:
    ///   - buildNumber: The build number of the most recent breaking change.
    ///   - isHandled: Whether the migration should immediately be marked as handled.
    /// - Returns: True if a breaking change migration is necessary.
    func shouldMigrateBreakingChange(buildNumber: Int, isHandled: Bool = false) -> Bool {
        #if DEBUG   // direct-installed build numbers can bounce around while testing (old problem)
        let result = false
        #else
        let result = installedBuildNumber < buildNumber
        #endif
        if isHandled { didMigrateBreakingChange() }
        return result
    }

    /// Mark any breaking change as handled.
    func didMigrateBreakingChange() {
        installedBuildNumber = buildNumber
    }
}

private extension SleepPreferences {

    /// Usually identical to `buildNumber`, but can be used to detect upgraded app on launch.
    var installedBuildNumber: Int {
        get { UserDefaults.standard.integer(forKey: Keys.installedBuildNumber) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.installedBuildNumber) }
    }
}
//
//extension SleepPreferences {
//
//    /// True when baselines are calculated, but no user notification has been presented.
//    var hasShownBaselineCalculated: Bool {
//        get { UserDefaults.standard.bool(forKey: Keys.hasShownBaselineCalculated) }
//        set { UserDefaults.standard.set(newValue, forKey: Keys.hasShownBaselineCalculated) }
//    }
//}
