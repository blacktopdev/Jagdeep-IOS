//
//  LabPreferences.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 10/21/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import Foundation

extension Key {
    static let selectedSleepNormalsPath: Key = "selectedSleepNormalsPath"
}

struct LabSettings2 {
    @UserDefault(key: .selectedSleepNormalsPath, defaultValue: "builtin") var selectedSleepNormalsPath: String?
//    @UserDefault(key: .preferredNormalSmoothing, defaultValue: "builtin") var preferredNormalSmoothing: String?
//    @UserDefault(key: .preferredNormalAlpha, defaultValue: "builtin") var selectedSleepNormalsPath: String?
//    @UserDefault(key: .preferredStagingSmoothing, defaultValue: "builtin") var preferredStagingSmoothing: String?
//    @UserDefault(key: .selectedSleepNormalsPath, defaultValue: "builtin") var selectedSleepNormalsPath: String?
//    @UserDefault(key: .selectedSleepNormalsPath, defaultValue: "builtin") var selectedSleepNormalsPath: String?
//    @UserDefault(key: .selectedSleepNormalsPath, defaultValue: "builtin") var selectedSleepNormalsPath: String?


}

struct LabSettings {

    private static let defaultSleepNormalsFilename = "builtin"

    struct Keys {
        static let selectedSleepNormalsPath = "selectedSleepNormalsPath"
        static let preferredNormalSmoothing = "preferredNormalSmoothing"
        static let preferredNormalAlpha = "preferredNormalAlpha"
        static let preferredStagingSmoothing = "preferredStagingSmoothing"
        static let preferencesPage = "preferencesPage"

        static let isOverridingRange = "isOverridingRange"
        static let overrideRangeMin = "overrideRangeMin"
        static let overrideRangeMax = "overrideRangeMax"
    }

    static var preferredDocumentsURL: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}

// MARK: - Sleep Normals

extension LabSettings {

    static var selectedSleepNormalsURL: URL! {
        if let path = selectedSleepNormalsPath {
            return preferredDocumentsURL?.appendingPathComponent(path)
        }
        return Bundle.main.bundleURL.appendingPathComponent(defaultSleepNormalsFilename)
//        return Bundle.main.url(forResource: defaultSleepNormalsFilename, withExtension: "csv")
    }

    static var selectedSleepNormalsPath: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.selectedSleepNormalsPath)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.selectedSleepNormalsPath)
        }
    }

    static var preferredNormalSmoothing: Int {
        get {
            return max(1, UserDefaults.standard.integer(forKey: Keys.preferredNormalSmoothing))
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.preferredNormalSmoothing)
        }
    }

    static var preferredNormalAlpha: Float {
        get {
            return UserDefaults.standard.float(forKey: Keys.preferredNormalAlpha)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.preferredNormalAlpha)
        }
    }

    static var preferredStagingSmoothing: Int {
        get {
            return max(3, UserDefaults.standard.integer(forKey: Keys.preferredStagingSmoothing))
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.preferredStagingSmoothing)
        }
    }

    static var preferencesPage: Int {
        get {
            UserDefaults.standard.integer(forKey: Keys.preferencesPage)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.preferencesPage)
        }
    }

    static var isOverridingRange: Int {
        get {
            UserDefaults.standard.integer(forKey: Keys.isOverridingRange)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.isOverridingRange)
        }
    }

    static var overrideRange: Range<Float> {
        get {
            UserDefaults.standard.float(forKey: Keys.overrideRangeMin) ..<
                UserDefaults.standard.float(forKey: Keys.overrideRangeMax)
        }
        set {
            UserDefaults.standard.set(newValue.lowerBound, forKey: Keys.overrideRangeMin)
            UserDefaults.standard.set(newValue.upperBound, forKey: Keys.overrideRangeMax)
        }
    }
}
