//
//  MappableSleepStageMean.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/24/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct MappableSleepStageMean: Mappable {

    typealias StorableType = CoreSleepStageMean
    typealias DomainType = SleepStageMean
    typealias ConnectorType = CoreDataConnector

    let storableIdentifier: StorableType.IDType?
    let domain: DomainType

    init(domain: DomainType, storableIdentifier: StorableType.IDType? = nil) {
        self.storableIdentifier = storableIdentifier
        self.domain = domain
    }

    init(storable: StorableType) {
        storableIdentifier = storable.objectID
        domain = DomainType(pulseMean: storable.pulseMean,
                            pulseDeviation: storable.pulseDeviation,
                            o2Deviation: storable.o2Deviation,
                            veryLowPower: storable.veryLowPower,
                            veryLowMean: storable.veryLowMean,
                            wakeRemDiff: storable.wakeRemDiff,
                            veryLowRatio: storable.veryLowRatio)
    }

    func map(storable: StorableType, connector: ConnectorType) throws {
        storable.pulseMean = domain.pulseMean
        storable.pulseDeviation = domain.pulseDeviation
        storable.o2Deviation = domain.o2Deviation
        storable.veryLowPower = domain.veryLowPower
        storable.veryLowMean = domain.veryLowMean
        storable.wakeRemDiff = domain.wakeRemDiff
        storable.veryLowRatio = domain.veryLowRatio
    }
}
