//
//  SleepProtocol.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/9/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct SleepProtocol: RelativeTimeEvent, DomainObject {
    /// An enumeration of interventions for event type `intervention`.
    enum ProtocolType: SleepEnumerationType, Codable {
        case unknown
        case induction
        case deltaDive
        case deltaFlat
        case remRise
        case remFlat
    }

    let started: Float
    let duration: Float

    let mField: Int
    let parameters: String?
}

extension SleepProtocol: GraphableRelativeTimeEvent {
    var yValue: Float { Float(mField) }
}
