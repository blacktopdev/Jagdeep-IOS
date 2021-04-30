//
//  SleepStageAggregate.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/12/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct SleepStageAggregate: DomainObject {
    let wakeMean: SleepStageMean
    let remMean: SleepStageMean
    let lightMean: SleepStageMean
    let deltaMean: SleepStageMean
}

extension SleepStageAggregate: SimpleMocking {
    static let mock = SleepStageAggregate(wakeMean: SleepStageMean.mock,
                                          remMean: SleepStageMean.mock,
                                          lightMean: SleepStageMean.mock,
                                          deltaMean: SleepStageMean.mock)

    static let empty = SleepStageAggregate(wakeMean: SleepStageMean.empty,
                                           remMean: SleepStageMean.empty,
                                           lightMean: SleepStageMean.empty,
                                           deltaMean: SleepStageMean.empty)
}
