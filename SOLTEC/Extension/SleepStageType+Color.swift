//
//  SleepStageType+Color.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/24/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

extension SleepStageType {
    var color: Color {
        switch self {
        case .wake:
            return Color.appMagenta
        case .rem:
            return Color.appLightOchre
        case .light:
            return Color.appGreen
        case .delta:
            return Color.appLavender
        }
    }
}
