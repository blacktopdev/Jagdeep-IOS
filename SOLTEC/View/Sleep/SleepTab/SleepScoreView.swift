//
//  SleepScoreView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/23/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct SleepScoreView: View {
    @Environment(\.injected) private var injected: AppInjection
    @EnvironmentObject private var appState: AppState

    var score: SleepScore { appState.selectedSession.score }
    var interactor: SleepDataInteractor { injected.interactor.sleepData }

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Metrics.padding) {
            NavigationLink(destination: TrendedMetricView(title: "Sleep Score",
                                                          metricType: .quality(metric: interactor.overallMetric.target))) {
                StatusBarCard(color: Color.color(forScore: score.overall),
                              completeness: score.overall, text: "Sleep Score")
                    .frame(maxWidth: .infinity)
                    .regularCardTheme()
            }

            HStack(spacing: Constants.Metrics.padding) {
                NavigationLink(destination: TrendedMetricView(title: "Asleep",
                                                              metricType: .quality(metric: interactor.asleepMetric.target))) {
                    MetricCompactCard(color: Color.color(forScore: score.duration),
                                      completeness: score.duration,
                                      text: "Asleep", value: String(format: "%.f", score.duration))
                }

                NavigationLink(destination: TrendedMetricView(title: "Delta",
                                                              metricType: .quality(metric: interactor.deltaMetric.target))) {
                    MetricCompactCard(color: Color.color(forScore: score.delta),
                                      completeness: score.delta,
                                      text: "Delta", value: String(format: "%.f", score.delta))
                }
            }

            HStack(spacing: Constants.Metrics.padding) {
                NavigationLink(destination: TrendedMetricView(title: "REM",
                                                              metricType: .quality(metric: interactor.remMetric.target))) {
                    MetricCompactCard(color: Color.color(forScore: score.rem),
                                      completeness: score.rem,
                                      text: "REM", value: String(format: "%.f", score.rem))
                }

                NavigationLink(destination: TrendedMetricView(title: "Latency",
                                                              metricType: .quality(metric: interactor.latencyMetric.target))) {
                    MetricCompactCard(color: Color.color(forScore: score.latency),
                                      completeness: score.latency,
                                      text: "Latency", value: String(format: "%.f", score.latency))
                }
            }

            HStack(spacing: Constants.Metrics.padding) {
                NavigationLink(destination: TrendedMetricView(title: "Efficiency",
                                                              metricType: .quality(metric: interactor.efficiencyMetric.target))) {
                    MetricCompactCard(color: Color.color(forScore: score.efficiency),
                                      completeness: score.efficiency,
                                      text: "Efficiency", value: String(format: "%.f", score.efficiency))
                }

                NavigationLink(destination: TrendedMetricView(title: "O2SE Index",
                                                              metricType: .index(metric: interactor.o2seMetric.target))) {
                    MetricCompactCard(color: Color.color(forIndex: score.o2seIndex,
                                                         range: SleepScore.o2seRange, isReversed: true),
                                      completeness: Color.score(forIndex: score.o2seIndex,
                                                                range: SleepScore.o2seRange),
                                      text: "O2SE Index", value: String(format: "%.1f", score.o2seIndex))
                }
            }
        }
        .opacity(appState.baselineOpacity)
        .disabled(appState.baselineNightsRemaining > 0)
        .overlay(scoreOverlay)
    }

    var scoreOverlay: some View {
        Group {
            if appState.baselineNightsRemaining > 0 {
                emptyScoreOverlay
            }
//            else if !appState.storage.hasShownBaselineCalculated {
//                baselinesCalculatedOverlay
//            }
        }
    }

    @State var isBaseLearnMorePresented = false

    var emptyScoreOverlay: some View {
        ZStack {
            VStack(spacing: 0) {
                Text("?")
                    .largeTitleFont()
                    .padding(.bottom, 12)
                Text("Where's my Sleep Score?")
                    .standardFont(size: 24, weight: .bold)
                    .padding(.bottom, 6)
                Text("It takes two nights of sleep to calculate your baseline sleep. Once you’ve clocked in two nights of rest we can start to provide you with more insights into your sleep performance.")
                    .multilineTextAlignment(.center)
                    .conciseBodyFont()
                    .padding(.bottom, 32)
                Button { self.isBaseLearnMorePresented = true } label: {
                    Text("Learn More")
                        .highlightButton()
                }
                .sheet(isPresented: $isBaseLearnMorePresented) {
                    SleepTrendSheetView(scoreType: .time)
                }
            }
            .padding(Constants.Metrics.padding)
            .padding(.bottom, Constants.Metrics.padding)
            .tightCardTheme()
        }
    }

//    var baselinesCalculatedOverlay: some View {
//        VStack(spacing: Constants.Metrics.padding) {
//            EstablishingBaselineView(nightsRemaining: 0)
//
//            Button { injected.settings.hasShownBaselineCalculated = true } label: {
//                Text("View Sleep Score")
//                    .highlightButton()
//            }
//
//            Spacer()
//        }
//    }
}

struct SleepScoreView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SleepScoreView()
                .environment(\.injected, AppInjection.defaultValue)
                .environmentObject(AppState())
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .background(Color.appMono19)
    }
}
