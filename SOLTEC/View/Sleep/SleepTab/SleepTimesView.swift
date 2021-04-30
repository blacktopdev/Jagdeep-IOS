//
//  SleepTimesView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/5/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct SleepTimesView: View {
    @Environment(\.injected) private var injected: AppInjection

    let repo: CoreDataRepository
    let sessionMetric: SleepSessionMetric

    var interactor: SleepDataInteractor { injected.interactor.sleepData }

    var body: some View {
        VStack(spacing: Constants.Metrics.padding) {
            HStack(spacing: Constants.Metrics.padding) {
                recordingTimeView
                sleepTimeView
            }
            HStack(spacing: Constants.Metrics.padding) {
                onsetTimeView
                percentSleepView
            }
        }
    }

    var sleepPercent: String {
        String(format: "%.f%%", Double(sessionMetric.sleepDuration) / Double(sessionMetric.recordDuration) * 100)
    }
}

extension SleepTimesView {
    // MARK: - Metric Views

    var recordingTimeView: some View {
        NavigationLink(destination: TrendedMetricView(title: "Recording Time",
                                                      metricType: .duration(metric: interactor.recordingTimeMetric.target))) {
            ReportCompactCard(text: "Recording Time",
                              value: DateComponentsFormatter.mediumDuration
                                .string(from: TimeInterval(sessionMetric.recordDuration)) ?? "")
        }
    }

    var sleepTimeView: some View {
        NavigationLink(destination: TrendedMetricView(title: "Sleep Time",
                                                      metricType: .duration(metric: interactor.sleepTimeMetric.target))) {
            ReportCompactCard(text: "Sleep Time",
                              value: DateComponentsFormatter.mediumDuration
                                .string(from: TimeInterval(sessionMetric.sleepDuration)) ?? "")
        }
    }

    var onsetTimeView: some View {
        NavigationLink(destination: TrendedMetricView(title: "Sleep Onset",
                                                      metricType: .duration(metric: interactor.sleepOnsetMetric.target))) {
            ReportCompactCard(text: "Sleep Onset",
                              value: DateComponentsFormatter.mediumDuration
                                .string(from: TimeInterval(sessionMetric.sleepOnset)) ?? "")
        }
    }

    var percentSleepView: some View {
        NavigationLink(destination:
                        TrendedMetricView(title: "% Time Asleep",
                                          metricType: .ratio(metricA: interactor.sleepPercentMetric.target,
                                                             metricB: interactor.recordingTimeMetric.target,
                                                             category: "sleep"))) {
            ReportCompactCard(text: "% Time Asleep",
                              value: String(format: "%.f%%", Double(sessionMetric.sleepDuration) /
                                                Double(sessionMetric.recordDuration) * 100))
        }
    }
}

struct SleepTimesView_Previews: PreviewProvider {
    static var previews: some View {
        SleepTimesView(repo: AppInjection.defaultValue.repositories.dataRepo, sessionMetric: SleepSessionMetric.mock)
            .environment(\.injected, AppInjection.defaultValue)
    }
}
