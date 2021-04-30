//
//  MappableSleepStageMetric.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/24/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct MappableSleepStageMetric: Mappable {

    typealias StorableType = CoreSleepStageMetric
    typealias DomainType = SleepStageMetric
    typealias ConnectorType = CoreDataConnector

    let storableIdentifier: StorableType.IDType?
    let domain: DomainType

    init(domain: DomainType, storableIdentifier: StorableType.IDType? = nil) {
        self.storableIdentifier = storableIdentifier
        self.domain = domain
    }

    init(storable: StorableType) {
        storableIdentifier = storable.objectID
        domain = DomainType(wake: storable.wake,
                            rem: storable.rem,
                            light: storable.light,
                            delta: storable.delta)
    }

    func map(storable: StorableType, connector: ConnectorType) throws {
        storable.wake = domain.wake
        storable.rem = domain.rem
        storable.light = domain.light
        storable.delta = domain.delta
    }
}
