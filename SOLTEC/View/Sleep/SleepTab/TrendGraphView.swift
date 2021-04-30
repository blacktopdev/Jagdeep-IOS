//
//  TrendGraphView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/6/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct TrendGraphView: View {
    let window: TrendWindow
    let metricType: AggregateMetricType
    @ObservedObject var metric: TrendedMetric

    // used to calculate the bar chart stroke width
    @State private var graphSize = CGSize.zero

    init(window: TrendWindow, metricType: AggregateMetricType) {
        self.window = window
        self.metricType = metricType

        switch metricType {

        case .quality(let metric):
            self.metric = metric
        case .duration(let metric):
            self.metric = metric
        case .ratio(let metricA, _, _):
            self.metric = metricA
        case .index(let metric):
            self.metric = metric
        case .count(let metric, _):
            self.metric = metric
        case .event(let metric):
            self.metric = metric
        }
    }

    private var xLabelProvider: CalendarLabelProvider {
        let startDate = Date() //Calendar.current.date(byAdding: .day, value: -window.roughDayCount, to: Date()) ?? Date()
        switch window {
        case .week: return CalendarLabelProvider(stride: 1, startDate: startDate, window: window)
        case .month: return CalendarLabelProvider(stride: 7, startDate: startDate, window: window)
        case .quarter:
            let offset = (Calendar.current.dateComponents([.day], from: startDate).day ?? 1) - 1
            return CalendarLabelProvider(stride: 30, offset: Double(-offset),
                                         startDate: startDate, window: window)
        case .year: return CalendarLabelProvider(stride: 90, startDate: startDate, window: window)
        }
    }

    private var strokeWidthRatio: CGFloat {
        switch window {
        case .week: return CGFloat(24) / CGFloat(24+20)
        case .month: return CGFloat(6) / CGFloat(6+4)
        case .quarter: return CGFloat(2) / CGFloat(2+1)
        case .year: return 1
        }
    }

    private var dataPoints: [GraphStandardPoint] {
        metric.pointsForDays(window.roughDayCount)
    }

    private let labelFill = GraphFillStyle.color(Color.appMonoD8.opacity(0.4))

    var yRange: ClosedRange<Double>? {
        switch metricType {
        case .quality, .ratio:
            return 0...100
        default:
            return nil
        }
    }

    var labelProvider: GraphStandardLabelProvider {
        switch metricType {
        case .duration:
            return GraphStandardLabelProvider(stride: 30*60, offset: 0,
                                              formatter: DurationFormatter(), hideZero: false)
        case .count:
            return GraphStandardLabelProvider(stride: 10, offset: 0,
                                              formatter: NumberFormatter(), hideZero: false)
        case .index:
            return GraphStandardLabelProvider(stride: 1, offset: 0,
                                              formatter: NumberFormatter(), hideZero: false)
        default:
            return GraphStandardLabelProvider(stride: 20, offset: 0,
                                              formatter: NumberFormatter(), hideZero: true)
        }
    }

    var gridProvider: GraphStandardGridProvider {
        switch metricType {
        case .duration:
            return GraphStandardGridProvider(stride: 60*60, offset: 30*60, strokeWidth: 1)
        case .count:
            return GraphStandardGridProvider(stride: 10, offset: 5, strokeWidth: 1)
        case .index:
            return GraphStandardGridProvider(stride: 1, offset: 0, strokeWidth: 1)
        default:
            return GraphStandardGridProvider(stride: 20, offset: 10, strokeWidth: 1)
        }
    }

    private var graphView: some View {
        let xAxis = GraphAxis(name: "Time", direction: .horizontal, labelFill: labelFill,
                              labelProvider: xLabelProvider)
        let yAxis = GraphAxis(name: "Y", direction: .vertical, labelFill: labelFill,
                              labelProvider: labelProvider,
                              gridProvider: gridProvider)
        let dataSeries = GraphDataSeries(name: "Main Series",
                                         data: dataPoints,
                                         rangeY: yRange)

//        let strokeWidth = floor(graphSize.width / CGFloat(dataSeries.data.count) * strokeWidthRatio)
        let strokeWidth = graphSize.width / CGFloat(dataSeries.data.count) * strokeWidthRatio
        let dataViewBar = GraphDataSeriesView(name: "bar view",
                                              series: dataSeries,
                                              style: window == .year ? .mountain : .bar,
                                              strokeWidth: strokeWidth,
                                              cornerRadius: 3,
                                              fill: .color(.appBlue),
                                              timingCurve: Constants.Metrics.graphAnimationCurve,
                                              stagger: Constants.Metrics.graphAnimationStagger)

//       return MultiGraphView(specs: [[GraphSpec(xAxis: xAxis, yAxis: yAxis, seriesViews: [dataViewBar])]])
        let spec = GraphSpec(xAxis: xAxis, yAxis: yAxis, seriesViews: [dataViewBar],
                             gridFill: .color(Color.appMonoA3.opacity(0.1)))
        return GraphView(spec: spec)
//        return GraphView(xAxis: xAxis, yAxis: yAxis, seriesViews: [dataViewBar])
    }
    
    var body: some View {
        graphView
            .id("\(window)-\(graphSize.width)-\(graphSize.height)")
            .onPreferenceChange(GraphPreferenceKey.self) { preferences in
                for p in preferences {
                    graphSize = p.rect.size
                }
            }
    }
}

private class CalendarLabelProvider: GraphStandardLabelProvider {
    let startDate: Date
    let window: TrendWindow

    init(stride: T, offset: T = 0, startDate: Date, window: TrendWindow) {
        self.startDate = startDate
        self.window = window
        super.init(stride: stride, offset: offset)
    }

    override func label(for value: T) -> String? {
        let date = Calendar.current.date(byAdding: .day, value: Int(value), to: startDate)
        switch window {
        case .week:
            return Constants.DateFormatters.dayNameShort.string(from: date ?? Date())
        case .month:
            return Constants.DateFormatters.dayInMonth.string(from: date ?? Date())
        default:
            return Constants.DateFormatters.monthShort.string(from: date ?? Date())
        }
    }
}

class MinuteDurationFormatter: Formatter {
    override func string(for obj: Any?) -> String? {
        guard let duration = obj as? TimeInterval else { return nil }
        return String(format: "%.f", duration / 60)
    }
}

class DurationFormatter: Formatter {
    override func string(for obj: Any?) -> String? {
        guard let duration = obj as? TimeInterval else { return nil }
        return DateComponentsFormatter.shortDuration.string(from: duration)
    }
}

struct TrendGraphView_Previews: PreviewProvider {
    static var metric: TrendedMetric {
        let result = TrendedMetric()
        result.yearData = FakeDataSource.shared.randomTrendData(range: 0..<365,
                                                                 filterWidth: 0).map { $0.y * 10 }
        return result
    }

    static var previews: some View {
        VStack {
            TrendGraphView(window: .month, metricType: .duration(metric: metric))
                .frame(height: 300)
                .background(Color.appMono19)
                .fullscreenTheme()
        }
    }
}
