//
//  SleepGraphpreferences.swift
//  SOLTEC•Lab
//
//  Created by Jiropole on 11/23/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import Foundation

class SleepLabPreferences: ObservableObject {

    struct Staging {
        var displayMode: StageFilter.StagingMode
        var filterMode: StageFilter.FilterMode
        var filterWidth: Int
        var motionAffectsStaging: Bool
    }

    struct Motion {
        var enabled: Bool
        var rawMode: Bool
    }

    struct Normal {
        var filterWidth: Int
        var filterAlpha: Float
        var filterMode: SignalFilter.Mode
        var selectedTypes: Set<SleepSignalType>
        var isNormalized: Bool
        var isOverridingRange: Bool
        var overrideMin: Float
        var overrideMax: Float

        var showWakeRemLevel: Bool
        var showWakeLevel: Bool
        var showRemLevel: Bool

        mutating func reset() {
            selectedTypes.removeAll()
        }
    }

    private static var normalAlpha: Float {
        LabSettings.preferredNormalAlpha > 0 ? LabSettings.preferredNormalAlpha : 0.25
    }

    @Published var staging = Staging(displayMode: .filtered, filterMode: .hann,
                                     filterWidth: LabSettings.preferredStagingSmoothing,
                                     motionAffectsStaging: true)

    @Published var motion = Motion(enabled: true, rawMode: false)

    @Published var normal = Normal(filterWidth: LabSettings.preferredNormalSmoothing,
                                   filterAlpha: normalAlpha,
                                   filterMode: .lowpass,
                                   selectedTypes: [.veryLowPower],
                                   isNormalized: true,
                                   isOverridingRange: false,
                                   overrideMin: LabSettings.overrideRange.lowerBound,
                                   overrideMax: LabSettings.overrideRange.upperBound,
                                   showWakeRemLevel: true, showWakeLevel: true, showRemLevel: true)

    func reset() {
        normal.reset()
    }
}
