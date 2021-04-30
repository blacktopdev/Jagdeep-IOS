//
//  SleepMetricSheetView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/2/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct SleepTrendSheetView: View {
    @Environment(\.presentationMode) private var presentationMode

    let scoreType: SleepScoreType
//    @Binding var isPresented: Bool

    var title: LocalizedStringKey {
        switch scoreType {
        case .overall:
            return "Sleep Score"
        case .time:
            return "Sleep Time"
        case .delta:
            return "Delta"
        case .rem:
            return "REM"
        case .latency:
            return "Latency"
        case .efficiency:
            return "Efficiency"
        case .o2seIndex:
            return "O2SE"
        }
    }

    var text: LocalizedStringKey {
        switch scoreType {
        case .overall:
            return "<Sleep Score description>"
        case .time:
            return "Sleep Time is defined as total time spent sleeping, not simply time in bed. Normal sleep time is 7.5 hours or more.\n\nThe Sleep Time Z•SCORE metric ranges from 0% to 100%. A Sleep Time less than 3 hours will have a Score of 0%, while a Sleep Time of 7.5 hours or more will have a Score of 100%"
        case .delta:
            return "<Delta description>"
        case .rem:
            return "<REM description>"
        case .latency:
            return "<Latency description>"
        case .efficiency:
            return "<Efficiency description>"
        case .o2seIndex:
            return "<O2SE description>"
        }
    }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: Constants.Metrics.heavyPadding) {
                        Spacer()
                        Image("graph-bar")

                        Text(title)
                            .standardFont(size: 34, weight: .bold)

                        Text(text)
                            .calloutFont()
                            .multilineTextAlignment(.center)

                        Spacer()
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Text("Got it!")
                                .formBottomActionButton()
                        }
                    }
                    .padding([.top, .leading, .trailing], Constants.Metrics.padding)
                    .frame(minHeight: geometry.size.height)
                }
            }
            .fullscreenTheme()
            .navigationBarTitle(title, displayMode: .inline)
            .navigationBarItems(trailing: Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Text("Done")
                    .foregroundColor(.blue)
            })
        }
        .colorScheme(.dark)
    }
}

struct SleepMetricSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SleepTrendSheetView(scoreType: .time)
    }
}
