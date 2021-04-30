//
//  O2SEReportView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/15/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct O2seReportView: View {
    @Environment(\.injected) private var injected: AppInjection
    @EnvironmentObject private var appState: AppState

    var score: SleepScore { appState.selectedSession.score }
    var sessionMetric: SleepSessionMetric { appState.selectedSession.metric }
    var interactor: SleepDataInteractor { injected.interactor.sleepData }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Constants.Metrics.padding) {
                StagesGraphView(session: appState.selectedSession, style: .o2se)
                    .padding(.top, Constants.Metrics.padding * 2)
                    .padding(.bottom, Constants.Metrics.padding)

                SleepTimesView(repo: injected.repositories.dataRepo, sessionMetric: sessionMetric)

                Text("O2SE Numeric Report")
                    .headerCardTheme()

                numericReportView
            }
            .padding([.leading, .trailing, .bottom], Constants.Metrics.padding)
        }
        .fullscreenTheme()
        .navigationTitle("O2SE Report")
    }

    var numericReportView: some View {
        VStack(spacing: Constants.Metrics.halfPadding) {
            HStack(spacing: Constants.Metrics.halfPadding) {
                SleepStageMiniCard(stage: .rem)
                remO2SEsView
                remDesatsView
                remSnoresView
                remArousalsView
            }
            HStack(spacing: Constants.Metrics.halfPadding) {
                SleepStageMiniCard(stage: .light)
                lightO2SEsView
                lightDesatsView
                lightSnoresView
                lightArousalsView
            }
            HStack(spacing: Constants.Metrics.halfPadding) {
                SleepStageMiniCard(stage: .delta)
                deltaO2SEsView
                deltaDesatsView
                deltaSnoresView
                deltaArousalsView
            }
            HStack(spacing: Constants.Metrics.halfPadding) {
                Text("Index").smallSymbolFont()
                    .frame(width: 56, height: 20)
                o2SEIndexView
                desatIndexView
                snoreIndexView
                arousalIndexView
            }
        }
    }
}

extension O2seReportView {
    var remO2SEsView: some View {
        NavigationLink(destination: TrendedMetricView(title: "REM Sleep O2SEs",
                                                      metricType: .count(metric: interactor.remO2SEsMetric.target, category: "O2SEs"))) {
            MetricMiniCard(text: "O2SEs",
                           value: "\(sessionMetric.remEvent.o2seCount)")
        }
    }

    var remDesatsView: some View {
        NavigationLink(destination: TrendedMetricView(title: "REM Sleep O2 Drops",
                                                      metricType: .count(metric: interactor.remDesatsMetric.target, category: "O2 Drops"))) {
            MetricMiniCard(text: "O2 Drops",
                           value: "\(sessionMetric.remEvent.desatCount)")
        }
    }

    var remSnoresView: some View {
        NavigationLink(destination: TrendedMetricView(title: "REM Sleep Snores",
                                                      metricType: .count(metric: interactor.remSnoresMetric.target, category: "Snores"))) {
            MetricMiniCard(text: "Snores",
                           value: "\(sessionMetric.remEvent.soundCount)")
        }
    }

    var remArousalsView: some View {
        NavigationLink(destination: TrendedMetricView(title: "REM Sleep Arousals",
                                                      metricType: .count(metric: interactor.remArousalsMetric.target, category: "Arousals"))) {
            MetricMiniCard(text: "Arousals",
                           value: "\(sessionMetric.remEvent.arousalCount)")
        }
    }

    var lightO2SEsView: some View {
        NavigationLink(destination: TrendedMetricView(title: "Light Sleep O2SEs",
                                                      metricType: .count(metric: interactor.lightO2SEsMetric.target, category: "O2SEs"))) {
            MetricMiniCard(text: "O2SEs",
                           value: "\(sessionMetric.lightEvent.o2seCount)")
        }
    }

