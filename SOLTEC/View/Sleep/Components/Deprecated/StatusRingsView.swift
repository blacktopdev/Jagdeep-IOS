//
//  StatusRingsView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 11/17/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct StatusRingsView: View {
    struct Item: Hashable {
        let color: Color
        let completeness: Double
        let text: String
    }

    let items: [Item]

    var body: some View {
        HStack {
            ForEach(items, id: \.self) { item in
                VStack {
                    StatusRingShape(lineWidth: 3, completeness: item.completeness)
                        .fill(item.color)
                        .frame(width: 19, height: 19)
                    Text(item.text)
                        .font(.caption)
                        .foregroundColor(.appMonoF8)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct StatusRingsView_Previews: PreviewProvider {
    static var previews: some View {
        let items: [StatusRingsView.Item] =
            [.init(color: .appGreen, completeness: 100, text: "M"),
             .init(color: .appGreen, completeness: 85, text: "T"),
             .init(color: .appOchre, completeness: 75, text: "W"),
             .init(color: .appMagenta, completeness: 50, text: "T"),
             .init(color: .appOchre, completeness: 65, text: "F"),
             .init(color: .appMagenta, completeness: 33, text: "S"),
             .init(color: .appMonoA3, completeness: 0, text: "S")]

        StatusRingsView(items: items)
            .padding()
            .background(Color.appMono25)
            .previewLayout(.sizeThatFits)
    }
}
