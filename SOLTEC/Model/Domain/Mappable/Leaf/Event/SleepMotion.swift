//
//  SleepMotion.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/9/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct SleepMotion: RelativeTimeEvent, DomainObject {
    let started: Float
    let duration: Float

    let intensityMean: Float
    let intensityMax: Float
}

extension SleepMotion: GraphableRelativeTimeEvent {
    var yValue: Float { intensityMean }
}
