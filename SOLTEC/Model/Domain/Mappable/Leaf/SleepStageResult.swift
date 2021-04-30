//
//  SleepStageResult.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/9/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct SleepStageResult: DomainObject {
    let raw: SleepStageType
    let filtered: SleepStageType
    let final: SleepStageType
    let realtime: SleepStageType
    let filteredCount: Int
    let modifiedCount: Int
}

extension SleepStageResult: SimpleMocking {
    static let mock = SleepStageResult(raw: .delta, filtered: .rem, final: .wake, realtime: .rem,
                                       filteredCount: Int.random(in: 0..<20),
                                       modifiedCount: Int.random(in: 20..<40))

    static let empty = mock
}
