//
//  MappableSleepSessionAggregate.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/24/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct MappableSleepSessionAggregate: Mappable {

    typealias StorableType = CoreSleepSessionAggregate
    typealias DomainType = SleepSessionAggregate
    typealias ConnectorType = CoreDataConnector

    let storableIdentifier: StorableType.IDType?
    let domain: DomainType

    init(domain: DomainType, storableIdentifier: StorableType.IDType? = nil) {
        self.storableIdentifier = storableIdentifier
        self.domain = domain
    }

    init(storable: StorableType) {
        storableIdentifier = storable.objectID
        domain = DomainType(veryLowPower: MappableSleepAggregateMetric(storable: storable.veryLowPower!).domain,
                            lowPower: MappableSleepAggregateMetric(storable: storable.lowPower!).domain,
                            highPower: MappableSleepAggregateMetric(storable: storable.highPower!).domain,
                            veryLowPeak: MappableSleepAggregateMetric(storable: storable.veryLowPeak!).domain,
                            lowPeak: MappableSleepAggregateMetric(storable: storable.lowPeak!).domain,
                            highPeak: MappableSleepAggregateMetric(storable: storable.highPeak!).domain,
                            veryLowMean: MappableSleepAggregateMetric(storable: storable.veryLowMean!).domain,
                            lowMean: MappableSleepAggregateMetric(storable: storable.lowMean!).domain,
                            highMean: MappableSleepAggregateMetric(storable: storable.highMean!).domain,
                            totalPower: MappableSleepAggregateMetric(storable: storable.totalPower!).domain,
                            highRatio: MappableSleepAggregateMetric(storable: storable.highRatio!).domain,
                            lowRatio: MappableSleepAggregateMetric(storable: storable.lowRatio!).domain,
                            veryLowRatio: MappableSleepAggregateMetric(storable: storable.veryLowRatio!).domain,
                            newBandRatio: MappableSleepAggregateMetric(storable: storable.novelBandRatio!).domain,
                            pulseMean: MappableSleepAggregateMetric(storable: storable.pulseMean!).domain,
                            pulseDeviation: MappableSleepAggregateMetric(storable: storable.pulseDeviation!).domain,
                            o2Deviation: MappableSleepAggregateMetric(storable: storable.o2Deviation!).domain,
                            breathMean: MappableSleepAggregateMetric(storable: storable.breathMean!).domain,
                            breathDeviation: MappableSleepAggregateMetric(storable: storable.breathDeviation!).domain,
                            minuteVent: MappableSleepAggregateMetric(storable: storable.minuteVent!).domain)
    }

    func map(storable: StorableType, connector: ConnectorType) throws {
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepAggregateMetric(domain: domain.veryLowPower),
                                                keyPath: \.veryLowPower))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepAggregateMetric(domain: domain.lowPower),
                                                keyPath: \.lowPower))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepAggregateMetric(domain: domain.highPower),
                                                keyPath: \.highPower))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepAggregateMetric(domain: domain.veryLowPeak),
                                                keyPath: \.veryLowPeak))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepAggregateMetric(domain: domain.lowPeak),
                                                keyPath: \.lowPeak))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepAggregateMetric(domain: domain.highPeak),
                                                keyPath: \.highPeak))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepAggregateMetric(domain: domain.veryLowMean),
                                                keyPath: \.veryLowMean))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepAggregateMetric(domain: domain.lowMean),
                                                keyPath: \.lowMean))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepAggregateMetric(domain: domain.highMean),
                                                keyPath: \.highMean))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepAggregateMetric(domain: domain.totalPower),
                                                keyPath: \.totalPower))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepAggregateMetric(domain: domain.highRatio),
                                                keyPath: \.highRatio))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepAggregateMetric(domain: domain.lowRatio),
                                                keyPath: \.lowRatio))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepAggregateMetric(domain: domain.veryLowRatio),
                                                keyPath: \.veryLowRatio))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepAggregateMetric(domain: domain.newBandRatio),
                                                keyPath: \.novelBandRatio))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepAggregateMetric(domain: domain.pulseMean),
                                                keyPath: \.pulseMean))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepAggregateMetric(domain: domain.pulseDeviation),
                                                keyPath: \.pulseDeviation))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepAggregateMetric(domain: domain.o2Deviation),
                                                keyPath: \.o2Deviation))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepAggregateMetric(domain: domain.breathMean),
                                                keyPath: \.breathMean))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepAggregateMetric(domain: domain.breathDeviation),
                                                keyPath: \.breathDeviation))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepAggregateMetric(domain: domain.minuteVent),
                                                keyPath: \.minuteVent))
    }
}
