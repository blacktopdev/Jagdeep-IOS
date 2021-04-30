//
//  SleepScoreView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 10/8/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI
import SciChart

struct SleepLabView: View {
    @StateObject var dataSource = SleepLabDataSource(preferences: SleepLabPreferences())
    
    @State private var selectedFile = LabSettings.selectedSleepNormalsURL

    @State private var modalDisplayed = false
    @State private var isMetricsDisplayed = false

    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?

    var body: some View {
        NavigationView {
            SleepGraphGroup(dataSource: dataSource,
                            isMetricsDisplayed: $isMetricsDisplayed)
                .navigationBarTitle(selectedFile?.deletingPathExtension().lastPathComponent ?? "<not loaded>",
                                    displayMode: .inline)
                .navigationBarItems(leading: Button(action: { self.isMetricsDisplayed.toggle() },
                                                    label: { Image(systemName: "gauge").padding() }),
                                    trailing: Button(action: { self.modalDisplayed.toggle() },
                                                     label: { Image(systemName: "gearshape.fill").padding() })
                                        .popoverSheet(idiom: idiom, isPresented: $modalDisplayed,
                                                      sheetContent: preferencesView, requiredIdiom: .popover))
        }
        .popoverSheet(idiom: idiom, isPresented: $modalDisplayed,
                      sheetContent: preferencesView, requiredIdiom: .sheet)
        .navigationViewStyle(StackNavigationViewStyle())
        .colorScheme(.dark)
    }

    var idiom: ModalDisplayIdiom {
        (horizontalSizeClass == .regular && verticalSizeClass == .regular) ? .popover : .sheet
    }

    var preferencesView: AnyView {
        AnyView(SleepPreferencesView(preferences: dataSource.preferences,
                                           selectedFile: $selectedFile,
                                           isPresented: $modalDisplayed)
                    .frame(idealWidth: 375, idealHeight: 700, alignment: .center))
    }
}

struct SleepScoreView_Previews: PreviewProvider {
    static var previews: some View {
        SCIChartSurface.setRuntimeLicenseKey(Constants.sciChartLicenseKey)
        return Group {
            SleepLabView()
        }
    }
}
