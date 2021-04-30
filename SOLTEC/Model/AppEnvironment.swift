//
//  AppEnvironment.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/18/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct AppEnvironment {
    let injected: AppInjection
    let systemHandler: SystemEventsHandler
}

extension AppEnvironment {

    static func bootstrap() -> AppEnvironment {
        let injected = AppInjection.defaultValue
        return AppEnvironment(injected: injected,
                              systemHandler: AppSystemEventsHandler(injected: injected))
    }
}
