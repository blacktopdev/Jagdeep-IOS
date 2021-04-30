//
//  AppInjection.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/18/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct AppInjection: EnvironmentKey {
    struct Interactors {
        #if !APP_LAB
        let sleepData: SleepDataInteractor
        #endif
    }

    struct Repositories {
        let dataRepo: CoreDataRepository
        let webRepo: SleepWebRepository
    }

    let appState: AppState
    let settings: SleepPreferences
    let repositories: Repositories
    let interactor: Interactors

    static private let appState = AppState()
    static private let settings = SleepPreferences()
    static private let dataRepo = CoreDataRepository(modelName: "Soltec",
                                                     deleteExisting: settings
                                                        .shouldMigrateBreakingChange(buildNumber: 505, isHandled: true))
    static private let webRepo = SleepWebRepository()
    #if APP_LAB
    static private let interactors = Interactors()
    #else
    static private let interactors = Interactors(sleepData: SleepDataInteractor(appState: appState, dataRepo: dataRepo, webRepo: webRepo))
    #endif

    static var defaultValue: Self { Self.default }

    private static let `default` = Self(appState: appState,
                                        settings: settings,
                                        repositories: Repositories(dataRepo: dataRepo, webRepo: webRepo),
                                        interactor: interactors)
}

extension EnvironmentValues {
    var injected: AppInjection {
        get { self[AppInjection.self] }
        set { self[AppInjection.self] = newValue }
    }
}
