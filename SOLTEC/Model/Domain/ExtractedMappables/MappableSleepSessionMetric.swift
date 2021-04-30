//
//  MappableSleepSessionMetric.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/24/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct MappableSleepSessionMetric: Mappable {

    typealias StorableType = CoreSleepSessionMetric
    typealias DomainType = SleepSessionMetric
    typealias ConnectorType = CoreDataConnector

    let storableIdentifier: StorableType.IDType?
    let domain: DomainType

    init(domain: DomainType, storableIdentifier: StorableType.IDType? = nil) {
        self.storableIdentifier = storableIdentifier
        self.domain = domain
    }

    init(storable: StorableType) {
        storableIdentifier = storable.objectID
        domain = DomainType(recordDuration: storable.recordDuration,
                            sleepDuration: storable.sleepDuration,
                            sleepOnset: storable.sleepOnset,
                            cumulativeTime: MappableSleepStageMetric(storable: storable.cumulativeTime!).domain,
                            stagePulse: MappableSleepStageMetric(storable: storable.stagePulse!).domain,
                            stageO2: MappableSleepStageMetric(storable: storable.stageO2!).domain,
                            remEvent: MappableSleepEventMetric(storable: storable.remEvent!).domain,
                            lightEvent: MappableSleepEventMetric(storable: storable.lightEvent!).domain,
                            deltaEvent: MappableSleepEventMetric(storable: storable.deltaEvent!).domain)
    }

    func map(storable: StorableType, connector: ConnectorType) throws {
        storable.recordDuration = domain.recordDuration
        storable.sleepDuration = domain.sleepDuration
        storable.sleepOnset = domain.sleepOnset

        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepStageMetric(domain: domain.cumulativeTime),
                                                keyPath: \.cumulativeTime))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepStageMetric(domain: domain.stagePulse),
                                                keyPath: \.stagePulse))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepStageMetric(domain: domain.stageO2),
                                                keyPath: \.stageO2))

        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepEventMetric(domain: domain.remEvent),
                                                keyPath: \.remEvent))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepEventMetric(domain: domain.lightEvent),
                                                keyPath: \.lightEvent))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepEventMetric(domain: domain.deltaEvent),
                                                keyPath: \.deltaEvent))
    }
}
