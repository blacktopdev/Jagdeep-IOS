//
//  GraphShowcaseView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 10/8/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI
import SciChart

struct GraphShowcaseView: UIViewRepresentable {

    let pointCount = 100

    let freqLine1 = 6.3
    let freqLine2 = 10.2
    let freqLine3 = 16.7

    @State var timerHolder = TimerHolder(withTimeInterval: 1.0/30.0)

    @State var chartSurface = SCIChartSurface()

    let dataSeries1 = SCIXyDataSeries(xType: .double, yType: .double)
    let dataSeries2 = SCIXyDataSeries(xType: .double, yType: .double)
    let dataSeries3 = SCIXyDataSeries(xType: .double, yType: .double)

    let started = Date()

    func makeUIView(context: Context) -> SCIChartSurface {
        timerHolder.onTimerAction = {
            self.appendNextPoint()
        }
        return createSurface()
    }

    func updateUIView(_ uiView: SCIChartSurface, context: Context) {}

    private func createRenderable1() -> SCIFastLineRenderableSeries {
        let series = SCIFastLineRenderableSeries()
        dataSeries1.fifoCapacity = 100

        dataSeries1.append(x: (0..<pointCount).map { Double($0) },
                           y: yValues(freq: freqLine1))

        series.dataSeries = dataSeries1
        series.strokeStyle = SCISolidPenStyle(colorCode: 0xFF3532DC, thickness: 2.0)

        return series
    }

    private func createRenderable2() -> SCIFastLineRenderableSeries {
        let series = SCIFastLineRenderableSeries()
        dataSeries2.fifoCapacity = 100

        dataSeries2.append(x: (0..<pointCount).map { Double($0) },
                           y: yValues(freq: freqLine2))

        series.dataSeries = dataSeries2
        series.strokeStyle = SCISolidPenStyle(colorCode: 0xFF834971, thickness: 2.0)

        return series
    }

    private func createRenderable3() -> SCIFastLineRenderableSeries {
        let series = SCIFastLineRenderableSeries()
        dataSeries3.fifoCapacity = 100

        dataSeries3.append(x: (0..<pointCount).map { Double($0) },
                           y: yValues(freq: freqLine3))

        series.dataSeries = dataSeries3
        series.strokeStyle = SCISolidPenStyle(colorCode: 0xFFD46200, thickness: 2.0)

        return series
    }

    private func createSurface() -> SCIChartSurface {
        let xAxis = SCINumericAxis()
        let yAxis = SCINumericAxis()

//        xAxis.axisTitle = "Time"
//        yAxis.axisTitle = "Amp"

        xAxis.visibleRange = SCIDoubleRange(min: 0, max: Double(pointCount))
        yAxis.visibleRange = SCIDoubleRange(min: -1, max: 1)

        chartSurface.xAxes.add(xAxis)
        chartSurface.yAxes.add(yAxis)

        // add styles

        chartSurface.renderableSeries.add(createRenderable1())
        chartSurface.renderableSeries.add(createRenderable2())
        chartSurface.renderableSeries.add(createRenderable3())

        return chartSurface
    }

    private func appendNextPoint() {
//        let elapsed = -started.timeIntervalSinceNow
//        dataSeries1.append(x: elapsed, y: sin(elapsed))

        SCIUpdateSuspender.usingWith(chartSurface) {
            dataSeries1.update(y: yValues(freq: freqLine1), at: 0)
            dataSeries2.update(y: yValues(freq: freqLine2), at: 0)
            dataSeries3.update(y: yValues(freq: freqLine3), at: 0)
        }
    }

    private func yValues(freq: Double) -> [Double] {
        let phase = -started.timeIntervalSinceNow
//        let phase = 1.0

//        let ratio1 = freq / 6 / 3
//        let ratio2 = freq / 1.898834

        let freq2 = freq * 0.267 // ratio1
        let freq3 = freq * 3.3 // ratio2
        return (0..<pointCount).map {
            let uPoint = Double($0) / Double(pointCount)
            let tone1 = sin(phase * freq * 0.1 + uPoint * freq)
            let tone2 = sin(phase * freq2 * -0.1 + uPoint * freq2)
            let tone3 = sin(phase * freq3 * 0.087 + uPoint * freq3) * 0.2
            return (tone1 + tone2 + tone3) / 2.2
//            return (tone1 + tone2) / 2
//            return tone1
        }
    }
}

//struct GraphShowcaseView: View {
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//
//    var body: some View {
//        let view = GraphShowcaseRawView()
//        return view
////        GraphShowcaseView()
//            .onReceive(timer) { _ in
//
//                view.appendNextPoint(frequency: 0.3)
//            }
//    }
//}

struct GraphShowcaseView_Previews: PreviewProvider {
    static var previews: some View {
        SCIChartSurface.setRuntimeLicenseKey(Constants.sciChartLicenseKey)
        return GraphShowcaseView()
    }
}
