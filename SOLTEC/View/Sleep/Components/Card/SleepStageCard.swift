//
//  SleepStageCard.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/2/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct SleepStageCard: View {
    let stage: SleepStageType
    let text: LocalizedStringKey

    var body: some View {
        VStack(spacing: 8) {
            Text(stage.shortName)
                .standardFont(size: 24, weight: .bold)
                .foregroundColor(.white)
                .frame(width: 45, height: 45)
                .background(Circle().fill(stage.color))
            Text(stage.name)
                .standardFont(size: 24, weight: .bold)
            Text(text)
                .conciseBodyFont()
                .multilineTextAlignment(.center)
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(EdgeInsets(top: Constants.Metrics.padding,
                            leading: 16,
                            bottom: 50,
                            trailing: Constants.Metrics.padding))
        .foregroundColor(Color.appMonoF8)
        .background(Color.appMono2C)
        .cornerRadius(Constants.Metrics.cornerRadiusLoose)
    }
}

struct SleepStageCard_Previews: PreviewProvider {
    static let text: LocalizedStringKey = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam ultrices diam sit amet lacus elementum, ac facilisis sem vestibulum. In sodales viverra tincidunt. Nunc augue purus, vehicula non posuere ut, feugiat ut metus."
    static var previews: some View {
        SleepStageCard(stage: .wake, text: text)
            .padding()
            .previewLayout(.sizeThatFits)
            .background(Color.appMono19)
            .foregroundColor(Color.appMonoD8)
    }
}
