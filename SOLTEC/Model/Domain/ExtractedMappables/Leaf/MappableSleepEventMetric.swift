//
//  MappableSleepWakeMetric.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/24/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct MappableSleepEventMetric: Mappable {

    typealias StorableType = CoreSleepEventMetric
    typealias DomainType = SleepEventMetric
    typealias ConnectorType = CoreDataConnector

    let storableIdentifier: StorableType.IDType?
    let domain: DomainType

    init(domain: DomainType, storableIdentifier: StorableType.IDType? = nil) {
        self.storableIdentifier = storableIdentifier
        self.domain = domain
    }

    init(storable: StorableType) {
        storableIdentifier = storable.objectID
        domain = DomainType(arousalCount: Int(storable.arousalCount),
                            desatCount: Int(storable.desatCount),
                            o2seCount: Int(storable.o2seCount),
                            motionCount: Int(storable.motionCount),
                            soundCount: Int(storable.soundCount),
                            protocolCount: Int(storable.protocolCount))
    }

    func map(storable: StorableType, connector: ConnectorType) throws {
        storable.arousalCount = Int16(domain.arousalCount)
        storable.desatCount = Int16(domain.desatCount)
        storable.o2seCount = Int16(domain.o2seCount)
        storable.motionCount = Int16(domain.motionCount)
        storable.soundCount = Int16(domain.soundCount)
        storable.protocolCount = Int16(domain.protocolCount)
    }
}
