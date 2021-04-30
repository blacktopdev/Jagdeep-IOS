//
//  DeviceGenFormModel.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/29/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

class DeviceGenFormModel: ObservableObject {
    enum Page: CaseIterable {
        case introduction
        case plug
        case scanning
        case scanningResults
        case complete
    }

    @Published var page: Page = .introduction
}
