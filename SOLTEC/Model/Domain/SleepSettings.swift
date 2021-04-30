//
//  SleepSettings.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 9/22/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import Foundation

/**
 The following are likely to be defined statically: TBD
 */

struct SleepSettings {

    let ins: IdealNormalSleepSetting

    let threshold: SleepSystemThreshold
}

struct SleepSystemThreshold {
    let motionLevel: Double
    let motionDuration: Double

    let actigraphyDuration: Double
    let micLevel: Double
    let micDuration: Double

    let oxygenArtifactLevel: Double
    let oxygenDuration: Double
    let desaturationLevel: Double

    let arousalLevel: Double
    let arousalDuration: Double

    let rangeArtifact: Double

    let slopeRange: Double
    let flatRange: Double
    let flatDuration: Double
}

struct IdealNormalSleepSetting {

    let deltaFR: Double
    let wakeFR: Double
    let wakeFRV: Double
    let wvRFR: Double
    let remFR: Double
    let remFRV: Double
    let remWvRFR: Double
    let remVLF: Double
    let remLF: Double
    let remPower: Double
    let remMV: Double
    let remO2SD: Double
}
