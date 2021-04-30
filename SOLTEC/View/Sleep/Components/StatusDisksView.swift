//
//  StatusDisksView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 11/17/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct StatusDisksView: View {
    struct Item: Hashable {
        let color: Color
        let completeness: Double
        let text: String
        let selected: Bool
        let disabled: Bool
    }

    let items: [Item]

    var body: some View {
        HStack {
            ForEach(items, id: \.self) { item in
                VStack(spacing: 7) {
                    Ellipse()
                        .stroke(item.color, lineWidth: item.disabled ? 0 : 3)
                        .background(Circle().foregroundColor(item.color))
                        .frame(width: 19, height: 19)

                    Text(item.text)
                        .axisLabelFont(isSelected: item.selected,
                                       isDisabled: item.disabled)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct StatusDisksView_Previews: PreviewProvider {
    static var previews: some View {
        let items: [StatusDisksView.Item] =
            [.init(color: .appGreen, completeness: 100, text: "M", selected: false, disabled: false),
             .init(color: .appGreen, completeness: 85, text: "T", selected: false, disabled: false),
             .init(color: .appOchre, completeness: 75, text: "W", selected: false, disabled: false),
             .init(color: .appMagenta, completeness: 50, text: "T", selected: false, disabled: false),
             .init(color: .appOchre, completeness: 65, text: "F", selected: false, disabled: false),
             .init(color: .appMagenta, completeness: 33, text: "S", selected: true, disabled: false),
             .init(color: .appMono62, completeness: 0, text: "S", selected: false, disabled: true)]

        StatusDisksView(items: items)
//            .padding()
            .background(Color.appMono25)
            .previewLayout(.sizeThatFits)
    }
}
