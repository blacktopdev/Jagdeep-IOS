//
//  BluetoothService.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/7/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

/**
 This is just a suggested breakdown of protocols and implementations. It could look a lot of other ways, too.
 */

import Foundation
import Combine

enum DeviceConnectionState {
    case offline
    case detected
    case connecting
    case connected
    case unstable
    case disconnected
}

/// Represents any recognized bluetooth device
protocol BluetoothDevice {
    var name: String { get }
    var mac: String { get }
    var revision: String { get }
    // ...?
}

/// Represents an active / connected bluetooth device.
protocol BluetoothPeer {
    var device: BluetoothDevice { get }

    var connectionState: DeviceConnectionState { get }
    var signalStrength: Double { get }
    // ... other stuff about a peer?
}

protocol BluetoothBatteryPeer: BluetoothPeer {
    var batteryStrength: Double { get }
}

enum DeviceEventType {
    case meta1
    case meta2
    case sendReceipt
}

protocol BluetoothEvent {
    var type: DeviceEventType { get }
    var payload: Data { get }
}

/// Represents a general bluetooth service.
protocol BluetoothService {
    var visiblePeers: [BluetoothPeer] { get }
    var connectedPeer: BluetoothPeer? { get }

    var isScanningEnabled: Bool { get set }

    var eventPublisher: AnyPublisher<BluetoothEvent, Error> { get }

    // ... generic requests
}

// *************************************
// MARK: - Tracker Implementation
// *************************************

struct TrackerDevice: BluetoothDevice {
    let name: String
    let mac: String
    let revision: String
    // ... tracker specific stuff
}

struct TrackerPeer: BluetoothBatteryPeer {
    let device: BluetoothDevice
    let connectionState: DeviceConnectionState
    let signalStrength: Double
    let batteryStrength: Double
    // ... tracker specific stuff
}

class TrackerBluetoothService: BluetoothService {
    private(set) var visiblePeers = [BluetoothPeer]()
    private(set) var connectedPeer: BluetoothPeer?

    var eventPublisher = PassthroughSubject<BluetoothEvent, Error>().eraseToAnyPublisher()

    var isScanningEnabled: Bool = false {
        didSet {
            // something
        }
    }

    // ... tracker specific requests
}

// *************************************
// MARK: - Generator Implementation
// *************************************

struct GeneratorDevice: BluetoothDevice {
    let name: String
    let mac: String
    let revision: String
    // ... generator specific stuff
}

struct GeneratorPeer: BluetoothPeer {
    let device: BluetoothDevice
    let connectionState: DeviceConnectionState
    let signalStrength: Double
    // ... generator specific stuff
}

//...
