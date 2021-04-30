//
//  MappableSleepEpoch.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/24/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct MappableSleepEpoch: Mappable {

    typealias StorableType = CoreSleepEpoch
    typealias DomainType = SleepEpoch
    typealias ConnectorType = CoreDataConnector

    let storableIdentifier: StorableType.IDType?
    let domain: DomainType

    init(domain: DomainType, storableIdentifier: StorableType.IDType? = nil) {
        self.storableIdentifier = storableIdentifier
        self.domain = domain
    }

    init(storable: StorableType) {
        storableIdentifier = storable.objectID
        domain = DomainType(stage: MappableSleepStageResult(storable: storable.stage!).domain,
                            cumulativeTime: MappableSleepStageMetric(storable: storable.cumulativeTime!).domain,
                            normal: MappableSleepSignal(storable: storable.normal!).domain,
                            pulseMean: storable.pulseMean,
                            pulseDeviation: storable.pulseDeviation,
                            o2Mean: storable.o2Mean,
                            o2Min: storable.o2Min,
                            o2Deviation: storable.o2Deviation)
    }

    func map(storable: StorableType, connector: ConnectorType) throws {
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepStageResult(domain: domain.stage),
                                                keyPath: \.stage))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepStageMetric(domain: domain.cumulativeTime),
                                                keyPath: \.cumulativeTime))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepSignal(domain: domain.normal),
                                                keyPath: \.normal))

        storable.pulseMean = domain.pulseMean
        storable.pulseDeviation = domain.pulseDeviation
        storable.o2Mean = domain.o2Mean
        storable.o2Min = domain.o2Min
        storable.o2Deviation = domain.o2Deviation
    }
}
