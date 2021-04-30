//
//  AlertOverlayView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/3/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct AlertOverlayView: View {

    enum Style {
        case battery
    }

    let style: Style
    let title: LocalizedStringKey
    let text: LocalizedStringKey

    private var image: Image {
        switch style {
        case .battery:
            return Image(systemName: "bolt.fill.batteryblock")
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            image
                .largeTitleFont()
                .foregroundColor(.appLightOchre)
                .padding(.bottom)

            Text(title)
                .headlineFont()
            
            Text(text)
                .conciseBodyFont()
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(.appMonoD8)
    }
}

struct AlertOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        AlertOverlayView(style: .battery, title: "Low Battery", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam ultrices diam sit amet lacus elementum, ac facilisis sem vestibulum. ")
            .background(Color.appMono2C)
            .previewLayout(.sizeThatFits)
    }
}
