//
//  MappableSleepStageAggregate.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/24/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct MappableSleepStageAggregate: Mappable {

    typealias StorableType = CoreSleepStageAggregate
    typealias DomainType = SleepStageAggregate
    typealias ConnectorType = CoreDataConnector

    let storableIdentifier: StorableType.IDType?
    let domain: DomainType

    init(domain: DomainType, storableIdentifier: StorableType.IDType? = nil) {
        self.storableIdentifier = storableIdentifier
        self.domain = domain
    }

    init(storable: StorableType) {
        storableIdentifier = storable.objectID
        domain = DomainType(wakeMean: MappableSleepStageMean(storable: storable.wakeMean!).domain,
                            remMean: MappableSleepStageMean(storable: storable.remMean!).domain,
                            lightMean: MappableSleepStageMean(storable: storable.lightMean!).domain,
                            deltaMean: MappableSleepStageMean(storable: storable.deltaMean!).domain)
    }

    func map(storable: StorableType, connector: ConnectorType) throws {
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepStageMean(domain: domain.wakeMean),
                                                keyPath: \.wakeMean))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepStageMean(domain: domain.remMean),
                                                keyPath: \.remMean))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepStageMean(domain: domain.lightMean),
                                                keyPath: \.lightMean))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepStageMean(domain: domain.deltaMean),
                                                keyPath: \.deltaMean))
    }
}
