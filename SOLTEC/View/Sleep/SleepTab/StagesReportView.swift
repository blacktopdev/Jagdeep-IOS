//
//  StagesReportView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/15/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct StagesReportView: View {
    @Environment(\.injected) private var injected: AppInjection
    @EnvironmentObject private var appState: AppState

    var sessionMetric: SleepSessionMetric { appState.selectedSession.metric }
    var interactor: SleepDataInteractor { injected.interactor.sleepData }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Constants.Metrics.padding) {
                StagesGraphView(session: appState.selectedSession, style: .standard)
                    .padding(.top, 24)
                    .padding(.bottom, 22)

                SleepTimesView(repo: injected.repositories.dataRepo, sessionMetric: sessionMetric)

                Text("Sleep Stage Numeric Report")
                    .headerCardTheme()

                VStack(spacing: Constants.Metrics.halfPadding) {
                    HStack(spacing: Constants.Metrics.halfPadding) {
                        SleepStageMiniCard(stage: .wake)
                        wakeTimeView
                        wakePercentNightView
                        MetricMiniCard(text: "Sleep", value: "- -")
                    }
                    HStack(spacing: Constants.Metrics.halfPadding) {
                        SleepStageMiniCard(stage: .rem)
                        remTimeView
                        remPercentNightView
                        remPercentSleepView
                    }
                    HStack(spacing: Constants.Metrics.halfPadding) {
                        SleepStageMiniCard(stage: .light)
                        lightTimeView
                        lightPercentNightView
                        lightPercentSleepView
                    }
                    HStack(spacing: Constants.Metrics.halfPadding) {
                        SleepStageMiniCard(stage: .delta)
                        deltaTimeView
                        deltaPercentNightView
                        deltaPercentSleepView
                    }
                }
            }
            .padding([.leading, .trailing, .bottom], Constants.Metrics.padding)
        }
        .fullscreenTheme()
        .navigationTitle("Stages Report")
    }
}

extension StagesReportView {
    // MARK: - Metric Views

    var wakeTimeView: some View {
        NavigationLink(destination: TrendedMetricView(title: "Wake Time",
                                                      metricType: .duration(metric: interactor.wakeTimeMetric.target))) {
            MetricMiniCard(text: "Time",
                           value: String(format: "%.f", sessionMetric.cumulativeTime.wake / 60))
        }
    }

    var wakePercentNightView: some View {
        NavigationLink(destination:
                        TrendedMetricView(title: "Wake % Recorded",
                                          metricType: .ratio(metricA: interactor.wakePercentNightMetric.target,
                                                             metricB: interactor.recordingTimeMetric.target,
                                                             category: "wake"))) {
            MetricMiniCard(text: "Recorded",
                           value: String(format: "%.f%%", sessionMetric.cumulativeTime.wake /
                                            sessionMetric.recordDuration * 100))
        }
    }

    var remTimeView: some View {
        NavigationLink(destination: TrendedMetricView(title: "REM Time",
                                                      metricType: .duration(metric: interactor.remTimeMetric.target))) {
            MetricMiniCard(text: "Time", value: String(format: "%.f", sessionMetric.cumulativeTime.rem / 60))
        }
    }

    var remPercentNightView: some View {
        NavigationLink(destination:
                        TrendedMetricView(title: "REM % Recorded",
                                          metricType: .ratio(metricA: interactor.remPercentNightMetric.target,
                                                             metricB: interactor.recordingTimeMetric.target,
                                                             category: "rem"))) {
            MetricMiniCard(text: "Recorded",
                           value: String(format: "%.f%%", sessionMetric.cumulativeTime.rem /
                                            sessionMetric.recordDuration * 100))
        }
    }

    var remPercentSleepView: some View {
        NavigationLink(destination:
                        TrendedMetricView(title: "REM % Sleep",
                                          metricType: .ratio(metricA: interactor.remPercentSleepMetric.target,
                                                             metricB: interactor.sleepTimeMetric.target,
                                                             category: "rem"))) {
            MetricMiniCard(text: "Sleep", value: String(format: "%.f%%", sessionMetric.cumulativeTime.rem /
                                                            sessionMetric.sleepDuration * 100))
        }
    }

    var lightTimeView: some View {
        NavigationLink(destination: TrendedMetricView(title: "Light Time",
                                                      metricType: .duration(metric: interactor.lightTimeMetric.target))) {
            MetricMiniCard(text: "Time", value: String(format: "%.f", sessionMetric.cumulativeTime.light / 60))
        }
    }

    var lightPercentNightView: some View {
        NavigationLink(destination:
                        TrendedMetricView(title: "Light % Recorded",
                                          metricType: .ratio(metricA: interactor.lightPercentNightMetric.target,
                                                             metricB: interactor.recordingTimeMetric.target,
                                                             category: "light"))) {
            MetricMiniCard(text: "Recorded", value: String(format: "%.f%%", sessionMetric.cumulativeTime.light /
                                                            sessionMetric.recordDuration * 100))
        }
    }

    var lightPercentSleepView: some View {
        NavigationLink(destination:
                        TrendedMetricView(title: "Light % Sleep",
                                          metricType: .ratio(metricA: interactor.lightPercentSleepMetric.target,
                                                             metricB: interactor.sleepTimeMetric.target,
                                                             category: "light"))) {
            MetricMiniCard(text: "Sleep",
                           value: String(format: "%.f%%", sessionMetric.cumulativeTime.light /
                                            sessionMetric.sleepDuration * 100))
        }
    }

    var deltaTimeView: some View {
        NavigationLink(destination: TrendedMetricView(title: "Delta Time",
                                                      metricType: .duration(metric: interactor.deltaTimeMetric.target))) {
            MetricMiniCard(text: "Time",
                           value: String(format: "%.f", sessionMetric.cumulativeTime.delta / 60))
        }
    }

    var deltaPercentNightView: some View {
        NavigationLink(destination:
                        TrendedMetricView(title: "Delta % Recorded",
                                          metricType: .ratio(metricA: interactor.deltaPercentNightMetric.target,
                                                             metricB: interactor.recordingTimeMetric.target,
                                                             category: "delta"))) {
            MetricMiniCard(text: "Recorded",
                           value: String(format: "%.f%%", sessionMetric.cumulativeTime.delta /
                                            sessionMetric.recordDuration * 100))
        }
    }

    var deltaPercentSleepView: some View {
        NavigationLink(destination:
                        TrendedMetricView(title: "Delta % Sleep",
                                          metricType: .ratio(metricA: interactor.deltaPercentSleepMetric.target,
                                                             metricB: interactor.sleepTimeMetric.target,
                                                             category: "delta"))) {
            MetricMiniCard(text: "Sleep",
                           value: String(format: "%.f%%", sessionMetric.cumulativeTime.delta /
                                            sessionMetric.sleepDuration * 100))
        }
    }
}

struct StagesReportView_Previews: PreviewProvider {
    static var previews: some View {
        StagesReportView()
            .environment(\.injected, AppInjection.defaultValue)
            .environmentObject(AppState())
//            .previewLayout(.sizeThatFits)
    }
}
