//
//  MappableUser.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/24/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct MappableUser: Mappable {

    typealias StorableType = CoreUser
    typealias DomainType = User
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
                            system: MappableSleepSystem(storable: storable.system!).domain,
                            trend: storable.trend != nil ? MappableSleepTrend(storable: storable.trend!).domain : nil,
                            devices: storable.devicesArray?.map { MappableSleepDevice(storable: $0).domain } ?? [],
                            // We choose not to load all sessions at once
                            sessions: [] /*storable.sessionsArray?.map { MappableSleepSession(storable: $0).domain } ??*/,
                            username: storable.username,
                            firstName: storable.firstName,
                            lastName: storable.lastName,
                            email: storable.email,
                            birthDate: storable.birthDate,
                            gender: User.Gender(rawValue: storable.gender ?? "") ?? .undeclared,
                            heightCm: storable.heightCm,
                            weightKg: storable.weightKg)
    }

    func map(storable: StorableType, connector: ConnectorType) throws {
        storable.uuid = domain.uuid
        storable.username = domain.username
        storable.firstName = domain.firstName
        storable.lastName = domain.lastName
        storable.email = domain.email
        storable.birthDate = domain.birthDate
        storable.gender = domain.gender?.rawValue
        storable.heightCm = domain.heightCm ?? 0
        storable.weightKg = domain.weightKg ?? 0

        try connector.connect(RelationshipToOne(parent: storable,
                                                child: MappableSleepSystem(domain: domain.system),
                                                keyPath: \.system))

        try connector.connect(RelationshipToOne(parent: storable,
                                                child: domain.trend != nil ? MappableSleepTrend(domain: domain.trend!) : nil,
                                                keyPath: \.trend))

        try connector.connect(RelationshipToMany(parent: storable,
                                                 children: domain.devices.map { MappableSleepDevice(domain: $0) },
                                                 keyPath: \.devicesArray,
                                                 options: RelationshipOption.Preset.additiveMerge))

        try connector.connect(RelationshipToMany(parent: storable,
                                                 children: domain.sessions.map { MappableSleepSession(domain: $0) },
                                                 keyPath: \.sessionsArray,
                                                 options: RelationshipOption.Preset.additiveMerge))
    }
}

extension CoreUser {
    var devicesArray: [CoreSleepDevice]? {
        get { return devices?.allObjects as? [CoreSleepDevice] }
        set { devices = newValue != nil ? NSSet(array: newValue!) : nil }
    }

    var sessionsArray: [CoreSleepSession]? {
        get { return sessions?.allObjects as? [CoreSleepSession] }
        set { sessions = newValue != nil ? NSSet(array: newValue!) : nil }
    }
}
