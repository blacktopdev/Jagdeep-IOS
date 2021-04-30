//
//  TrackerInformationView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/3/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct TrackerInformationView: View {
    var body: some View {
        VStack(spacing: 0) {
            Image("device-track-large")
                .padding([.top, .bottom], 40)

            FormInfoRow(title: Text("Status"), content: DeviceStatusIndicatorView(status: .connected))
            FormInfoRow(title: Text("Battery Level"), content: Text("90%"))
            FormInfoRow(title: Text("Last Sync"), content: Text("February 1 @ 11:16 AM"))
            FormInfoRow(title: Text("Serial Number"), content: Text("123097451902"))
            FormInfoRow(title: Text("Firmware Version"), content: Text("0.8.4"))
            Spacer()

            ListDividerView()
            FormInfoRow(title: Text("Forget Device").foregroundColor(.red), content: EmptyView()) {
                print("Handle remove device request")
            }
        }
        .padding(.bottom, Constants.Metrics.padding)
        .navigationBarTitle("Z•TRACK", displayMode: .inline)
    }
}

struct TrackerInformationView_Previews: PreviewProvider {
    static var previews: some View {
        TrackerInformationView()
            .fullscreenTheme(darkness: .darker)
    }
}
