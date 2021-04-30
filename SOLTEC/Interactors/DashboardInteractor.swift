//
//  DashboardInteractor.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/12/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI
import Combine

struct DashboardInteractor {
    @ObservedObject var appState: AppState

    private var cancelBag = CancelBag()

    func didSelect(date: Date) {
        appState.prefs.selectedDate = date
    }
}
