//
//  SleepStageMiniCard.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/20/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct SleepStageMiniCard: View {
    let stage: SleepStageType

    var body: some View {
        VStack(spacing: 4) {
            Text(stage.shortName)
                .standardFont(size: 9.75, weight: .bold)
                .foregroundColor(.white)
                .frame(width: 56, height: 20)
                .background(Circle().fill(stage.color))
            Text(stage.name)
                .smallSymbolFont()
        }
    }
}

struct SleepStageMiniCard_Previews: PreviewProvider {
    static var previews: some View {
        SleepStageMiniCard(stage: .delta)
            .padding()
            .background(Color.appMono25)
            .previewLayout(.sizeThatFits)
   }
}
