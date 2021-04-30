//
//  SleepO2SE.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/17/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct SleepO2SE: RelativeTimeEvent, DomainObject {
    let started: Float
    let duration: Float

    let degreeMean: Float
    let degreeMax: Float
}

extension SleepO2SE: GraphableRelativeTimeEvent {
    var yValue: Float { degreeMean }
}
