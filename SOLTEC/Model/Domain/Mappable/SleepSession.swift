//
//  SleepSession.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 9/10/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import Foundation

/// Container for data related to a single night's sleep.
struct SleepSession: AbsoluteTimeEvent, DomainObject {

    enum SessionType: SleepEnumerationType, Codable {
        case night
        case nap
        case unknown
    }

    let uuid: String
    let started: Date
    let stopped: Date?
    let type: SessionType
    let appVersion: String
    let deltaHFPF: Float

    let score: SleepScore
    let metric: SleepSessionMetric
    let stageAggregate: SleepStageAggregate
    let sessionAggregate: SleepSignal<SleepAggregateMetric>
    let stream: SleepStream
    let devices: [SleepDevice]
    let epochs: [SleepEpoch]
}

extension SleepSession: SimpleMocking {
    static let mock: SleepSession = SleepSession(uuid: "mock",
                                                 started: Date(), stopped: nil,
                                                 type: .night,
                                                 appVersion: "0.8.1",
                                                 deltaHFPF: Float.random(in: 0..<100),
                                                 score: SleepScore.mock,
                                                 metric: SleepSessionMetric.mock,
                                                 stageAggregate: SleepStageAggregate.mock,
                                                 sessionAggregate: SleepSessionAggregate.mock,
                                                 stream: SleepStream.mock,
                                                 devices: [SleepDevice.mock],
                                                 epochs: [SleepEpoch.mock])
}

extension SleepSession {
    static let empty = SleepSession(uuid: "empty", started: Date(), stopped: nil,
                                                  type: .night, appVersion: "0.8.1", deltaHFPF: 0,
                                                  score: SleepScore.empty,
                                                  metric: SleepSessionMetric.empty,
                                                  stageAggregate: SleepStageAggregate.empty,
                                                  sessionAggregate: SleepSessionAggregate.empty,
                                                  stream: SleepStream.empty,
                                                  devices: [], epochs: [])
}
