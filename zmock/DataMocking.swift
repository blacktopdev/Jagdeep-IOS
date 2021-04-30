//
//  DataMocking.swift
//  zmock
//
//  Created by Jiropole on 2/26/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

protocol DataMocking {
    static func mocked(_ context: MockingContext) -> Self
}

let percentileRange: Range<Float> = 5..<100
let indexRange: Range<Float> = 2..<15
let countRange: Range<Int> = 2..<15
let defaultSessionDuration: TimeInterval = 6*3600

extension SleepSystem: DataMocking {
    static func mocked(_ context: MockingContext) -> SleepSystem {
        SleepSystem(hasBaseline: Bool.random(), alarmSecond: Int.random(in: 0..<3600*24), isAlarmOn: Bool.random())
    }
}

private var devices: [SleepDevice] = [.init(serialNumber: UUID().uuidString, revision: "3.3:2.4", status: .connected,
                                            batteryLevel: 60, error: nil, syncDate: nil),
                                      .init(serialNumber: UUID().uuidString, revision: "3.1:2.2", status: .connected,
                                            batteryLevel: 100, error: nil, syncDate: nil),
                                      .init(serialNumber: UUID().uuidString, revision: "3.0:2.0", status: .disconnected,
                                            batteryLevel: 22, error: nil, syncDate: nil)]
var nextDevice = 0

extension SleepDevice: DataMocking {
    static func mocked(_ context: MockingContext) -> SleepDevice {
        let device = devices[nextDevice]
        nextDevice = (nextDevice + 1) % 3
        return device
    }
}

extension SleepStageMetric: DataMocking {
    static func mocked(_ context: MockingContext) -> SleepStageMetric {
        var balance = (0..<4).map { _ in Float.random(in: 0.1..<0.9) }
        let scale = context.session.duration / balance.reduce(0, +)
        balance = balance.map { $0 * scale }
        return SleepStageMetric(wake: balance[0], rem: balance[1], light: balance[2], delta: balance[3])
    }
}

extension SleepAggregateMetric: DataMocking {
    static func mocked(_ context: MockingContext) -> SleepAggregateMetric {
        let min = Float.random(in: 5..<50)
        let max = Float.random(in: 50..<100)
        return SleepAggregateMetric(mean: (min + max) / 2, min: min, max: max, range: max - min)
    }
}

extension SleepSessionAggregate: DataMocking {
    static func mocked(_ context: MockingContext) -> SleepSessionAggregate {
        SleepSessionAggregate(veryLowPower: SleepAggregateMetric.mocked(context), lowPower: SleepAggregateMetric.mocked(context),
                              highPower: SleepAggregateMetric.mocked(context), veryLowPeak: SleepAggregateMetric.mocked(context),
                              lowPeak: SleepAggregateMetric.mocked(context), highPeak: SleepAggregateMetric.mocked(context),
                              veryLowMean: SleepAggregateMetric.mocked(context), lowMean: SleepAggregateMetric.mocked(context),
                              highMean: SleepAggregateMetric.mocked(context), totalPower: SleepAggregateMetric.mocked(context),
                              highRatio: SleepAggregateMetric.mocked(context), lowRatio: SleepAggregateMetric.mocked(context),
                              veryLowRatio: SleepAggregateMetric.mocked(context), newBandRatio: SleepAggregateMetric.mocked(context),
                              pulseMean: SleepAggregateMetric.mocked(context), pulseDeviation: SleepAggregateMetric.mocked(context),
                              o2Deviation: SleepAggregateMetric.mocked(context), breathMean: SleepAggregateMetric.mocked(context),
                              breathDeviation: SleepAggregateMetric.mocked(context), minuteVent: SleepAggregateMetric.mocked(context))
    }

