//
//  SleepStageMetric.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/9/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct SleepStageMetric: DomainObject {
    let wake: Float
    let rem: Float
    let light: Float
    let delta: Float
}

extension SleepStageMetric: SimpleMocking {
    static let mock = SleepStageMetric(wake: Float.random(in: 30*60..<4*3600),
                                       rem: Float.random(in: 30*60..<4*3600),
                                       light: Float.random(in: 30*60..<4*3600),
                                       delta: Float.random(in: 30*60..<4*3600))

    static let empty = SleepStageMetric(wake: 0, rem: 0, light: 0, delta: 0)
}
