//
//  MockingContext.swift
//  zmock
//
//  Created by Jiropole on 2/26/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct MockingContext {
    struct Root {
        let outputFile: String
        let sessionLimit: Int
        let epochLimit: Int
        let mockSource: MockDataSource
    }

    struct Session {
        let sessionDate: Date
        let mockSource: MockDataSource
        let current: Int
        let count: Int

        var epochs: Int { Int(duration / 30) }
        var duration: Float { Float(mockSource.sessionDuration) }
    }

    struct Sequence {
        let name: String
        let current: Int
        let count: Int
    }

    let root: Root
    let session: Session
    let sequence: Sequence
}

extension MockingContext {
    
    init(args: [String]) {
        func intArgAt(_ index: Int) -> Int { index < args.count ? Int(args[index]) ?? 0 : 0 }

        var outputFile = args.count > 0 ? args[0] : "zmock_out.json"
        if !outputFile.hasSuffix(".json") {
            outputFile += ".json"
        }
        self.root = MockingContext.Root(outputFile: outputFile,
                                        sessionLimit: max(1, intArgAt(1)),
                                        epochLimit: max(4, min(1200, intArgAt(2))),
                                        mockSource: MockDataSource(sessionDuration: 0))
        self.session = MockingContext.Session(sessionDate: Date(),
                                              mockSource: MockDataSource(sessionDuration: 8*3600),
                                              current: 0, count: 0)
        self.sequence =  MockingContext.Sequence(name: "root", current: 0, count: 0)
    }

    func inheriting(sessionContext: Session? = nil, sequenceContext: Sequence? = nil) -> MockingContext {
        let seqCtx: Sequence
        if let sq = sequenceContext {
            seqCtx = Sequence(name: "\(sequence.name).\(sq.name)", current: sq.current, count: sq.count)
        } else {
            seqCtx = sequence
        }
        return MockingContext(root: root, session: sessionContext ?? session, sequence: seqCtx)
    }

    func trendValue(forKey key: String) -> Float {
        Float(root.mockSource.trendData(forKey: key)[session.current])
//        let result = Float(root.mockSource.trendData(forKey: key)[session.current])
//        if key == "overall" {
//            print("overall: \(result)")
//        }
//        return result
    }

    func stageValue(forKey key: String) -> SleepStageType {
        let value = session.mockSource.stageData(forKey: "\(sequence.name)-\(key)")[sequence.current]
        return SleepStageType.type(forLevel: Int(round(value)))
    }

    func sessionValue(forKey key: String, uValue: Float? = nil) -> Float {
        let data = session.mockSource.sessionData(forKey: "\(sequence.name)-\(key)", range: 0..<100, perHour: 3600/30)
        let index = uValue != nil ? Int(uValue! * Float(data.count)) : sequence.current
        return Float(data[index])
    }

    func events(forKey key: String, range: Range<Double> = 0..<10, perHour: Double? = nil) -> [ValueRelativeTimeEvent] {
        let perHour = perHour ?? Double.random(in: 3..<18)
        return session.mockSource.eventData(forKey: "\(sequence.name)-\(key)", range: range, perHour: perHour)
    }

}
