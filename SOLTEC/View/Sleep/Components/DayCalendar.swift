//
//  DayCalendar.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/2/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct DayCalendar: View {

    let diskItems: [StatusDisksView.Item] =
        [.init(color: .appGreen, completeness: 100, text: "M", selected: false, disabled: false),
         .init(color: .appMagentaDark, completeness: 30, text: "T", selected: false, disabled: false),
         .init(color: .appOchre, completeness: 50, text: "W", selected: false, disabled: false),
         .init(color: .appBlue, completeness: 75, text: "T", selected: true, disabled: false),
         .init(color: .appMono62, completeness: 60, text: "F", selected: false, disabled: true),
         .init(color: .appMono62, completeness: 80, text: "S", selected: false, disabled: true),
         .init(color: .appMono62, completeness: 0, text: "S", selected: false, disabled: true)]

    @State private var currentDate = Date()
//
//    private var startDate: Date {
//        let comps = Calendar.current.dateComponents([.day], from: Date())
//        return Calendar.current.date(from: comps) ?? Date()
//    }

    var canDecrementDay: Bool {
        true
    }

    var canIncrementDay: Bool {
        Date().timeIntervalSince(currentDate) > 24*3600
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? Date()
                }) {
                    Image(systemName: "arrowtriangle.left.fill")
                        .smallSymbolFont()
                }
                .accentColor(canDecrementDay ? .appMonoD8 : Color.appMonoD8.opacity(0.5))
                .disabled(!canDecrementDay)
                .padding()

                Spacer()

                Text(Constants.DateFormatters.longDate.string(from: currentDate))
                    .calloutFont()
                    .foregroundColor(.appMonoD8)

                Spacer()

                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? Date()
                }) {
                    Image(systemName: "arrowtriangle.right.fill")
                        .smallSymbolFont()
                }
                .accentColor(canIncrementDay ? .appMonoD8 : Color.appMonoD8.opacity(0.5))
                .disabled(!canIncrementDay)
                .padding()
            }
            
            StatusDisksView(items: diskItems)
                .padding([.leading, .trailing], 40)
                .padding(.top, 4)
        }
        .foregroundColor(nil)
    }
}

struct DayCalendar_Previews: PreviewProvider {
    static var previews: some View {
        DayCalendar()
//            .padding()
            .background(Color.appMono2C)
            .previewLayout(.sizeThatFits)
    }
}