    var lightDesatsView: some View {
        NavigationLink(destination: TrendedMetricView(title: "Light Sleep O2 Drops",
                                                      metricType: .count(metric: interactor.lightDesatsMetric.target, category: "O2 Drops"))) {
            MetricMiniCard(text: "O2 Drops",
                           value: "\(sessionMetric.lightEvent.desatCount)")
        }
    }

    var lightSnoresView: some View {
        NavigationLink(destination: TrendedMetricView(title: "Light Sleep Snores",
                                                      metricType: .count(metric: interactor.lightSnoresMetric.target, category: "Snores"))) {
            MetricMiniCard(text: "Snores",
                           value: "\(sessionMetric.lightEvent.soundCount)")
        }
    }

    var lightArousalsView: some View {
        NavigationLink(destination: TrendedMetricView(title: "Light Sleep Arousals",
                                                      metricType: .count(metric: interactor.lightArousalsMetric.target, category: "Arousals"))) {
            MetricMiniCard(text: "Arousals",
                           value: "\(sessionMetric.lightEvent.arousalCount)")
        }
    }

    var deltaO2SEsView: some View {
        NavigationLink(destination: TrendedMetricView(title: "Delta Sleep O2SEs",
                                                      metricType: .count(metric: interactor.deltaO2SEsMetric.target, category: "O2SEs"))) {
            MetricMiniCard(text: "O2SEs",
                           value: "\(sessionMetric.deltaEvent.o2seCount)")
        }
    }

    var deltaDesatsView: some View {
        NavigationLink(destination: TrendedMetricView(title: "Delta Sleep O2 Drops",
                                                      metricType: .count(metric: interactor.deltaDesatsMetric.target, category: "O2 Drops"))) {
            MetricMiniCard(text: "O2 Drops",
                           value: "\(sessionMetric.deltaEvent.desatCount)")
        }
    }

    var deltaSnoresView: some View {
        NavigationLink(destination: TrendedMetricView(title: "Delta Sleep Snores",
                                                      metricType: .count(metric: interactor.deltaSnoresMetric.target, category: "Snores"))) {
            MetricMiniCard(text: "Snores",
                           value: "\(sessionMetric.deltaEvent.soundCount)")
        }
    }

    var deltaArousalsView: some View {
        NavigationLink(destination: TrendedMetricView(title: "Delta Sleep Arousals",
                                                      metricType: .count(metric: interactor.deltaArousalsMetric.target, category: "Arousals"))) {
            MetricMiniCard(text: "Arousals",
                           value: "\(sessionMetric.deltaEvent.arousalCount)")
        }
    }

    var o2SEIndexView: some View {
        NavigationLink(destination: TrendedMetricView(title: "O2SE Index",
                                                      metricType: .index(metric: interactor.o2SEIndexMetric.target))) {
            MetricMiniCard(text: "O2SE",
                           value: String(format: "%.1f", score.o2seIndex))
        }
    }

    var desatIndexView: some View {
        NavigationLink(destination: TrendedMetricView(title: "O2 Drop Index",
                                                      metricType: .index(metric: interactor.desatIndexMetric.target))) {
            MetricMiniCard(text: "O2 Drop",
                           value: String(format: "%.1f", score.desatIndex))
        }
    }

    var snoreIndexView: some View {
        NavigationLink(destination: TrendedMetricView(title: "Snore Index",
                                                      metricType: .index(metric: interactor.snoreIndexMetric.target))) {
            MetricMiniCard(text: "Snore",
                           value: String(format: "%.1f", score.soundIndex))
        }
    }

    var arousalIndexView: some View {
        NavigationLink(destination: TrendedMetricView(title: "Arousal Index",
                                                      metricType: .index(metric: interactor.arousalIndexMetric.target))) {
            MetricMiniCard(text: "Arousal",
                           value: String(format: "%.1f", score.arousalIndex))
        }
    }
}

struct O2seReportView_Previews: PreviewProvider {
    static var previews: some View {
        O2seReportView()
            .environment(\.injected, AppInjection.defaultValue)
            .environmentObject(AppState())
    }
}
