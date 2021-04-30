//
//  MappableSleepStageResult.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/24/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct MappableSleepStageResult: Mappable {

    typealias StorableType = CoreSleepStageResult
    typealias DomainType = SleepStageResult
    typealias ConnectorType = CoreDataConnector

    let storableIdentifier: StorableType.IDType?
    let domain: DomainType

    init(domain: DomainType, storableIdentifier: StorableType.IDType? = nil) {
        self.storableIdentifier = storableIdentifier
        self.domain = domain
    }

    init(storable: StorableType) {
        storableIdentifier = storable.objectID
        domain = DomainType(raw: SleepStageType(rawValue: storable.raw ?? "") ?? SleepStageType.wake,
                            filtered: SleepStageType(rawValue: storable.filtered ?? "") ?? SleepStageType.wake,
                            final: SleepStageType(rawValue: storable.final ?? "") ?? SleepStageType.wake,
                            realtime: SleepStageType(rawValue: storable.realtime ?? "") ?? SleepStageType.wake,
                            filteredCount: Int(storable.filteredCount),
                            modifiedCount: Int(storable.modifiedCount))
    }

    func map(storable: StorableType, connector: ConnectorType) throws {
        storable.raw = domain.raw.rawValue
        storable.filtered = domain.filtered.rawValue
        storable.final = domain.final.rawValue
        storable.realtime = domain.realtime.rawValue
        storable.filteredCount = Int16(domain.filteredCount)
        storable.modifiedCount = Int16(domain.modifiedCount)
    }
}
