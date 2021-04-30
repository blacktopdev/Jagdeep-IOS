//
//  TapTwiceCardView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/31/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

private let title: LocalizedStringKey = "Tap Twice"
private let statement: LocalizedStringKey = "Remember to tap the Z•TRACK device twice on your wrist before you go to bed."


struct TapTwiceCardView: View {
    enum Style {
        case preBaseline
        case postBaseline
    }

    let style: Style

    var body: some View {
        switch style {
        case .preBaseline:
            preBaselineView
        case .postBaseline:
            postBaselineView
        }
    }

    var preBaselineView: some View {
        VStack(spacing: Constants.Metrics.padding) {
            Image("device-track-twice-blue")

            VStack(alignment: .leading, spacing: Constants.Metrics.lightPadding) {
                Text(title)
                    .standardFont(size: 24, weight: .bold)
                Text(statement)
                    .conciseBodyFont()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(EdgeInsets(top: 26, leading: Constants.Metrics.padding,
                            bottom: 36, trailing: Constants.Metrics.padding))
        .background(Color.appLavender)
        .foregroundColor(.appMonoD8)
        .cornerRadius(Constants.Metrics.cornerRadius)
    }

    var postBaselineView: some View {
        HStack(spacing: Constants.Metrics.padding) {
            VStack(alignment: .leading, spacing: Constants.Metrics.lightPadding) {
                Text(title)
                    .standardFont(size: 24, weight: .bold)
                Text(statement)
                    .conciseBodyFont()
            }
            Image("device-track-twice")
        }
        .frame(maxWidth: .infinity)
        .padding([.leading, .trailing], Constants.Metrics.padding)
        .padding([.top, .bottom], 50)
        .background(Color.appMonoC8)
    }
}

struct TapTwiceCardView_Previews: PreviewProvider {
    static var previews: some View {
        TapTwiceCardView(style: .preBaseline)
            .background(Color.appMono25)
            .previewLayout(.sizeThatFits)

        TapTwiceCardView(style: .postBaseline)
            .background(Color.appMono25)
            .previewLayout(.sizeThatFits)

    }
}
