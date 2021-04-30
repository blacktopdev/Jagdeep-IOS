//
//  MappableSleepAggregateMetric.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/24/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct MappableSleepAggregateMetric: Mappable {

    typealias StorableType = CoreSleepAggregateMetric
    typealias DomainType = SleepAggregateMetric
    typealias ConnectorType = CoreDataConnector

    let storableIdentifier: StorableType.IDType?
    let domain: DomainType

    init(domain: DomainType, storableIdentifier: StorableType.IDType? = nil) {
        self.storableIdentifier = storableIdentifier
        self.domain = domain
    }

    init(storable: StorableType) {
        storableIdentifier = storable.objectID
        domain = DomainType(mean: storable.mean,
                            min: storable.min,
                            max: storable.max,
                            range: storable.range)
    }

    func map(storable: StorableType, connector: ConnectorType) throws {
        storable.mean = domain.mean
        storable.min = domain.min
        storable.max = domain.max
        storable.range = domain.range
    }
}
