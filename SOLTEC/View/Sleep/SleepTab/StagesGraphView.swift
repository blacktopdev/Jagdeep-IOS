//
//  StagesReportGraphView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/15/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct StagesGraphView: View {

    enum Style {
        case standard
        case o2se
        case minimal
    }

    let session: SleepSession
    let style: Style
    private let xStride: Double = 1 * 3600

    var body: some View {
        ZStack(alignment: .topLeading) {
            if style == .minimal {
                graphView
            } else {
                graphView
                    .padding(.top, 30)
                VStack(alignment: .leading, spacing: 104) {
                    Text("IDEAL NORMAL SLEEP")
                    HStack {
                        Text("YOUR SLEEP")
                        Spacer()
                    }
                    .padding(.top, 8)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .background(Color.appMono25)
                }
                .standardFont(size: 13, weight: .semibold)
                .foregroundColor(.appMonoF8)
            }
        }
    }

    private var graphView: some View {
        MultiGraphView(specs: graphSpecs,
                       axisSpacing: CGSize(width: Constants.Metrics.padding, height: 20),
                       layout: StagesLayoutProvider(style: style))
    }

    private var graphSpecs: [[GraphSpec]] {
        switch style {
        case .minimal:
            return [[graphSpecINS]]
        case .standard:
            return [[graphSpecINS],
                     [graphSpecINS],
                     [graphSpecMotion],
                     [graphSpecArousal]]
        case .o2se:
            return [[graphSpecINS],
                     [graphSpecINS],
                     [graphSpecO2SE],
                     [graphSpecO2Drop],
                     [graphSpecSnore],
                     [graphSpecArousal]]
        }
    }

    private var xLabelProvider: GraphDateLabelProvider? {
        return style == .minimal ? nil : GraphDateLabelProvider(stride: xStride * 2,
                                                                offset: 0,
                                                                formatter: Constants.DateFormatters.timeOfDay)
    }

    private var xGridProvider: GraphStandardGridProvider? {
        return style == .minimal ? nil : GraphStandardGridProvider(stride: xStride,
                                                                   offset: 0,
                                                                   strokeWidth: 1, dashPattern: [6])
    }

    private var yLabelProvider: GraphStandardLabelProvider? {
        return style == .minimal ? nil : StagesLabelProvider(stride: 1, offset: 0)
    }

    private var fill: GraphFillStyle {
        return style == .minimal ? .color(Color.appMonoF8.opacity(0.24)) : .linearGradient(LinearGradient(gradient: Color.eveningGradient, startPoint: .top, endPoint: .bottom))
    }

    private func divider(withHeight height: CGFloat, alignment: Alignment, offset: CGFloat) -> some View {
        VStack(spacing: 0) {
            if alignment == .bottom {
                Spacer()
            }
            Rectangle().fill(Color.black.opacity(0.19))
                .frame(height: height)
                .offset(x: 0, y: offset)
            if alignment == .top {
                Spacer()
            }
        }
        .frame(maxHeight: .infinity)
    }

    private func xAxisBuilder(_ view: AnyView) -> AnyView {
        AnyView(view.background(divider(withHeight: 1, alignment: .top, offset: -5)))
    }

    private func motionContentBuilder(_ view: AnyView) -> AnyView {
        AnyView(view.background(divider(withHeight: 2, alignment: .bottom, offset: 2)))
    }

    private var strokeMargins: EdgeInsets {
        switch style {
        case .minimal:
            return EdgeInsets()
        default:
            return EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
        }
    }

    private let gridFill = GraphFillStyle.color(Color.appMonoA3.opacity(0.33))

    private let labelFill = GraphFillStyle.color(Color.appMonoD8.opacity(0.4))
    private let yAxisFont = Constants.Fonts.standardFont(size: 10)
    private let xAxisFont = Constants.Fonts.standardFont(size: 12)

    private var graphSpecINS: GraphSpec {
        let dataSeries = GraphDataSeries(name: "INS",
                                         data: session.epochPointData(keyPath: \.stage.final.sleepLevel),
                                         rangeY: 0...3)

        let xAxis = GraphAxis(name: "Time", direction: .horizontal, labelFill: labelFill,
                              labelProvider: xLabelProvider, gridProvider: xGridProvider)
        let yAxis = GraphAxis(name: "Stage", direction: .vertical, labelFill: labelFill, font: yAxisFont,
                              labelProvider: yLabelProvider)

        let dataViewBar = GraphDataSeriesView(name: "INS",
                                              series: dataSeries,
                                              style: .line,
                                              strokeWidth: 4,
                                              cornerRadius: 4,
                                              fill: fill,
                                              timingCurve: Constants.Metrics.graphAnimationCurve,
                                              stagger: Constants.Metrics.graphAnimationStagger)
        return GraphSpec(xAxis: xAxis, yAxis: yAxis, seriesViews: [dataViewBar], gridFill: gridFill,
                         strokeMargins: strokeMargins)
    }

    private var graphSpecO2SE: GraphSpec {
        let dataSeries = GraphDataSeries(name: "O2SE",
                                         data: session.eventPointData(keyPath: \.o2ses),
                                         rangeY: 0...10)

        let xAxis = GraphAxis(name: "Time", direction: .horizontal, labelFill: labelFill,
                              labelProvider: xLabelProvider, gridProvider: xGridProvider)
        let yAxis = GraphAxis(name: "Level", direction: .vertical, labelFill: labelFill, font: yAxisFont,
                              labelProvider: GraphBasicLabelProvider(stride: 10, offset: 5, text: "O2SE"))
        let dataViewBar = GraphDataSeriesView(name: "O2SE",
                                              series: dataSeries,
                                              style: .bar,
                                              strokeWidth: 3,
                                              cornerRadius: 2,
                                              fill: .color(.appBlue),
                                              timingCurve: Constants.Metrics.graphAnimationCurve,
                                              stagger: Constants.Metrics.graphAnimationStagger)
        return GraphSpec(xAxis: xAxis, yAxis: yAxis, seriesViews: [dataViewBar], gridFill: gridFill,
                         builder: motionContentBuilder)
    }

    private var graphSpecO2Drop: GraphSpec {
        let dataSeries = GraphDataSeries(name: "o2Drop",
                                         data: session.eventPointData(keyPath: \.desaturations, inverted: true),
                                         rangeY: -10...0)

        let xAxis = GraphAxis(name: "Time", direction: .horizontal, labelFill: labelFill,
                              labelProvider: xLabelProvider, gridProvider: xGridProvider)
        let yAxis = GraphAxis(name: "Level", direction: .vertical, labelFill: labelFill, font: yAxisFont,
                              labelProvider: GraphBasicLabelProvider(stride: 10, offset: 5, text: "O2 DROP"))
        let dataViewBar = GraphDataSeriesView(name: "o2Drop",
                                              series: dataSeries,
                                              style: .bar,
                                              strokeWidth: 3,
                                              cornerRadius: 2,
                                              fill: .color(.appMagentaDark),
                                              timingCurve: Constants.Metrics.graphAnimationCurve,
                                              stagger: Constants.Metrics.graphAnimationStagger)
        return GraphSpec(xAxis: xAxis, yAxis: yAxis, seriesViews: [dataViewBar], gridFill: gridFill)
    }

    private var graphSpecSnore: GraphSpec {
        let dataSeries = GraphDataSeries(name: "Snore",
                                         data: session.eventPointData(keyPath: \.sounds),
                                         rangeY: 0...10)

        let xAxis = GraphAxis(name: "Time", direction: .horizontal, labelFill: labelFill,
                              labelProvider: xLabelProvider, gridProvider: xGridProvider)
        let yAxis = GraphAxis(name: "Level", direction: .vertical, labelFill: labelFill, font: yAxisFont,
                              labelProvider: GraphBasicLabelProvider(stride: 10, offset: 5, text: "SNORE"))
        let dataViewBar = GraphDataSeriesView(name: "Snore",
                                              series: dataSeries,
                                              style: .bar,
                                              strokeWidth: 3,
                                              cornerRadius: 2,
                                              fill: .color(.appBlue),
                                              timingCurve: Constants.Metrics.graphAnimationCurve,
                                              stagger: Constants.Metrics.graphAnimationStagger)
        return GraphSpec(xAxis: xAxis, yAxis: yAxis, seriesViews: [dataViewBar],
                         gridFill: gridFill, builder: motionContentBuilder)
    }

    private var graphSpecMotion: GraphSpec {
        let dataSeries = GraphDataSeries(name: "Motion",
                                         data: session.eventPointData(keyPath: \.motions),
                                         rangeY: 0...10)

        let xAxis = GraphAxis(name: "Time", direction: .horizontal, labelFill: labelFill,
                              labelProvider: xLabelProvider, gridProvider: xGridProvider)
        let yAxis = GraphAxis(name: "Level", direction: .vertical, labelFill: labelFill, font: yAxisFont,
                              labelProvider: GraphBasicLabelProvider(stride: 10, offset: 5, text: "MOTION"))
        let dataViewBar = GraphDataSeriesView(name: "Motion",
                                              series: dataSeries,
                                              style: .bar,
                                              strokeWidth: 3,
                                              cornerRadius: 2,
                                              fill: .color(.appBlue),
                                              timingCurve: Constants.Metrics.graphAnimationCurve,
                                              stagger: Constants.Metrics.graphAnimationStagger)
        return GraphSpec(xAxis: xAxis, yAxis: yAxis, seriesViews: [dataViewBar],
                         gridFill: gridFill, builder: motionContentBuilder)
    }

    private var graphSpecArousal: GraphSpec {
        let dataSeries = GraphDataSeries(name: "Arousal",
                                         data: session.eventPointData(keyPath: \.arousals, inverted: true),
                                         rangeY: -10...0)

        let xAxis = GraphAxis(name: "Time", direction: .horizontal, labelFill: labelFill, font: xAxisFont,
                              labelProvider: xLabelProvider, gridProvider: xGridProvider, builder: xAxisBuilder)
        let yAxis = GraphAxis(name: "Level", direction: .vertical, labelFill: labelFill, font: yAxisFont,
                              labelProvider: GraphBasicLabelProvider(stride: 10, offset: 5, text: "AROUSAL"))
        let dataViewBar = GraphDataSeriesView(name: "Arousal",
                                              series: dataSeries,
                                              style: .bar,
                                              strokeWidth: 3,
                                              cornerRadius: 2,
                                              fill: .color(.appMagentaDark),
                                              timingCurve: Constants.Metrics.graphAnimationCurve,
                                              stagger: Constants.Metrics.graphAnimationStagger)
        return GraphSpec(xAxis: xAxis, yAxis: yAxis, seriesViews: [dataViewBar], gridFill: gridFill)
    }
}

private class StagesLabelProvider: GraphStandardLabelProvider {
    override func label(for value: T) -> String? {
        return SleepStageType.type(forLevel: Int(3 - value)).name.uppercased()
    }
}

private struct StagesLayoutProvider: GraphLayoutProvider {
    let style: StagesGraphView.Style

    func size(forAxis axis: Axis, index: Int) -> CGFloat {
        if style == .minimal || axis == .horizontal { return 0 }
        else if index < 2 { return 78 }
        return 20
    }

    func spacing(afterAxis axis: Axis, index: Int) -> CGFloat {
        if style == .minimal || axis == .horizontal { return 0 }
        else if index < 1 { return 62 }
        else if index < 2 { return 32 }
        return 2
    }
}

struct StagesGraphView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 60) {
            StagesGraphView(session: SleepSession.mock, style: .standard)
            StagesGraphView(session: SleepSession.mock, style: .o2se)
            StagesGraphView(session: SleepSession.mock, style: .minimal)
                .frame(height: 44)
        }
        .padding()
        .background(Color.appMono25)
        .previewLayout(.sizeThatFits)
//        .environment(\.locale, Locale(identifier: "ar-QA"))
    }
}