    static func signalMocked(_ context: MockingContext) -> SleepSignal<Float> {
        SleepSignal<Float>(veryLowPower: Float.random(in: percentileRange), lowPower: Float.random(in: percentileRange),
                           highPower: Float.random(in: percentileRange), veryLowPeak: Float.random(in: percentileRange),
                           lowPeak: Float.random(in: percentileRange), highPeak: Float.random(in: percentileRange),
                           veryLowMean: Float.random(in: percentileRange), lowMean: Float.random(in: percentileRange),
                           highMean: Float.random(in: percentileRange), totalPower: Float.random(in: percentileRange),
                           highRatio: Float.random(in: percentileRange), lowRatio: Float.random(in: percentileRange),
                           veryLowRatio: Float.random(in: percentileRange), newBandRatio: Float.random(in: percentileRange),
                           pulseMean: Float.random(in: percentileRange), pulseDeviation: Float.random(in: percentileRange),
                           o2Deviation: Float.random(in: percentileRange), breathMean: Float.random(in: percentileRange),
                           breathDeviation: Float.random(in: percentileRange), minuteVent: Float.random(in: percentileRange))
    }
}

extension SleepStageMean: DataMocking {
    static func mocked(_ context: MockingContext) -> SleepStageMean {
        SleepStageMean(pulseMean: Float.random(in: percentileRange), pulseDeviation: Float.random(in: percentileRange),
                       o2Deviation: Float.random(in: percentileRange), veryLowPower: Float.random(in: percentileRange),
                       veryLowMean: Float.random(in: percentileRange), wakeRemDiff: Float.random(in: percentileRange),
                       veryLowRatio: Float.random(in: percentileRange))
    }
}

extension SleepEventMetric: DataMocking {
    static func mocked(_ context: MockingContext) -> SleepEventMetric {
        SleepEventMetric(arousalCount: Int(Float(context.events(forKey: "arousals").count) * Float.random(in: 0.125..<0.33)),
                         desatCount: Int(Float(context.events(forKey: "desats").count) * Float.random(in: 0.125..<0.33)),
                         o2seCount: Int(Float(context.events(forKey: "o2ses").count) * Float.random(in: 0.125..<0.33)),
                         motionCount: Int(Float(context.events(forKey: "motions").count) * Float.random(in: 0.125..<0.33)),
                         soundCount: Int(Float(context.events(forKey: "sounds").count) * Float.random(in: 0.125..<0.33)),
                         protocolCount: Int(Float(context.events(forKey: "protocols").count) * Float.random(in: 0.125..<0.33)))
    }
}

extension SleepStageAggregate: DataMocking {
    static func mocked(_ context: MockingContext) -> SleepStageAggregate {
        SleepStageAggregate(wakeMean: SleepStageMean.mocked(context), remMean: SleepStageMean.mocked(context),
                            lightMean: SleepStageMean.mocked(context), deltaMean: SleepStageMean.mocked(context))
    }
}

extension SleepTrend: DataMocking {
    static func mocked(_ context: MockingContext) -> SleepTrend {
        let epochs = context.session.epochs
        let limitedEpochs = min(context.root.sessionLimit, epochs)
        return SleepTrend(stageAggregate: SleepStageAggregate.mocked(context),
                          cumulativeTimes: (0..<limitedEpochs).map { _ in SleepStageMetric.mocked(context) },
                          sessionAggregate: SleepSessionAggregate.mocked(context),
                          deltaHFPF: Float.random(in: percentileRange),
                          epochCounts: (0..<min(50, limitedEpochs)).map { _ in Int.random(in: (epochs/2)..<epochs) })
    }
}

extension SleepStageResult: DataMocking {
    static func mocked(_ context: MockingContext) -> SleepStageResult {
        SleepStageResult(raw: context.stageValue(forKey: "resultRaw"),
                         filtered: context.stageValue(forKey: "resultFilt"),
                         final: context.stageValue(forKey: "resultfinal"),
                         realtime: context.stageValue(forKey: "resultRealtime"),
                         filteredCount: context.sequence.current / 6,
                         modifiedCount: context.sequence.current / 10)
    }
}

