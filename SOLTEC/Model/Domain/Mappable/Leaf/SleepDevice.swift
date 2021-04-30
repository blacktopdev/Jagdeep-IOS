//
//  SleepDevice.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/12/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct SleepDevice: DomainObject {
    enum Status: SleepEnumerationType, Codable {
        case connected
        case lowBattery
        case disconnected
        case error
        case notConfigured
    }

    let serialNumber: String
    let revision: String
    let status: Status
    let batteryLevel: Float
    let error: String?
    let syncDate: Date?
}

extension SleepDevice: SimpleMocking {
    static let mock = SleepDevice(serialNumber: "SNN-RBG-CYMK", revision: "1.2:2.3",
                                  status: .connected, batteryLevel: 67, error: nil, syncDate: nil)
    
    static let empty = mock
}
