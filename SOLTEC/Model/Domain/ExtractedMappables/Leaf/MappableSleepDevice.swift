//
//  MappableSleepDevice.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/24/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct MappableSleepDevice: Mappable {

    typealias StorableType = CoreSleepDevice
    typealias DomainType = SleepDevice
    typealias ConnectorType = CoreDataConnector

    let storableIdentifier: StorableType.IDType?
    let domain: DomainType

    var findPredicate: NSPredicate? {
        NSPredicate(format: "%K==%@", "serialNumber", domain.serialNumber)
    }

    init(domain: DomainType, storableIdentifier: StorableType.IDType? = nil) {
        self.storableIdentifier = storableIdentifier
        self.domain = domain
    }

    init(storable: StorableType) {
        storableIdentifier = storable.objectID
        domain = DomainType(serialNumber: storable.serialNumber ?? "",
                            revision: storable.revision ?? "",
                            status: SleepDevice.Status(rawValue: storable.status ?? "") ?? .notConfigured,
                            batteryLevel: storable.batteryLevel,
                            error: storable.error,
                            syncDate: storable.syncDate)
    }

    func map(storable: StorableType, connector: ConnectorType) throws {
        storable.serialNumber = domain.serialNumber
        storable.revision = domain.revision
        storable.status = domain.status.rawValue
        storable.batteryLevel = domain.batteryLevel
        storable.error = domain.error
        storable.syncDate = domain.syncDate
    }
}
