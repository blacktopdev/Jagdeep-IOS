//
//  SleepSignalType.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/14/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

enum SleepSignalType: SleepEnumerationType, CaseIterable, Codable {
    case veryLowPower
    case lowPower
    case highPower

    case veryLowPeak
    case lowPeak
    case highPeak

    case veryLowMean
    case lowMean
    case highMean

    case totalPower

    case highRatio
    case lowRatio
    case veryLowRatio
    case newBandRatio

    case pulseMean
    case pulseDeviation
    case o2Deviation
    case breathMean
    case breathDeviation
    case minuteVent
}
