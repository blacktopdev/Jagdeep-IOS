//
//  MappableSleepO2SE.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/24/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct MappableSleepO2SE: Mappable {

    typealias StorableType = CoreSleepO2SE
    typealias DomainType = SleepO2SE
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
                            degreeMean: storable.degreeMean,
                            degreeMax: storable.degreeMax)
    }

    func map(storable: StorableType, connector: ConnectorType) throws {
        storable.started = domain.started
        storable.duration = domain.duration
        storable.degreeMean = domain.degreeMean
        storable.degreeMax = domain.degreeMax
    }
}
