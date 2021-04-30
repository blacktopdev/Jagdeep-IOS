//
//  AppState.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/17/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

typealias AppStateRoute = Int

class AppState: ObservableObject {

    struct System: Equatable {
        var isAppActive: Bool = false
        var keyboardHeight: CGFloat = 0
    }

    struct Routing: Equatable {
        #if !APP_LAB
        var appView = AppView.Routing()
        #endif
    }

    struct Preferences {
        var selectedDate: Date = Date()
        var isCloudSyncing: Bool = false
    }

    @Published var system = System()
    @Published var routing = Routing()
    @Published var prefs = Preferences()

    @Published var currentUser: User = User.empty
    @Published var recentSessions: [SleepSession] = []

    var baselineNightsRemaining: Int {
        currentUser.system.hasBaseline ? 0 : 2 - recentSessions.count
    }

    var baselineOpacity: Double { baselineNightsRemaining > 0 ? 0.2 : 1 }

    var selectedSession: SleepSession { recentSessions.first ?? SleepSession.empty }
}

//func == (lhs: AppState, rhs: AppState) -> Bool {
//    return lhs.system == rhs.system &&
//        lhs.routing == rhs.routing
//}
