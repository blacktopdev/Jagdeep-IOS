//
//  MappableSleepMotion.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/24/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct MappableSleepMotion: Mappable {

    typealias StorableType = CoreSleepMotion
    typealias DomainType = SleepMotion
    typealias ConnectorType = CoreDataConnector

    let storableIdentifier: StorableType.IDType?
    let domain: DomainType

    init(domain: DomainType, storableIdentifier: StorableType.IDType? = nil) {
        self.storableIdentifier = storableIdentifier
        self.domain = domain
    }

    init(storable: StorableType) {
        storableIdentifier = storable.objectID
        domain = DomainType(started: storable.started,
                            duration: storable.duration,
                            intensityMean: storable.intensityMean,
                            intensityMax: storable.intensityMax)
    }

    func map(storable: StorableType, connector: ConnectorType) throws {
        storable.started = domain.started
        storable.duration = domain.duration
        storable.intensityMean = domain.intensityMean
        storable.intensityMax = domain.intensityMax
    }
}
