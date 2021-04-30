//
//  PreviewTronicView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/29/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

private struct PreviewSelectionRow: View {
    let item: PreviewTronicView.Item
    var showRightChevron: Bool = true

    var body: some View {
        VStack {
            HStack {
                Text(item.title)
                Spacer()
                if showRightChevron {
                    Image(systemName: "chevron.right")
                } else {
                    Image(systemName: "chevron.up")
                }
            }
            .padding([.top, .bottom], 10)
            ListDividerView(color: Color.appLavenderDark)
                .padding([.leading], Constants.Metrics.padding)
        }
    }
}

struct PreviewTronicView: View {

    struct Item: Identifiable {
        var id: String { return title }
        let title: String
        let text: String
        let view: AnyView
    }

    @State var isMetricSheetPresented = false
    @State var isStagesSheetPresented = false

    private let items: [Item] = [.init(title: "Onboarding", text: "",
                                       view: AnyView(OnboardingView(page: .tech))),
                                 .init(title: "Login", text: "",
                                       view: AnyView(LoginView())),
                                 .init(title: "Registration", text: "",
                                       view: AnyView(RegistrationView())),
                                 .init(title: "Device Setup", text: "",
                                       view: AnyView(DeviceSetupView()))]
//                                 .init(title: "Dashboard + extras", text: "",
//                                       view: AnyView(DashboardView()))]
//                                 .init(title: "Trends", text: "",
//                                       view: AnyView(TrendedMetricView(title: "Trendy Data"))),
//                                 .init(title: "Stage Report", text: "",
//                                       view: AnyView(StagesReportView())),
//                                 .init(title: "O2SE Report", text: "",
//                                       view: AnyView(O2seReportView()))]

    private let sheetItems: [Item] = [.init(title: "Sleep Trend Info Sheet", text: "",
                                            view: AnyView(SleepTrendSheetView(scoreType: .time))),
                                      .init(title: "Sleep Stages Info Sheet", text: "",
                                            view: AnyView(SleepStagesSheetView()))]

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(items) { item in
                        NavigationLink(destination: item.view) {
                            PreviewSelectionRow(item: item)
                        }
                    }

                    Button(action: { self.isMetricSheetPresented = true }) {
                        PreviewSelectionRow(item: sheetItems[0], showRightChevron: false)
                    }
                    .sheet(isPresented: $isMetricSheetPresented) {
                        sheetItems[0].view
                    }

                    Button(action: { self.isStagesSheetPresented = true }) {
                        PreviewSelectionRow(item: sheetItems[1], showRightChevron: false)
                    }
                    .sheet(isPresented: $isStagesSheetPresented) {
                        sheetItems[1].view
                    }
                }
            }
            .padding(Constants.Metrics.padding)
            .navigationBarTitle("Preview-Mo-Tron", displayMode: .inline)
            .fullscreenTheme(darkness: .darker)
        }
        .colorScheme(.dark) // just to make collapsed navbar have dark blur effect
    }
}

struct PreviewTronicView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewTronicView()
            .previewDevice("iPhone 8")
    }
}
