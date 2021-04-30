//
//  SleepAggregateMetric.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/8/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct SleepAggregateMetric: DomainObject {
    let mean: Float
    let min: Float
    let max: Float
    let range: Float
}

extension SleepAggregateMetric: SimpleMocking {
    static let mock = SleepAggregateMetric(mean: Float.random(in: 0..<100),
                                           min: Float.random(in: 0..<100),
                                           max: Float.random(in: 0..<100),
                                           range: Float.random(in: 0..<100))

    static let empty = SleepAggregateMetric(mean: 0, min: 0, max: 0, range: 0)
}
