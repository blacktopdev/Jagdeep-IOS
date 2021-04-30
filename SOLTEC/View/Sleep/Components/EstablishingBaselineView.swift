//
//  EstablishingBaselineView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 11/21/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct EstablishingBaselineView: View {
    let nightsRemaining: Int

    var body: some View {
        VStack(spacing: Constants.Metrics.padding) {
            VStack(spacing: Constants.Metrics.lightPadding) {
                image
                    .padding(.bottom, Constants.Metrics.padding)

                Text(title)
                    .standardFont(size: 24, weight: .bold)

                Text(statement)
                    .multilineTextAlignment(.center)
                    .conciseBodyFont()
            }
            .frame(maxWidth: .infinity)
            .regularCardTheme(looser: true, radius: Constants.Metrics.cornerRadiusLoose)
        }
        .foregroundColor(Color.appMonoF8)
    }

    private var image: Image {
        switch nightsRemaining {
        case 1...:
            return Image("icon-zzz")
        default:
            return Image("graph-bar")
        }
    }

    private var title: LocalizedStringKey {
        switch nightsRemaining {
        case 1...:
            return nightsRemaining != 1 ?
                "\(nightsRemaining) Nights to Go" :
                "\(nightsRemaining) Night to Go"
        default:
            return "Baseline Sleep Calculated"
        }
    }

    private var statement: LocalizedStringKey {
        switch nightsRemaining {
        case 1...:
            return "Before we can begin showing you how you’re sleeping, we’ll need to collect two nights worth of data to understand how you sleep."
        default:
            return "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam ultrices diam sit amet lacus elementum, ac facilisis sem vestibulum."
        }
    }
}

struct EstablishingBaselineView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EstablishingBaselineView(nightsRemaining: 2)
                .background(Color.appMono25)
                .previewLayout(.sizeThatFits)

            EstablishingBaselineView(nightsRemaining: 1)
                .background(Color.appMono25)
                .previewLayout(.sizeThatFits)

            EstablishingBaselineView(nightsRemaining: 0)
                .background(Color.appMono25)
                .previewLayout(.sizeThatFits)
        }
    }
}
