//
//  SleepDesaturation.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/9/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct SleepDesaturation: RelativeTimeEvent, DomainObject {
    let started: Float
    let duration: Float

    let degreeMean: Float
    let degreeMax: Float
}

extension SleepDesaturation: GraphableRelativeTimeEvent {
    var yValue: Float { degreeMean }
}
