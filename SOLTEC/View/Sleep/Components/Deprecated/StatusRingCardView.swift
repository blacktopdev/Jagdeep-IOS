//
//  StatusCardView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 11/18/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct StatusRingsCardView: View {
    let color: Color
    let completeness: Double
    let text: String

    var body: some View {
        VStack {
            ZStack {
                StatusRingShape(lineWidth: 9, completeness: completeness)
                    .fill(color)
                    .frame(width: 128, height: 128)
                Text(String(describing: Int(completeness)))
                    .font(.title)
            }
            Text(text)
                .font(.headline)
                .padding(.top, 12)
        }
        .foregroundColor(.appMonoD8)
    }
}

struct StatusCardView_Previews: PreviewProvider {
    static var previews: some View {
        StatusRingsCardView(color: .appGreen, completeness: 96, text: "TOTAL SLEEP SCORE")
            .padding()
            .background(Color.appMono2C)
            .previewLayout(.sizeThatFits)
    }
}
