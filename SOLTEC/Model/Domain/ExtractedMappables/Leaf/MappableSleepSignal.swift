//
//  MappableSleepSignal.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/24/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct MappableSleepSignal: Mappable {

    typealias StorableType = CoreSleepSignal
    typealias DomainType = SleepSignal<Float>
    typealias ConnectorType = CoreDataConnector

    let storableIdentifier: StorableType.IDType?
    let domain: DomainType

    init(domain: DomainType, storableIdentifier: StorableType.IDType? = nil) {
        self.storableIdentifier = storableIdentifier
        self.domain = domain
    }

    init(storable: StorableType) {
        storableIdentifier = storable.objectID
        domain = DomainType(veryLowPower: storable.veryLowPower,
                            lowPower: storable.lowPower,
                            highPower: storable.highPower,
                            veryLowPeak: storable.veryLowPeak,
                            lowPeak: storable.lowPeak,
                            highPeak: storable.highPeak,
                            veryLowMean: storable.veryLowMean,
                            lowMean: storable.lowMean,
                            highMean: storable.highMean,
                            totalPower: storable.totalPower,
                            highRatio: storable.highRatio,
                            lowRatio: storable.lowRatio,
                            veryLowRatio: storable.veryLowRatio,
                            newBandRatio: storable.novelBandRatio,
                            pulseMean: storable.pulseMean,
                            pulseDeviation: storable.pulseDeviation,
                            o2Deviation: storable.o2Deviation,
                            breathMean: storable.breathMean,
                            breathDeviation: storable.breathDeviation,
                            minuteVent: storable.minuteVent)
    }

    func map(storable: StorableType, connector: ConnectorType) throws {
        storable.veryLowPower = domain.veryLowPower
        storable.lowPower = domain.lowPower
        storable.highPower = domain.highPower
        storable.veryLowPeak = domain.veryLowPeak
        storable.lowPeak = domain.lowPeak
        storable.highPeak = domain.highPeak
        storable.veryLowMean = domain.veryLowMean
        storable.lowMean = domain.lowMean
        storable.highMean = domain.highMean
        storable.totalPower = domain.totalPower
        storable.highRatio = domain.highRatio
        storable.lowRatio = domain.lowRatio
        storable.veryLowRatio = domain.veryLowRatio
        storable.novelBandRatio = domain.newBandRatio
        storable.pulseMean = domain.pulseMean
        storable.pulseDeviation = domain.pulseDeviation
        storable.o2Deviation = domain.o2Deviation
        storable.breathMean = domain.breathMean
        storable.breathDeviation = domain.breathDeviation
        storable.minuteVent = domain.minuteVent
    }
}