extension SleepEpoch: DataMocking {
    static func mocked(_ context: MockingContext) -> SleepEpoch {
        SleepEpoch(stage: SleepStageResult.mocked(context),
                   cumulativeTime: SleepStageMetric.mocked(context),
                   normal: SleepSessionAggregate.signalMocked(context),
                   pulseMean: context.sessionValue(forKey: "ep-pulseMean"),
                   pulseDeviation: context.sessionValue(forKey: "ep-pulseDev"),
                   o2Mean: context.sessionValue(forKey: "ep-o2Mean"),
                   o2Min: context.sessionValue(forKey: "ep-o2Min"),
                   o2Deviation: context.sessionValue(forKey: "ep-o2Dev"))
    }
}

extension SleepScore: DataMocking {
    static func mocked(_ context: MockingContext) -> SleepScore {
        SleepScore(overall: context.trendValue(forKey: "overall"),
                   duration: context.trendValue(forKey: "duration"),
                   delta: context.trendValue(forKey: "delta"),
                   rem: context.trendValue(forKey: "rem"),
                   latency: context.trendValue(forKey: "latency"),
                   efficiency: context.trendValue(forKey: "efficiency"),
                   o2seIndex: context.trendValue(forKey: "o2seIndex") * 0.1,
                   desatIndex: context.trendValue(forKey: "timeIndex") * 0.1,
                   arousalIndex: context.trendValue(forKey: "arousalIndex") * 0.1,
                   soundIndex: context.trendValue(forKey: "fragIndex") * 0.1)
    }
}

extension SleepSessionMetric: DataMocking {
    static func mocked(_ context: MockingContext) -> SleepSessionMetric {
        let record = context.session.duration
        let sleep = record * Float.random(in: 0.7..<0.98)
        return SleepSessionMetric(recordDuration: record,
                                  sleepDuration: sleep,
                                  sleepOnset: (record - sleep) * Float.random(in: 0.25..<0.75),
                                  cumulativeTime: SleepStageMetric.mocked(context),
                                  stagePulse: SleepStageMetric.mocked(context),
                                  stageO2: SleepStageMetric.mocked(context),
                                  remEvent: SleepEventMetric.mocked(context),
                                  lightEvent: SleepEventMetric.mocked(context),
                                  deltaEvent: SleepEventMetric.mocked(context))
    }
}

extension SleepStream: DataMocking {
    static func mocked(_ context: MockingContext) -> SleepStream {
        let arousals = context.events(forKey: "arousals")
            .map { SleepArousal(started: $0.started, duration: $0.duration,
                                pulseLow: context.sessionValue(forKey: "arousalsLow", uValue: $0.started / context.session.duration),
                                pulseHigh: context.sessionValue(forKey: "arousalsHigh", uValue: $0.started / context.session.duration)) }
        let desats = context.events(forKey: "desats")
            .map { SleepDesaturation(started: $0.started, duration: $0.duration,
                                     degreeMean: context.sessionValue(forKey: "desatsMean", uValue: $0.started / context.session.duration),
                                     degreeMax: context.sessionValue(forKey: "desatsMax", uValue: $0.started / context.session.duration)) }
        let o2ses = context.events(forKey: "o2ses")
            .map { SleepO2SE(started: $0.started, duration: $0.duration,
                             degreeMean: context.sessionValue(forKey: "o2sesMean", uValue: $0.started / context.session.duration),
                             degreeMax: context.sessionValue(forKey: "o2sesMax", uValue: $0.started / context.session.duration)) }
        let motions = context.events(forKey: "motions")
            .map { SleepMotion(started: $0.started, duration: $0.duration,
                               intensityMean: context.sessionValue(forKey: "motionsMean", uValue: $0.started / context.session.duration),
                               intensityMax: context.sessionValue(forKey: "motionsMax", uValue: $0.started / context.session.duration)) }
        let sounds = context.events(forKey: "sounds")
            .map { SleepSound(started: $0.started, duration: $0.duration,
                              intensityMean: context.sessionValue(forKey: "soundsMean", uValue: $0.started / context.session.duration),
                              frequencyMax: context.sessionValue(forKey: "soundsMax", uValue: $0.started / context.session.duration)) }
        let protocols = context.events(forKey: "protocols")
            .map { SleepProtocol(started: $0.started, duration: $0.duration,
                                 mField: Int.random(in: 1...5) * 100,
                                 parameters: "someMumboJumboJsonEscapedBase64EncodedBlobOrSimilar") }
        return SleepStream(arousals: arousals, desaturations: desats, o2ses: o2ses, motions: motions, sounds: sounds, protocols: protocols)
    }
}

