//
//  MetricMiniCard.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 11/21/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct MetricMiniCard: View {

    let text: String
    let value: String

    var body: some View {
        VStack(spacing: 3) {
            Text(value)
                .standardFont(size: 18, weight: .bold)
                .foregroundColor(.appMonoF8)
            Text(text)
                .multilineTextAlignment(.center)
                .smallSymbolFont()
                .foregroundColor(.appMono62)
        }
        .padding(.top, 1)
        .padding(EdgeInsets(top: 9, leading: 4, bottom: 9, trailing: 4))
        .frame(maxWidth: .infinity)
        .compactCardTheme(padding: 0)
    }
}

struct MetricMiniCard_Previews: PreviewProvider {
    static var previews: some View {
        MetricMiniCard(text: "Sleep Time", value: "85%")
            .padding()
            .background(Color.appMono25)
            .previewLayout(.sizeThatFits)
    }
}
