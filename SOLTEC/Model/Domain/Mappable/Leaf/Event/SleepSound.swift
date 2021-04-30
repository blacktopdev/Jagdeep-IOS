//
//  SleepSound.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/9/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct SleepSound: RelativeTimeEvent, DomainObject {
    let started: Float
    let duration: Float

    let intensityMean: Float
    let frequencyMax: Float
}

extension SleepSound: GraphableRelativeTimeEvent {
    var yValue: Float { intensityMean }
}
