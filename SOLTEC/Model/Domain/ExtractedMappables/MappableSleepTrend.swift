//
//  MappableSleepTrend.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/24/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct MappableSleepTrend: Mappable {

    typealias StorableType = CoreSleepTrend
    typealias DomainType = SleepTrend
    typealias ConnectorType = CoreDataConnector

    let storableIdentifier: StorableType.IDType?
    let domain: DomainType

    init(domain: DomainType, storableIdentifier: StorableType.IDType? = nil) {
        self.storableIdentifier = storableIdentifier
        self.domain = domain
    }

    init(storable: StorableType) {
        storableIdentifier = storable.objectID
        domain = DomainType(
            stageAggregate: MappableSleepStageAggregate(storable: storable.stageAggregate!).domain,
            cumulativeTimes: storable.cumulativeTimesArray?.map { MappableSleepStageMetric(storable: $0).domain } ?? [],
            sessionAggregate: MappableSleepSessionAggregate(storable: storable.sessionAggregate!).domain,
            deltaHFPF: storable.deltaHFPF,
            epochCounts: storable.epochCounts ?? [])
    }

    func map(storable: StorableType, connector: ConnectorType) throws {
        storable.deltaHFPF = domain.deltaHFPF
        storable.epochCounts = domain.epochCounts //.map { Int32(0) }

        try connector.connect(RelationshipToMany(parent: storable,
                                                 children: domain.cumulativeTimes.map { MappableSleepStageMetric(domain: $0) },
                                                 keyPath: \.cumulativeTimesArray,
                                                 options: RelationshipOption.Preset.complete))
        
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepStageAggregate(domain: domain.stageAggregate),
                                                keyPath: \.stageAggregate))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepSessionAggregate(domain: domain.sessionAggregate),
                                                keyPath: \.sessionAggregate))
    }
}

extension CoreSleepTrend {
    var cumulativeTimesArray: [CoreSleepStageMetric]? {
        get { return cumulativeTimes?.array as? [CoreSleepStageMetric] ?? [] }
        set { cumulativeTimes = newValue != nil ? NSOrderedSet(array: newValue!) : nil }
    }
}
