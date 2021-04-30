//
//  SleepSession+Graph.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 3/15/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

extension SleepSession {
    func epochPointData(keyPath: KeyPath<SleepEpoch, Float>, inverted: Bool = false) -> [GraphStandardPoint] {
        let startSecond = started.timeIntervalSinceReferenceDate
        let result = epochs.enumerated().map { index, epoch in
            GraphStandardPoint(x: startSecond + TimeInterval(index * 30),
                               y: Double(epoch[keyPath: keyPath]))
        }
        return !inverted ? result : result.map { GraphStandardPoint(x: $0.x, y: -$0.y) }
    }

    func epochPointData(keyPath: KeyPath<SleepEpoch, Int>, inverted: Bool = false) -> [GraphStandardPoint] {
        let startSecond = started.timeIntervalSinceReferenceDate
        let result = epochs.enumerated().map { index, epoch in
            GraphStandardPoint(x: startSecond + TimeInterval(index * 30),
                               y: Double(epoch[keyPath: keyPath]))
        }
        return !inverted ? result : result.map { GraphStandardPoint(x: $0.x, y: -$0.y) }
    }

    /// Retrive event data points for the given `keyPath`, normalized to the 0...10 scale.
    func eventPointData<T: GraphableRelativeTimeEvent>(keyPath: KeyPath<SleepStream, [T]>,
                                                       inverted: Bool = false) -> [GraphStandardPoint] {
        let startSecond = started.timeIntervalSinceReferenceDate
        let events = stream[keyPath: keyPath]
        let maxMagnitude = Double(events.reduce(0) { max($0, abs($1.yValue)) })
        let result = events.map { event in
            GraphStandardPoint(x: startSecond + TimeInterval(event.started + event.stopped) / 2,
                               y: Double(event.yValue) / maxMagnitude * 10)
        }

        return !inverted ? result : result.map { GraphStandardPoint(x: $0.x, y: -$0.y) }
    }
}
