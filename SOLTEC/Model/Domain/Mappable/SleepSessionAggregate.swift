//
//  SleepSessionAggregate.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/12/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

typealias SleepSessionAggregate = SleepSignal<SleepAggregateMetric>

extension SleepSessionAggregate: SimpleMocking {
    static let mock = SleepSessionAggregate(veryLowPower: SleepAggregateMetric.mock,
                                            lowPower: SleepAggregateMetric.mock,
                                            highPower: SleepAggregateMetric.mock,
                                            veryLowPeak: SleepAggregateMetric.mock,
                                            lowPeak: SleepAggregateMetric.mock,
                                            highPeak: SleepAggregateMetric.mock,
                                            veryLowMean: SleepAggregateMetric.mock,
                                            lowMean: SleepAggregateMetric.mock,
                                            highMean: SleepAggregateMetric.mock,
                                            totalPower: SleepAggregateMetric.mock,
                                            highRatio: SleepAggregateMetric.mock,
                                            lowRatio: SleepAggregateMetric.mock,
                                            veryLowRatio: SleepAggregateMetric.mock,
                                            newBandRatio: SleepAggregateMetric.mock,
                                            pulseMean: SleepAggregateMetric.mock,
                                            pulseDeviation: SleepAggregateMetric.mock,
                                            o2Deviation: SleepAggregateMetric.mock,
                                            breathMean: SleepAggregateMetric.mock,
                                            breathDeviation: SleepAggregateMetric.mock,
                                            minuteVent: SleepAggregateMetric.mock)

    static let empty = SleepSessionAggregate(veryLowPower: SleepAggregateMetric.empty,
                                             lowPower: SleepAggregateMetric.empty,
                                             highPower: SleepAggregateMetric.empty,
                                             veryLowPeak: SleepAggregateMetric.empty,
                                             lowPeak: SleepAggregateMetric.empty,
                                             highPeak: SleepAggregateMetric.empty,
                                             veryLowMean: SleepAggregateMetric.empty,
                                             lowMean: SleepAggregateMetric.empty,
                                             highMean: SleepAggregateMetric.empty,
                                             totalPower: SleepAggregateMetric.empty,
                                             highRatio: SleepAggregateMetric.empty,
                                             lowRatio: SleepAggregateMetric.empty,
                                             veryLowRatio: SleepAggregateMetric.empty,
                                             newBandRatio: SleepAggregateMetric.empty,
                                             pulseMean: SleepAggregateMetric.empty,
                                             pulseDeviation: SleepAggregateMetric.empty,
                                             o2Deviation: SleepAggregateMetric.empty,
                                             breathMean: SleepAggregateMetric.empty,
                                             breathDeviation: SleepAggregateMetric.empty,
                                             minuteVent: SleepAggregateMetric.empty)
}
