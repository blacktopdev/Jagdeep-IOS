//
//  MappableSleepSystem.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/24/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct MappableSleepSystem: Mappable {

    typealias StorableType = CoreSleepSystem
    typealias DomainType = SleepSystem
    typealias ConnectorType = CoreDataConnector

    let storableIdentifier: StorableType.IDType?
    let domain: DomainType

    init(domain: DomainType, storableIdentifier: StorableType.IDType? = nil) {
        self.storableIdentifier = storableIdentifier
        self.domain = domain
    }

    init(storable: StorableType) {
        storableIdentifier = storable.objectID
        domain = DomainType(hasBaseline: storable.hasBaseline,
                            alarmSecond: Int(storable.alarmSecond),
                            isAlarmOn: storable.isAlarmOn)
    }

    func map(storable: StorableType, connector: ConnectorType) throws {
        storable.hasBaseline = domain.hasBaseline
        storable.alarmSecond = Int32(domain.alarmSecond)
        storable.isAlarmOn = domain.isAlarmOn
    }
}
