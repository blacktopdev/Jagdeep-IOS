//
//  TrendedMetricView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/4/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

enum TrendWindow {
    case week
    case month
    case quarter
    case year

    var roughDayCount: Int {
        switch self {
        case .week: return 7
        case .month: return 30
        case .quarter: return 90
        case .year: return 365
        }
    }
}

struct TrendedMetricView: View {

    let title: String
    let metricType: AggregateMetricType
    @ObservedObject var metric: TrendedMetric

    @State private var selectedWindow = TrendWindow.week

    init(title: String, metricType: AggregateMetricType) {
        self.title = title
        self.metricType = metricType
        self.metric = metricType.metric
    }

    var dateRangeString: String {
        switch selectedWindow {
        case .week:
            return Constants.DateFormatters.dateRange(with: Date(), subtracting: .day, value: 7)
        case .month:
            return Constants.DateFormatters.dateRange(with: Date(), subtracting: .month, value: 1)
        case .quarter:
            return Constants.DateFormatters.dateRange(with: Date(), subtracting: .month, value: 3)
        case .year:
            return Constants.DateFormatters.dateRange(with: Date(), subtracting: .year, value: 1)
        }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                Picker(selection: $selectedWindow, label: Text("Window"), content: {
                    Text("Week").tag(TrendWindow.week)
                    Text("Month").tag(TrendWindow.month)
                    Text("Quarter").tag(TrendWindow.quarter)
                    Text("Year").tag(TrendWindow.year)
                })
                .pickerStyle(SegmentedPickerStyle())
                .padding(Constants.Metrics.padding)
                .colorScheme(.dark)

                Text(dateRangeString)
                    .footnoteFont()
                    .padding(.bottom, Constants.Metrics.padding)

                TrendGraphView(window: selectedWindow, metricType: metricType)
                    .frame(maxWidth: .infinity)
                    .frame(height: 306)

                Text("\(title) by Night")
                    .headerCardTheme()
            }
            .padding([.leading, .trailing], Constants.Metrics.padding)

            dailyMetrics
        }
        .fullscreenTheme()
        .navigationTitle(title)
    }

    var dailyMetrics: some View {
        VStack(spacing: 0) {
            ForEach(0..<rowCount, id: \.self) { index in
                TrendedMetricRowView(type: metricType, index: index)
            }
        }
    }

    private var rowCount: Int { min(selectedWindow.roughDayCount, metricType.metric.yearData.count) }
}

struct TrendedMetricView_Previews: PreviewProvider {
    static var metric: TrendedMetric {
        let result = TrendedMetric()
        result.yearData = FakeDataSource.shared.randomTrendData(range: 0..<365,
                                                                 filterWidth: 0).map { $0.y }
        return result
    }

    static var previews: some View {
        TrendedMetricView(title: "Sleep Time", metricType: .quality(metric: metric))
    }
}
