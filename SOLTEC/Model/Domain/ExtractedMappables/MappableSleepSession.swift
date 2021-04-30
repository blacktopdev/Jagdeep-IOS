//
//  MappableSleepSession.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/24/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct MappableSleepSession: Mappable {

    typealias StorableType = CoreSleepSession
    typealias DomainType = SleepSession
    typealias ConnectorType = CoreDataConnector

    let storableIdentifier: StorableType.IDType?
    let domain: DomainType

    var findPredicate: NSPredicate? {
        NSPredicate(format: "%K==%@", "uuid", domain.uuid)
    }

    init(domain: DomainType, storableIdentifier: StorableType.IDType? = nil) {
        self.storableIdentifier = storableIdentifier
        self.domain = domain
    }

    init(storable: StorableType) {
        storableIdentifier = storable.objectID
        domain = DomainType(uuid: storable.uuid ?? "",
                            started: storable.started ?? Date(),
                            stopped: storable.stopped,
                            type: SleepSession.SessionType(rawValue: storable.type!) ?? .unknown,
                            appVersion: storable.appVersion ?? "",
                            deltaHFPF: storable.deltaHFPF,
                            score: MappableSleepScore(storable: storable.score!).domain,
                            metric: MappableSleepSessionMetric(storable: storable.metric!).domain,
                            stageAggregate: MappableSleepStageAggregate(storable: storable.stageAggregate!).domain,
                            sessionAggregate: MappableSleepSessionAggregate(storable: storable.sessionAggregate!).domain,
                            stream: MappableSleepStream(storable: storable.stream!).domain,
                            devices: storable.devicesArray?.map { MappableSleepDevice(storable: $0).domain } ?? [],
                            epochs: storable.epochsArray?.map { MappableSleepEpoch(storable: $0).domain } ?? [])
    }

    func map(storable: StorableType, connector: ConnectorType) throws {
        storable.uuid = domain.uuid
        storable.started = domain.started
        storable.stopped = domain.stopped
        storable.type = domain.type.rawValue
        storable.appVersion = domain.appVersion
        storable.deltaHFPF = domain.deltaHFPF

        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepScore(domain: domain.score),
                                                keyPath: \.score))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepSessionMetric(domain: domain.metric),
                                                keyPath: \.metric))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepStageAggregate(domain: domain.stageAggregate),
                                                keyPath: \.stageAggregate))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepSessionAggregate(domain: domain.sessionAggregate),
                                                keyPath: \.sessionAggregate))
        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepStream(domain: domain.stream),
                                                keyPath: \.stream))

        try connector.connect(RelationshipToMany(parent: storable,
                                                 children: domain.devices.map { MappableSleepDevice(domain: $0) },
                                                 keyPath: \.devicesArray,
                                                 options: RelationshipOption.Preset.additiveMerge))
        try connector.connect(RelationshipToMany(parent: storable,
                                                 children: domain.epochs.map { MappableSleepEpoch(domain: $0) },
                                                 keyPath: \.epochsArray,
                                                 options: RelationshipOption.Preset.complete))
    }
}

extension CoreSleepSession {
    var devicesArray: [CoreSleepDevice]? {
        get { return devices?.allObjects as? [CoreSleepDevice] ?? [] }
        set { devices = newValue != nil ? NSSet(array: newValue!) : nil }
    }

    var epochsArray: [CoreSleepEpoch]? {
        get { return epochs?.array as? [CoreSleepEpoch] ?? [] }
        set { epochs = newValue != nil ? NSOrderedSet(array: newValue!) : nil }
    }
}
