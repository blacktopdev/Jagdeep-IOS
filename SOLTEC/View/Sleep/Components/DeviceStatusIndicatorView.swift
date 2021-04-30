//
//  DeviceStatusIndicatorView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/3/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct DeviceStatusIndicatorView: View {
    enum Status {
        case connected
        case lowBattery
        case disconnected
        case error
        case notConfigured
    }

    let status: Status

    var body: some View {
        HStack(spacing: 6) {
            switch status {
            case .connected:
                Circle()
                    .fill(Color.appGreen)
                    .frame(width: 10, height: 10)
                Text("Connected")
                    .calloutFont()
            case .lowBattery:
                Circle()
                    .fill(Color.appLightOchre)
                    .frame(width: 10, height: 10)
                Text("Low Battery")
                    .calloutFont()
            case .disconnected:
                Circle()
                    .fill(Color.appMono62)
                    .frame(width: 10, height: 10)
                Text("Disconnected")
                    .calloutFont()
            case .notConfigured:
                Circle()
                    .fill(Color.appMono62)
                    .frame(width: 10, height: 10)
                Text("Not Configured")
                    .calloutFont()
            case .error:
                Circle()
                    .fill(Color.appMagenta)
                    .frame(width: 10, height: 10)
                Text("Error")
                    .calloutFont()
            }
        }
    }
}

struct DeviceStatusIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            DeviceStatusIndicatorView(status: .connected)
            DeviceStatusIndicatorView(status: .lowBattery)
            DeviceStatusIndicatorView(status: .disconnected)
            DeviceStatusIndicatorView(status: .error)
        }
        .fullscreenTheme()
    }
}
