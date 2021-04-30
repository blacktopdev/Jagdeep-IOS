//
//  MappableSleepStream.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/24/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct MappableSleepStream: Mappable {

    typealias StorableType = CoreSleepStream
    typealias DomainType = SleepStream
    typealias ConnectorType = CoreDataConnector

    let storableIdentifier: StorableType.IDType?
    let domain: DomainType

    init(domain: DomainType, storableIdentifier: StorableType.IDType? = nil) {
        self.storableIdentifier = storableIdentifier
        self.domain = domain
    }

    init(storable: StorableType) {
        storableIdentifier = storable.objectID
        domain = DomainType(arousals: storable.arousalsArray?.map { MappableSleepArousal(storable: $0).domain } ?? [],
                            desaturations: storable.desaturationsArray?.map { MappableSleepDesaturation(storable: $0).domain } ?? [],
                            o2ses: storable.o2sesArray?.map { MappableSleepO2SE(storable: $0).domain } ?? [],
                            motions: storable.motionsArray?.map { MappableSleepMotion(storable: $0).domain } ?? [],
                            sounds: storable.soundsArray?.map { MappableSleepSound(storable: $0).domain } ?? [],
                            protocols: storable.protocolsArray?.map { MappableSleepProtocol(storable: $0).domain } ?? [])
    }

    func map(storable: StorableType, connector: ConnectorType) throws {
        try connector.connect(RelationshipToMany(parent: storable,
                                                 children: domain.arousals.map { MappableSleepArousal(domain: $0) },
                                                 keyPath: \.arousalsArray,
                                                 options: RelationshipOption.Preset.complete))
        try connector.connect(RelationshipToMany(parent: storable,
                                                 children: domain.desaturations.map { MappableSleepDesaturation(domain: $0) },
                                                 keyPath: \.desaturationsArray,
                                                 options: RelationshipOption.Preset.complete))
        try connector.connect(RelationshipToMany(parent: storable,
                                                 children: domain.o2ses.map { MappableSleepO2SE(domain: $0) },
                                                 keyPath: \.o2sesArray,
                                                 options: RelationshipOption.Preset.complete))
        try connector.connect(RelationshipToMany(parent: storable,
                                                 children: domain.motions.map { MappableSleepMotion(domain: $0) },
                                                 keyPath: \.motionsArray,
                                                 options: RelationshipOption.Preset.complete))
        try connector.connect(RelationshipToMany(parent: storable,
                                                 children: domain.sounds.map { MappableSleepSound(domain: $0) },
                                                 keyPath: \.soundsArray,
                                                 options: RelationshipOption.Preset.complete))
        try connector.connect(RelationshipToMany(parent: storable,
                                                 children: domain.protocols.map { MappableSleepProtocol(domain: $0) },
                                                 keyPath: \.protocolsArray,
                                                 options: RelationshipOption.Preset.complete))
    }
}

extension CoreSleepStream {
    var arousalsArray: [CoreSleepArousal]? {
        get { arousals?.array as? [CoreSleepArousal] }
        set { arousals = newValue != nil ? NSOrderedSet(array: newValue!) : nil }
    }

    var desaturationsArray: [CoreSleepDesaturation]? {
        get { return desaturations?.array as? [CoreSleepDesaturation]}
        set { desaturations = newValue != nil ? NSOrderedSet(array: newValue!) : nil }
    }

    var o2sesArray: [CoreSleepO2SE]? {
        get { return o2ses?.array as? [CoreSleepO2SE]}
        set { o2ses = newValue != nil ? NSOrderedSet(array: newValue!) : nil }
    }

    var motionsArray: [CoreSleepMotion]? {
        get { return motions?.array as? [CoreSleepMotion] }
        set { motions = newValue != nil ? NSOrderedSet(array: newValue!) : nil }
    }

    var soundsArray: [CoreSleepSound]? {
        get { return sounds?.array as? [CoreSleepSound] }
        set { sounds = newValue != nil ? NSOrderedSet(array: newValue!) : nil }
    }

    var protocolsArray: [CoreSleepProtocol]? {
        get { return protocols?.array as? [CoreSleepProtocol] }
        set { protocols = newValue != nil ? NSOrderedSet(array: newValue!) : nil }
    }
}
