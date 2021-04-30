//
//  SleepScore.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/12/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

enum SleepScoreType {
    case overall
    case time
    case delta
    case rem
    case latency
    case efficiency
    case o2seIndex
}

struct SleepScore: DomainObject {
    let overall: Float
    let duration: Float
    let delta: Float
    let rem: Float
    let latency: Float
    let efficiency: Float
    let o2seIndex: Float
    let desatIndex: Float
    let arousalIndex: Float
    let soundIndex: Float

    static let o2seRange: Range<Float> = 0..<6
}

extension SleepScore: SimpleMocking {
    static let mock = SleepScore(overall: Float.random(in: 0..<100),
                                 duration: Float.random(in: 0..<100),
                                 delta: Float.random(in: 0..<100),
                                 rem: Float.random(in: 0..<100),
                                 latency: Float.random(in: 0..<100),
                                 efficiency: Float.random(in: 0..<100),
                                 o2seIndex: Float.random(in: 0..<10),
                                 desatIndex: Float.random(in: 0..<10),
                                 arousalIndex: Float.random(in: 0..<10),
                                 soundIndex: Float.random(in: 0..<10))

    static let empty = SleepScore(overall: 0, duration: 0, delta: 0, rem: 0, latency: 0,
                                  efficiency: 0, o2seIndex: 0, desatIndex: 0, arousalIndex: 0, soundIndex: 0)
}

