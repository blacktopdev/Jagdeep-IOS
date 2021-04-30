//
//  StatusBarCardView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 11/21/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct StatusBarCard: View {
    let color: Color
    let completeness: Float
    let text: String

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .lastTextBaseline) {
                VStack(alignment: .leading, spacing: 1) {
                    Text("Z•TEST")
                        .standardFont(size: 18, weight: .light)
                        .foregroundColor(Color.appMono8E)
                    Text(text)
                        .headlineFont()
                        .padding(.top, -2)
                }

                Spacer()
                Text(String(describing: Int(completeness)))
                    .largeTitleFont()
            }

            StatusBarView(color: color, completeness: completeness,
                          startPoint: .leading, endPoint: .trailing)
                .frame(height: 30)
                .padding(.top, 4)
        }
        .foregroundColor(.appMonoF8)
    }
}

struct StatusBarCardView_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarCard(color: .appBlue, completeness: 71, text: "Sleep Score")
            .padding()
            .background(Color.appMono25)
            .previewLayout(.sizeThatFits)
    }
}
