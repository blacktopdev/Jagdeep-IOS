//
//  DeviceStatusCardView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/3/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct DeviceStatusCardView: View {
    enum AccessoryMode {
        case chevron
        case checkmark
    }
    let image: Image
    let title: LocalizedStringKey
    var status: DeviceStatusIndicatorView.Status?
    var accessoryMode: AccessoryMode = .chevron

    var body: some View {
        Group {
            if status == .notConfigured {
                content
                    .dottedOutlineCardTheme(darker: true, padding: 0)
            } else {
                content
                    .compactCardTheme(darker: status != nil, padding: 0)
            }
        }
    }

    var content: some View {
        HStack(spacing: 0) {
            image
                .frame(minWidth: 90)
                .padding(.trailing, 26)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .standardFont(size: status != nil ? 22 : 28, weight: .bold)
                if let status = status, status != .notConfigured {
                    DeviceStatusIndicatorView(status: status)
                }
            }
            Spacer()
            switch accessoryMode {
            case .chevron:
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.appMono62)
            case .checkmark:
                Image("icon-checkmark-small")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .padding([.leading, .trailing], Constants.Metrics.padding)
        .frame(minHeight: status != nil ? 105 : 121)
        .frame(maxWidth: .infinity)
    }
}
struct DeviceStatusCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DeviceStatusCardView(image: Image("device-track"), title: "Z•TRACK", accessoryMode: .checkmark)
            DeviceStatusCardView(image: Image("device-gen"), title: "Z•GEN")
            DeviceStatusCardView(image: Image("device-track"), title: "Z•TRACK", status: .connected)
            DeviceStatusCardView(image: Image("device-track"), title: "Z•TRACK", status: .notConfigured)
        }
        .fullscreenTheme()
    }
}
