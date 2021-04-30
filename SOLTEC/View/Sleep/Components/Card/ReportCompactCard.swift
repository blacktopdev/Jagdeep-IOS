//
//  ReportCompactCard.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 11/21/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct ReportCompactCard: View {
//    let color: Color
    //    let completeness: Double
    let text: String
    let value: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(text).calloutFont()
                Text(value).headlineFont()
            }
            .padding(.bottom, 6)

            Spacer()
//            Image(systemName: "chevron.right")
//                .foregroundColor(Color.appMono62)
        }
        .frame(maxWidth: .infinity)
        .compactCardTheme(darker: true)
        .foregroundColor(.appMonoF8)
    }
}

struct ReportCompactCard_Previews: PreviewProvider {
    static var previews: some View {
        ReportCompactCard(text: "Average Sleep Time", value: "6 hr 50 min")
            .padding()
            .frame(width: 375)
            .background(Color.appMono25)
            .previewLayout(.sizeThatFits)
    }
}
