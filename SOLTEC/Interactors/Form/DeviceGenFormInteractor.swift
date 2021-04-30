//
//  DeviceGenFormInteractor.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/29/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI
import Combine

struct DeviceGenFormInteractor: FormInteractor {
    private var cancelBag = CancelBag()

//    private enum SubmitError: TitleTextError {
//        case bluetoothAuth
//        case bluetoothState
//
//        var title: LocalizedStringKey {
//            switch self {
//            case .bluetoothAuth, .bluetoothState:
//                return "Bluetooth Unavailable"
//            }
//        }
//
//        var text: LocalizedStringKey {
//            switch self {
//            case .bluetoothAuth:
//                return "Please visit your device settings to ensure bluetooth is enabled, and SOLTEC•Z has permission to use it."
//            case .bluetoothState:
//                return "Unable to verify bluetooth capability. Please try later, or contact support."
//            }
//        }
//    }

    func validateForm(model: DeviceGenFormModel) -> AnyPublisher<[FieldError], Never> {
        return Future<[FieldError], Never> { promise in promise(.success([])) }
            .eraseToAnyPublisher()
    }

    func commitForm(model: DeviceGenFormModel) -> AnyPublisher<[FieldError], Never> {
        return validateBluetooth(model: model)
    }
}

extension DeviceGenFormInteractor {

//    private var bluetoothAuthError: FieldError { FieldError(id: "", error: SubmitError.bluetoothAuth) }
//    private var bluetoothStateError: FieldError { FieldError(id: "", error: SubmitError.bluetoothState) }
    
    private func validateBluetooth(model: DeviceGenFormModel) -> AnyPublisher<[FieldError], Never> {
        // something we don't know yet
        Future<[FieldError], Never> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                promise(.success([]))
            }
        }
        .eraseToAnyPublisher()
    }
}
