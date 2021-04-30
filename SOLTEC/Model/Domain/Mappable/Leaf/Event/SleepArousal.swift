//
//  SleepArousal.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/9/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct SleepArousal: RelativeTimeEvent, DomainObject {
    let started: Float
    let duration: Float

    let pulseLow: Float
    let pulseHigh: Float
}

extension SleepArousal: GraphableRelativeTimeEvent {
    var yValue: Float { (pulseLow + pulseHigh) * 0.5 }
}
