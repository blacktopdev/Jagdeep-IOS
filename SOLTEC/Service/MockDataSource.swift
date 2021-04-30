//
//  MockDataSource.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/24/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

class MockDataSource {

    let sessionDuration: TimeInterval

    private var trendKeyMap: [String: [Double]] = [:]
    private var stageKeyMap: [String: [Double]] = [:]
    private var sessionKeyMap: [String: [Double]] = [:]
    private var eventKeyMap: [String: [ValueRelativeTimeEvent]] = [:]

    init(sessionDuration: TimeInterval = 8*3600) {
        self.sessionDuration = sessionDuration
    }

    func trendData(forKey key: String) -> [Double] {
        if let data = trendKeyMap[key] { return data }
        let data = MockDataSource.trendMetric(forDays: 365, range: 5..<100, jitter: 0.3)
        trendKeyMap[key] = data
        return data
    }

    func stageData(forKey key: String) -> [Double] {
        if let data = stageKeyMap[key] { return data }
        let data = MockDataSource.sessionMetric(sampleCount: max(2, Int(sessionDuration / 30)),
                                                range: -0.49..<3.2)
        stageKeyMap[key] = data.map { round($0) }
        return data
    }

    func sessionData(forKey key: String, range: Range<Double> = 0..<10, perHour: Double = 5) -> [Double] {
        if let data = sessionKeyMap[key] { return data }
        let sampleCount = max(2, Int(sessionDuration / 3600 * perHour))
        let data = MockDataSource.sessionMetric(sampleCount: sampleCount, range: range)
        sessionKeyMap[key] = data
        return data
    }

    func eventData(forKey key: String, range: Range<Double> = 0..<10, perHour: Double = 5) -> [ValueRelativeTimeEvent] {
        if let data = eventKeyMap[key] { return data }
        let data = MockDataSource.events(sessionDuration: sessionDuration,
                                         perHour: perHour, range: range)
        eventKeyMap[key] = data
        return data
    }

    private static func trendMetric(forDays days: Int, range: Range<Double>, jitter: Double) -> [Double] {
        let jitterAttenuate = 1 - jitter * 0.5

        return wave(freq: [16, 11, 4], amp: [0.5, 0.7, 1],
                    phase: [0.3, 0.6, 0.57], sampleCount: days).map { value in
            let uJ = value * jitterAttenuate
            let yJ = max(0, min(1, uJ + Double.random(in: 0..<jitter)))

            let y = range.lowerBound + yJ * (range.upperBound - range.lowerBound)
            return y
        }
    }

    private static func sessionMetric(sampleCount: Int, range: Range<Double>) -> [Double] {
        return wave(freq: [22, 5, 3], amp: [0.3, 1, 1],
                    phase: (0..<3).map { _ in Double.random(in: 0..<1) },
                    sampleCount: sampleCount).map { value in
            let y = range.lowerBound + value * (range.upperBound - range.lowerBound)
            return y
        }
    }

    private static func wave(freq: [Double], amp: [Double], phase: [Double], sampleCount: Int) -> [Double] {
        return (0..<sampleCount).map { index in
            let uX = Double(index) / Double(sampleCount - 1)

            let scaler = 1 / amp.reduce(0, +) / 2

            let uY = (0..<freq.count).reduce(0.0) { (result, index) in
                let partial = sin(phase[index] * 2 * .pi + uX * freq[index] * 2 * .pi)
                return result + (1 + partial) * amp[index]
            }

            return uY * scaler
        }
    }

    private static func events(sessionDuration: TimeInterval, perHour: Double,
                               range: Range<Double>) -> [ValueRelativeTimeEvent] {
        let envelope = MockDataSource.sessionMetric(sampleCount: 100, range: 0..<1)
        let eventCount = max(2, sessionDuration / 3600 * perHour)

        // distribute events per band in exponential fashion
        let passes = Int(floor(log2(eventCount)))
        let remainder = Int(eventCount - (pow(2, Double(passes)) - 1))
        var eventsPerBand: [Int] = (0..<passes).map { Int(pow(2, Double($0))) }
        // merge remainders
        for _ in (0..<remainder) {
            let band = Int(pow(Double.random(in: 0..<1), 0.5) * Double(passes))
            eventsPerBand[band] += 1
        }
        // distribute events
        return (0..<Int(eventCount)).reduce([ValueRelativeTimeEvent]()) { result, _ in
            let duration = min(sessionDuration - 1, Double.random(in: 5..<60))
            var offset: Double
            var band: Int
            repeat {
                offset = Double.random(in: 0..<(sessionDuration - duration))
                let envLevel = envelope[Int(offset / sessionDuration * 100)]
                band = Int(round(envLevel * Double(passes - 1)))
            } while eventsPerBand[band] == 0

            eventsPerBand[band] -= 1
            return result + [ValueRelativeTimeEvent(started: Float(offset), duration: Float(duration),
                                                    value: Float(Double.random(in: range)))]
        }.sorted { $0.started < $1.started }
    }
}
