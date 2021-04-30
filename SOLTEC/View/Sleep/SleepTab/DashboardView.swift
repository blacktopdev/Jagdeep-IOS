//
//  DashboardView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 11/18/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var appState: AppState

//    private var notifications: some View {
//        VStack(alignment: .leading, spacing: Constants.Metrics.padding) {
//            NotificationCard(style: .watch, text: "Device Syncing")
//                .compactCardTheme()
//
//            NotificationCard(style: .bolt, text: "Device Charging", color: .appLightOchre)
//                .compactCardTheme()
//
//            AlertOverlayView(style: .battery, title: "Low Battery", text: "Please keep your Z•TRACK wearable device connected to its charging cable.")
//                .regularCardTheme()
//                .fixedSize(horizontal: false, vertical: true)
//        }
//        .padding([.leading, .trailing], Constants.Metrics.padding)
//    }
    @AppStorage("hasShownBaselineCalculated") var hasShownBaselineCalculated: Bool = false

    var isRevealingFirstScore: Bool {
        appState.baselineNightsRemaining == 0 && !hasShownBaselineCalculated
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: Constants.Metrics.padding) {
                DayCalendar()
                    .grayscale(0.75)
                    .disabled(true).opacity(0.22)  // not active yet
                    .padding([.top, .bottom], 16)

                if appState.prefs.isCloudSyncing {
                    NotificationCard(style: .cloud, text: "Cloud sync in progress")
                        .transition(.scale)
                }
                
                if appState.baselineNightsRemaining > 0 {
                    EstablishingBaselineView(nightsRemaining: appState.baselineNightsRemaining)
                        .padding([.leading, .trailing], Constants.Metrics.padding)

                    TapTwiceCardView(style: .preBaseline)
                        .padding(Constants.Metrics.padding)
                }

                VStack(alignment: .leading, spacing: Constants.Metrics.padding) {
                    SleepScoreView()

                    reports
                }
                .padding([.leading, .trailing, .bottom], Constants.Metrics.padding)
            }
            .opacity(isRevealingFirstScore ? 0.5 : 1)
        }
        .overlay(baselinesCalculatedOverlay)
        .fullscreenTheme(darkness: isRevealingFirstScore ? .darkest : .normal)
        .animation(.default)
//        .onAppear {
//            hasShownBaselineCalculated = false
//        }
    }

    var reports: some View {
        VStack(alignment: .leading, spacing: Constants.Metrics.padding) {
            Text("Reports")
                .headerCardTheme()

            NavigationLink(destination: StagesReportView()) {
//                ReportCard(headerView: StagesGraphView(session: appState.selectedSession, style: .minimal)
                ReportCard(headerView: Image("graph-ins")
                            .padding(Constants.Metrics.padding),
                               gradient: Color.eveningGradient,
                               title: "Sleep Stages Report",
                               text: "This is a short description on what the benefit of this report is for the user.")
                    .tightCardTheme()
            }

            NavigationLink(destination: O2seReportView()) {
                ReportCard(headerView: Image("graph-o2se-header")
                            .resizable().frame(maxWidth: .infinity).offset(y: 22),
                           gradient: Color.morningGradient,
                           title: "O2SE Report",
                           text: "This is a short description on what the benefit of this report is for the user.")
                    .tightCardTheme()
            }
        }
        .disabled(appState.baselineNightsRemaining > 0 || isRevealingFirstScore)
        .opacity(appState.baselineOpacity)
    }

    var baselinesCalculatedOverlay: some View {
        Group {
            if isRevealingFirstScore {
                VStack(spacing: Constants.Metrics.padding) {
                    EstablishingBaselineView(nightsRemaining: 0)

                    Button { hasShownBaselineCalculated = true } label: {
                        Text("View Sleep Score")
                            .highlightButton()
                    }

                    Spacer()
                }
                .padding([.leading, .trailing], Constants.Metrics.padding)
                .padding(.top, Constants.Metrics.padding * 8)
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(AppState())
//        DashboardView(baselineNightsRemaining: 2)
//            .previewDevice("iPhone 8")
        //            .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
    }
}
