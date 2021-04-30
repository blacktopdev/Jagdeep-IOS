//
//  NotificationCard.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/3/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct NotificationCard: View {

    enum Style {
        case watch
        case bolt
        case cloud
    }

    let style: Style
    let text: LocalizedStringKey
    var color = Color.appLightBlue

    private var imageView: some View {
        switch style {
        case .watch:
            return Image("symbol-wearable")
                .foregroundColor(color)
        case .bolt:
            return Image(systemName: "bolt.horizontal.fill")
                .foregroundColor(color)
        case .cloud:
            return Image(systemName: "arrow.clockwise.icloud.fill")
                .foregroundColor(color)
        }
    }

    var body: some View {
        HStack(spacing: Constants.Metrics.padding) {
            imageView
            Text(text).conciseBodyFont()
            Spacer()
            if style == .watch || style == .cloud {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
        }
        .padding([.leading, .trailing], Constants.Metrics.padding)
        .frame(maxWidth: .infinity, minHeight: 30)
        .foregroundColor(.appMonoD8)
    }
}

struct NotificationCard_Previews: PreviewProvider {
    static var previews: some View {
        NotificationCard(style: .watch, text: "Device syncing")
            .background(Color.appMono2C)
            .previewLayout(.sizeThatFits)

        NotificationCard(style: .bolt, text: "Device charging")
            .background(Color.appMono2C)
            .previewLayout(.sizeThatFits)

        NotificationCard(style: .cloud, text: "Cloud syncing")
            .background(Color.appMono2C)
            .previewLayout(.sizeThatFits)
    }
}
