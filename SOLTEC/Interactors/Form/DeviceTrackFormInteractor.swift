//
//  DeviceTrackFormInteractor.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/29/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI
import Combine

struct DeviceTrackFormInteractor: FormInteractor {
    private var cancelBag = CancelBag()

    private enum SubmitError: TitleTextError {
        case bluetoothAuth
        case bluetoothState

        var title: LocalizedStringKey {
            switch self {
            case .bluetoothAuth, .bluetoothState:
                return "Bluetooth Unavailable"
            }
        }

        var text: LocalizedStringKey {
            switch self {
            case .bluetoothAuth:
                return "Please visit your device settings to ensure bluetooth is enabled, and SOLTEC•Z has permission to use it."
            case .bluetoothState:
                return "Unable to verify bluetooth capability. Please try later, or contact support."
            }
        }
    }

    func validateForm(model: DeviceTrackFormModel) -> AnyPublisher<[FieldError], Never> {
        switch model.page {
        case .bluetooth:
            return validateBluetooth(model: model)
        default:
            return Future<[FieldError], Never> { promise in promise(.success([])) }
                .eraseToAnyPublisher()
        }
    }

    func commitForm(model: DeviceTrackFormModel) -> AnyPublisher<[FieldError], Never> {
        Future<[FieldError], Never> { promise in
            promise(.success([]))
        }
        .eraseToAnyPublisher()
    }
}

extension DeviceTrackFormInteractor {

    private var bluetoothAuthError: FieldError { FieldError(id: "", error: SubmitError.bluetoothAuth) }
    private var bluetoothStateError: FieldError { FieldError(id: "", error: SubmitError.bluetoothState) }
    
    private func validateBluetooth(model: DeviceTrackFormModel) -> AnyPublisher<[FieldError], Never> {
        print("Validing bluetooth")
        BluetoothEnabledMonitor.shared.setMonitor(active: true, allowPermissionAlert: true)

        return Future<[FieldError], Never> { promise in
            BluetoothEnabledMonitor.shared.$authorization
                .combineLatest(BluetoothEnabledMonitor.shared.$state).sink { auth, state in
                guard state != .unknown else { return }

                switch auth {
                case .notDetermined:
                    print("Bluetooth auth undetermined")
                case .restricted, .denied:
                    print("Bluetooth auth restricted or denied")
                    promise(.success([bluetoothAuthError]))
                case .allowedAlways:
                    print("Bluetooth auth granted")
                    let errors = state == .poweredOn ? [] :  [bluetoothStateError]
                    promise(.success(errors))
                @unknown default:
                    print("Bluetooth unknown error")
                    promise(.success([bluetoothAuthError]))
                }
            }
            .store(in: cancelBag)
        }
        .eraseToAnyPublisher()
    }
}
