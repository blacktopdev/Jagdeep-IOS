//
//  SleepStagesSheetView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/2/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct SleepStagesSheetView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State var page: SleepStageType = .wake

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 24) {
                    Text("Sleep Stages")
                        .standardFont(size: 34, weight: .bold)
                    Text("This report shows you the different stages of sleep your brain enters and the duration.")
                        .calloutFont()
                }
                .padding([.top, .leading, .trailing], Constants.Metrics.padding)

                tabView

                outerButton
                    .padding([.leading, .trailing], Constants.Metrics.padding)
            }
            .padding(.top, 14)
            .fullscreenTheme()
            .navigationBarTitle("Sleep Stages", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Text("Done")
                    .foregroundColor(.blue)
            })
        }
        .colorScheme(.dark)
    }

    private var lorem: LocalizedStringKey {
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam ultrices diam sit amet lacus elementum, ac facilisis sem vestibulum."
    }

    private var tabView: some View {
        TabView(selection: $page) {
            Group {
                SleepStageCard(stage: SleepStageType.wake, text: lorem)
                    .tag(SleepStageType.wake)
                SleepStageCard(stage: SleepStageType.rem, text: lorem)
                    .tag(SleepStageType.rem)
                SleepStageCard(stage: SleepStageType.light, text: lorem)
                    .tag(SleepStageType.light)
                SleepStageCard(stage: SleepStageType.delta, text: lorem)
                    .tag(SleepStageType.delta)
            }
            .padding([.leading, .trailing, .bottom], Constants.Metrics.padding)
        }
        .tabViewStyle(PageTabViewStyle())
    }

    private var outerButton: some View {
        Button(action: {
            if page != SleepStageType.last {
                withAnimation { page = page.next }
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        }) {
            Text("Got it!")
                .formBottomActionButton()
        }
    }
}

struct SleepStagesSheetPageView: View {
    let type: SleepStageType

    var body: some View {
        VStack {
            
        }
    }
}

struct SleepStagesSheetView_Previews: PreviewProvider {
    static var previews: some View {
        SleepStagesSheetView()
            .fullscreenTheme()
            .previewDevice("iPhone 8")
//            .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
    }
}
