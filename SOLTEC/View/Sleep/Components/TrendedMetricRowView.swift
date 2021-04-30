//
//  WeekTrendRowView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/5/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct TrendedMetricRowView: View {
    let type: AggregateMetricType
    let index: Int

    private let text: String
    private let nuance: String?
    private let date: Date

    init(type: AggregateMetricType, index: Int) {
        self.type = type
        self.index = index

        switch type {
        case .quality(let metric):
            self.text = "\(Constants.DateFormatters.ordinal.string(from: floor(metric.yearData[index] / 10) * 10 as NSNumber) ?? "0th") percentile"
            self.nuance =  String(format: "%.1f", metric.yearData[index])
            self.date = Calendar.current.date(byAdding: .day, value: Int(metric.yearData[index]), to: Date()) ?? Date()
        case .duration(let metric):
            self.text = DateComponentsFormatter.mediumDuration.string(from: metric.yearData[index]) ?? ""
            self.nuance = nil
            self.date = Calendar.current.date(byAdding: .day, value: Int(metric.yearData[index]), to: Date()) ?? Date()
        case .ratio(let metricA, let metricB, _):
            self.text = DateComponentsFormatter.mediumDuration.string(from: metricA.yearData[index] * metricB.yearData[index] / 100) ?? ""
            self.nuance = String(format: "%.f%%", metricA.yearData[index])
            self.date = Calendar.current.date(byAdding: .day, value: Int(metricA.yearData[index]), to: Date()) ?? Date()
        case .index(let metric):
            self.text =  String(format: "%.f per hour", metric.yearData[index])
            self.nuance = String(format: "%.1f", metric.yearData[index])
            self.date = Calendar.current.date(byAdding: .day, value: Int(metric.yearData[index]), to: Date()) ?? Date()
        case .count(let metric, let category):
            self.text = "\(Int(metric.yearData[index])) \(category)"
            self.nuance = "\(Int(metric.yearData[index]))"
            self.date = Calendar.current.date(byAdding: .day, value: Int(metric.yearData[index]), to: Date()) ?? Date()
        default:
            self.text = ""
            self.nuance = nil
            self.date = Date()
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    Text(Constants.DateFormatters.dayName.string(from: date))
                        .rowTitleFont()

                    Text(Constants.DateFormatters.medium.string(from: date))
                            .conciseBodyFont()
                        .foregroundColor(.appMono8E)
                }

                Spacer()

                HStack(spacing: 0) {
                    if let nuance = nuance {
                        Text("\(text) (")
                            .rowTitleFont(weight: .regular)
                            .foregroundColor(.appMono8E)

                        Text(nuance)
                            .rowTitleFont(weight: .bold)

                        Text(")")
                            .rowTitleFont(weight: .regular)
                            .foregroundColor(.appMono8E)
                    } else {
                        Text(text)
                            .rowTitleFont(weight: .regular)
                            .foregroundColor(.appMono8E)
                    }
                }
            }
            .padding([.top, .bottom], Constants.Metrics.rowPadding)
            .padding([.leading, .trailing], Constants.Metrics.padding)

            ListDividerView()
                .padding([.leading], Constants.Metrics.padding)
        }
        .background(Color.appMono19)
    }
}

struct WeekTrendRowView_Previews: PreviewProvider {
    static var metric: TrendedMetric {
        let result = TrendedMetric()
        result.yearData = FakeDataSource.shared.randomTrendData(range: 0..<365,
                                                                 filterWidth: 0).map { $0.y }
        return result
    }

    static var previews: some View {
        VStack(spacing: 0) {
            TrendedMetricRowView(type: .quality(metric: metric), index: 0)

            TrendedMetricRowView(type: .duration(metric: metric), index: 0)

            TrendedMetricRowView(type: .ratio(metricA: metric, metricB: metric, category: "ratio"), index: 0)

            TrendedMetricRowView(type: .index(metric: metric), index: 0)

            TrendedMetricRowView(type: .count(metric: metric, category: "arousals"), index: 0)
        }
        //        .fullscreenTheme()
        .foregroundColor(Color.appMonoD8)
        .previewLayout(.sizeThatFits)
    }
}
