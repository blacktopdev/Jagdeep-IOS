//
//  GenInformationView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/3/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct GenInformationView: View {
    var body: some View {
        VStack(spacing: 0) {
            Image("device-gen-large")
                .padding([.top, .bottom], 40)

            FormInfoRow(title: Text("Status"), content: DeviceStatusIndicatorView(status: .notConfigured))
            FormInfoRow(title: Text("Serial Number"), content: Text("------"))
            FormInfoRow(title: Text("Firmware Version"), content: Text("-----"))
            Spacer()

            ListDividerView()
            FormInfoRow(title: Text("Forget Device").foregroundColor(.red), content: EmptyView()) {
                print("Handle remove device request")
            }
        }
        .padding(.bottom, Constants.Metrics.padding)
        .navigationBarTitle("Z•GEN", displayMode: .inline)
    }
}

struct GenInformationView_Previews: PreviewProvider {
    static var previews: some View {
        GenInformationView()
            .fullscreenTheme(darkness: .darker)
    }
}
