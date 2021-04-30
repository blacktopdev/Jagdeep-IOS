//
//  SleepScoreView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 10/8/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI
import SciChart

struct SleepNormalExplorerView: View {
    @State private var selectedTypes: Set = [SleepKeyDataType.veryLowPower]

    @State var modalDisplayed = false

    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?

    var body: some View {
        NavigationView {
            DataTypeGrapher(dataTypes: $selectedTypes)
                .navigationBarTitle("NormData", displayMode: .inline)
                .navigationBarItems(trailing: Button(action: { self.modalDisplayed = true }, label: {
                    Image(systemName: "gearshape.fill")
                        .padding()
                }).sheet(isPresented: $modalDisplayed, content: {
                    DataTypeSelectionView(selectedTypes: $selectedTypes,
                                          onDismiss: { self.modalDisplayed = false })
                        .colorScheme(.dark)
                }))
        }
        .colorScheme(.dark)
    }
}

struct SleepScoreView_Previews: PreviewProvider {
    static var previews: some View {
        SCIChartSurface.setRuntimeLicenseKey(Constants.sciChartLicenseKey)
        return Group {
            SleepNormalExplorerView()
        }
    }
}
