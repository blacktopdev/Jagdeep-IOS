//
//  SleepSystem.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/9/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct SleepSystem: DomainObject {
    let hasBaseline: Bool
    let alarmSecond: Int
    let isAlarmOn: Bool
}

extension SleepSystem: SimpleMocking {
    static var mock: SleepSystem = SleepSystem(hasBaseline: Bool.random(),
                                               alarmSecond: Int.random(in: 0..<3600*24),
                                               isAlarmOn: Bool.random())

    static var empty: SleepSystem = SleepSystem(hasBaseline: false,
                                                alarmSecond: -1,
                                                isAlarmOn: false)
}
