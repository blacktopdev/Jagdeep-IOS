//
//  FakeDataSource.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/15/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import UIKit

struct FakeDataSource {
    static let shared = FakeDataSource()

    private let trendData: [Double]
    private let stageData: [Double]
    private let eventData: [[ValueRelativeTimeEvent]]
    private let mockSource = MockDataSource(sessionDuration: 8*3600)

    init() {
        trendData = mockSource.trendData(forKey: "td1")
        stageData = mockSource.stageData(forKey: "st1")
        eventData = [mockSource.eventData(forKey: "ev1", range: 0..<10, perHour: 8),
                     mockSource.eventData(forKey: "ev2", range: 0..<10, perHour: 8),
                     mockSource.eventData(forKey: "ev3", range: 0..<10, perHour: 8),
                     mockSource.eventData(forKey: "ev4", range: 0..<10, perHour: 8),
                     mockSource.eventData(forKey: "ev5", range: 0..<10, perHour: 8)]
//        eventData = [mockSource.sessionData(forKey: "ev1", range: -10..<10),
//                     mockSource.sessionData(forKey: "ev2", range: -10..<10),
//                     mockSource.sessionData(forKey: "ev3", range: -10..<10),
//                     mockSource.sessionData(forKey: "ev4", range: -10..<10),
//                     mockSource.sessionData(forKey: "ev5", range: -10..<10)]
    }

    func randomTrendData(range: Range<Int>, filterWidth: Int = 0) -> [GraphStandardPoint] {
        let count = min(trendData.count - 1, range.upperBound) - max(0, range.lowerBound)

        return SignalFilter.filtered(data: trendData[range].reversed().map { Float($0) },
                                     mode: .hann, width: filterWidth)
            .enumerated().map { index, value in
                GraphStandardPoint(x: Double(-count + 1 + index), y: Double(value))
            }
    }

    func randomStageData() -> [GraphStandardPoint] {
        let endDate = Date().timeIntervalSinceReferenceDate
        return stageData.enumerated().map { index, value in
            GraphStandardPoint(x: endDate + Double(-stageData.count + index) * Constants.epochInterval,
                               y: round(value))
        }
    }

    func randomEventData(set: Int) -> [GraphStandardPoint] {
        let startDate = Date().timeIntervalSinceReferenceDate - mockSource.sessionDuration
        return eventData[set].map { value in
            GraphStandardPoint(x: startDate + Double(value.started),
                               y: Double(value.value))
        }
    }
}
