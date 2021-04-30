//
//  DeviceTrackFormModel.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/29/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

class DeviceTrackFormModel: ObservableObject {
    enum Page: CaseIterable {
        case introduction
        case chargingIndicator
        case bluetooth
        case scanning
        case scanningResults
        case batteryIndicator
        case complete
    }

    @Published var page: Page = .introduction
}
