//
//  SleepEpoch.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 9/30/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct SleepEpoch: DomainObject {
    let stage: SleepStageResult
    let cumulativeTime: SleepStageMetric
    let normal: SleepSignal<Float>

    let pulseMean: Float
    let pulseDeviation: Float
    let o2Mean: Float
    let o2Min: Float
    let o2Deviation: Float
}

extension SleepEpoch: SimpleMocking {
    static let mock = SleepEpoch(stage: SleepStageResult.mock,
                                 cumulativeTime: SleepStageMetric.mock,
                                 normal: SleepSignal(veryLowPower: Float.random(in: 0..<100), lowPower: Float.random(in: 0..<100), highPower: Float.random(in: 0..<100), veryLowPeak: Float.random(in: 0..<100), lowPeak: Float.random(in: 0..<100), highPeak: Float.random(in: 0..<100), veryLowMean: Float.random(in: 0..<100), lowMean: Float.random(in: 0..<100), highMean: Float.random(in: 0..<100), totalPower: Float.random(in: 0..<100), highRatio: Float.random(in: 0..<100), lowRatio: Float.random(in: 0..<100), veryLowRatio: Float.random(in: 0..<100), newBandRatio: Float.random(in: 0..<100), pulseMean: Float.random(in: 0..<100), pulseDeviation: Float.random(in: 0..<100), o2Deviation: Float.random(in: 0..<100), breathMean: Float.random(in: 0..<100), breathDeviation: Float.random(in: 0..<100), minuteVent: Float.random(in: 0..<100)),
                                 pulseMean: Float.random(in: 0..<100),
                                 pulseDeviation: Float.random(in: 0..<100),
                                 o2Mean: Float.random(in: 0..<100),
                                 o2Min: Float.random(in: 0..<100),
                                 o2Deviation: Float.random(in: 0..<100))

    static let empty = SleepEpoch(stage: SleepStageResult.empty,
                                  cumulativeTime: SleepStageMetric.empty,
                                  normal: SleepSignal(veryLowPower: 0, lowPower: 0, highPower: 0, veryLowPeak: 0, lowPeak: 0, highPeak: 0, veryLowMean: 0, lowMean: 0, highMean: 0, totalPower: 0, highRatio: 0, lowRatio: 0, veryLowRatio: 0, newBandRatio: 0, pulseMean: 0, pulseDeviation: 0, o2Deviation: 0, breathMean: 0, breathDeviation: 0, minuteVent: 0),
                                  pulseMean: 0,
                                  pulseDeviation: 0,
                                  o2Mean: 0,
                                  o2Min: 0,
                                  o2Deviation: 0)
}
