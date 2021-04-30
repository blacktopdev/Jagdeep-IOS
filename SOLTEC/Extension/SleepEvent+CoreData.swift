//
//  SleepEvent+CoreData.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 9/24/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import Foundation

extension SleepEvent {

    init(coreEvent: CoreSleepEvent) {
        type = EventType(rawValue: Int(coreEvent.type)) ?? .unknown

        switch type {
        case .stage:
            value = Stage(rawValue: Int(coreEvent.scalar)) ?? .unknown
        case .position:
            value = Position(rawValue: Int(coreEvent.scalar)) ?? .unknown
        case .intervention:
            value = Intervention(rawValue: Int(coreEvent.scalar)) ?? .unknown
        default:
            value = coreEvent.scalar
        }

        started = coreEvent.started
        stopped = coreEvent.stopped
    }
}