extension SleepSession: DataMocking {
    static func mocked(_ context: MockingContext) -> SleepSession {
        SleepSession(uuid: UUID().uuidString, started: context.session.sessionDate,
                     stopped: context.session.sessionDate.addingTimeInterval(context.session.mockSource.sessionDuration),
                     type: .night, appVersion: "1.2.3", deltaHFPF: Float.random(in: percentileRange),
                     score: SleepScore.mocked(context),
                     metric: SleepSessionMetric.mocked(context),
                     stageAggregate: SleepStageAggregate.mocked(context),
                     sessionAggregate: SleepSessionAggregate.mocked(context),
                     stream: SleepStream.mocked(context),
                     devices: (0..<Int.random(in: 1...2)).map { _ in SleepDevice.mocked(context) },
                     epochs: epochs(context))
    }

    private static func epochs(_ context: MockingContext) -> [SleepEpoch] {
        let epochs = context.session.epochs
        return (0..<epochs).map { index in
            let subContext = context.inheriting(sequenceContext: MockingContext.Sequence(name: "\(entityName)",
                                                                                         current: index, count: epochs))
            return SleepEpoch.mocked(subContext)
        }
    }
}

extension User: DataMocking {
    static func mocked(_ context: MockingContext) -> User {
        User(uuid: "629EDDE3-DFE0-4A80-A4EB-1A2143C7F0AF"/*UUID().uuidString*/,
             system: SleepSystem.mocked(context), trend: SleepTrend.mocked(context),
             devices: (0..<2).map { _ in SleepDevice.mocked(context) },
             sessions: sessions(context),
             username: "suziQ", firstName: "Suzanne", lastName: "Skarsgård", email: "suziQ2343@hotmail.com",
             birthDate: Calendar.current.date(byAdding: .year, value: -Int.random(in: 13...96), to: Date()) ?? Date(),
             gender: .female, heightCm: 163, weightKg: 54)
    }

    private static func dateForSession(nightOffset: Int) -> Date {
        let roughDate = Calendar.current.date(byAdding: .day, value: nightOffset-2, to: Date()) ?? Date()
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: roughDate)
        let midnight = Calendar.current.date(from: comps) ?? Date()
        let secondInDay = TimeInterval.random(in: (20*3600)...(26*3600))
        return midnight.addingTimeInterval(secondInDay)
    }

    private static func sessions(_ context: MockingContext) -> [SleepSession] {
        (0..<context.root.sessionLimit).map { index in
            let maxDuration = min(Double(context.root.epochLimit * 30), 10*3600)
            let duration = max(30*4, TimeInterval.random(in: (maxDuration * 0.4)..<maxDuration))
            let dataSource = MockDataSource(sessionDuration: duration)
            let sessionDate = dateForSession(nightOffset: -context.root.sessionLimit + 1 + index)
            let sessionContext = MockingContext.Session(sessionDate: sessionDate,
                                                        mockSource: dataSource,
                                                        current: index, count: context.root.sessionLimit)
            let sequenceContext = MockingContext.Sequence(name: "\(entityName)\(index)", current: 0, count: 0)
            let subContext = context.inheriting(sessionContext: sessionContext, sequenceContext: sequenceContext)
            return SleepSession.mocked(subContext)
        }
    }
}
