//
//  BluetoothEnabledMonitor.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/29/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothEnabledMonitor: NSObject, ObservableObject {

    static let shared = BluetoothEnabledMonitor()
    
    @Published private(set) var authorization: CBManagerAuthorization = CBCentralManager.authorization
    @Published private(set) var state: CBManagerState = .unknown

    private var bluetoothManager: CBCentralManager?

    private var isActive: Bool = false
    private var allowAlert: Bool = false

    /// Enable or disable monitoring. Note under iOS14, `allowPermissionAlert: false` does not seem to work.
    /// Monitoring is initially disabled.
    func setMonitor(active: Bool, allowPermissionAlert: Bool) {
        guard active != isActive || allowPermissionAlert != allowAlert else { return }
        isActive = active
        allowAlert = allowPermissionAlert

        bluetoothManager?.delegate = nil
        bluetoothManager = nil
        guard active else { return }

        print("Bluetooth monitor enabled, allowAlert: \(allowPermissionAlert)")
        let options = [CBCentralManagerOptionShowPowerAlertKey: allowPermissionAlert]
        let manager = CBCentralManager(delegate: self, queue: nil, options: options)
        bluetoothManager = manager

    }
}

// MARK: - CBCentralManagerDelegate

extension BluetoothEnabledMonitor: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central manager will update auth: \(CBCentralManager.authorization.rawValue), state: \(central.state.rawValue)")
        authorization = CBCentralManager.authorization
        state = central.state
    }
}
