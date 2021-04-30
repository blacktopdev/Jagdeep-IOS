//
//  SleepSignal.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 9/30/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import Foundation

/// Represents a generic set of key data points.
struct SleepSignal<T: DomainObject>: DomainObject {

    let veryLowPower: T
    let lowPower: T
    let highPower: T

    let veryLowPeak: T
    let lowPeak: T
    let highPeak: T

    let veryLowMean: T
    let lowMean: T
    let highMean: T

    let totalPower: T

    let highRatio: T
    let lowRatio: T
    let veryLowRatio: T
    let newBandRatio: T

    let pulseMean: T
    let pulseDeviation: T
    let o2Deviation: T
    let breathMean: T
    let breathDeviation: T
    let minuteVent: T

    func value(forType type: SleepSignalType) -> T {
        switch type {
        case .veryLowPower:
            return veryLowPower
        case .lowPower:
            return lowPower
        case .highPower:
            return highPower
        case .veryLowPeak:
            return veryLowPeak
        case .lowPeak:
            return lowPeak
        case .highPeak:
            return highPeak
        case .veryLowMean:
            return veryLowMean
        case .lowMean:
            return lowMean
        case .highMean:
            return highMean
        case .totalPower:
            return totalPower
        case .highRatio:
            return highRatio
        case .lowRatio:
            return lowRatio
        case .veryLowRatio:
            return veryLowRatio
        case .newBandRatio:
            return newBandRatio
        case .pulseMean:
            return pulseMean
        case .pulseDeviation:
            return pulseDeviation
        case .o2Deviation:
            return o2Deviation
        case .breathMean:
            return breathMean
        case .breathDeviation:
            return breathDeviation
        case .minuteVent:
            return minuteVent
        }
    }
}
