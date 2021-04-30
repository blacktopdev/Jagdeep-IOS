//
//  MappableSleepScore.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/24/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct MappableSleepScore: Mappable {

    typealias StorableType = CoreSleepScore
    typealias DomainType = SleepScore
    typealias ConnectorType = CoreDataConnector

    let storableIdentifier: StorableType.IDType?
    let domain: DomainType

    init(domain: DomainType, storableIdentifier: StorableType.IDType? = nil) {
        self.storableIdentifier = storableIdentifier
        self.domain = domain
    }

    init(storable: StorableType) {
        storableIdentifier = storable.objectID
        domain = DomainType(overall: storable.overall,
                            duration: storable.duration,
                            delta: storable.delta,
                            rem: storable.rem,
                            latency: storable.latency,
                            efficiency: storable.efficiency,
                            o2seIndex: storable.o2seIndex,
                            desatIndex: storable.desatIndex,
                            arousalIndex: storable.arousalIndex,
                            soundIndex: storable.soundIndex)
    }

    func map(storable: StorableType, connector: ConnectorType) throws {
        storable.overall = domain.overall
        storable.duration = domain.duration
        storable.delta = domain.delta
        storable.rem = domain.rem
        storable.latency = domain.latency
        storable.efficiency = domain.efficiency
        storable.o2seIndex = domain.o2seIndex
        storable.desatIndex = domain.desatIndex
        storable.arousalIndex = domain.arousalIndex
        storable.soundIndex = domain.soundIndex
    }
}
