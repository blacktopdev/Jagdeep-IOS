//
//  MetricCompactCard.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 11/21/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct MetricCompactCard: View {
    let color: Color
    let completeness: Float
    let text: LocalizedStringKey
    let value: String

    var body: some View {
        HStack {
            HStack(spacing: 0) {
                StatusBarView(color: color, completeness: completeness,
                              startPoint: .bottom, endPoint: .top, cornerRadius: 1)
                    .frame(width: 6, height: 53)
                    .padding(.trailing, 16)
                VStack(alignment: .leading, spacing: 6) {
                    Text(text).calloutFont()
                    Text(value).headlineFont()
                }
            }
            .padding(.bottom, 6)
            
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(Color.appMono62)
        }
        .compactCardTheme()
        .foregroundColor(.appMonoF8)
    }
}

struct MetricCompactCard_Previews: PreviewProvider {
    static var previews: some View {
        MetricCompactCard(color: .appBlue, completeness: 85, text: "Sleep Time", value: "85%")
            .padding()
            .background(Color.appMono25)
            .previewLayout(.sizeThatFits)
    }
}
