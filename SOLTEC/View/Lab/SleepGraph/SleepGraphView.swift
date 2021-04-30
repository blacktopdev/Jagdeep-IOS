//
//  DataTypeGrapher.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 10/8/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI
import SciChart.Protected.SCILabelProviderBase
import SciChart.Protected.SCIAnnotationBase
import SciChart.Protected.SCIRangeCalculatorHelperBase

private let standardStrokeWidth: Float = 1.5 

struct SleepGraphView: UIViewRepresentable {

    enum PathMode {
        case `default`
        case smooth
    }

    enum GraphStyle {
        case `default`
        case motion
        case motionCounts
        case arousals
        case stage
    }

    enum GeometryType: String {
        case ups
        case downs
        case flats
    }

    @ObservedObject var dataSource: SleepLabDataSource
    let graphStyle: GraphStyle
    var chartGroup: SCIChartVerticalGroup?

    @State private var chartSurface = SCIChartSurface()
//    @State private var didChangeDataset: Bool = false

    private var preferences: SleepLabPreferences { dataSource.preferences }

//    private var pathObserver: NSObject?

//    init(dataSource: SleepLabDataSource, graphStyle: GraphStyle, chartGroup: SCIChartVerticalGroup? = nil) {
//        self.dataSource = dataSource
//        self.graphStyle = graphStyle
//        self.chartGroup = chartGroup
//
//        pathObserver = dataSource.$selectedSleepNormalsPath.observe { (old, new) in
//            self.didChangeDataset = true
//        }
//    }

    func makeUIView(context: Context) -> SCIChartSurface {
        initializeSurface()
        return chartSurface
    }

    func updateUIView(_ uiView: SCIChartSurface, context: Context) {
        SCIUpdateSuspender.usingWith(chartSurface) {
            configureSurface()
        }
    }

    private func normalDataSeries(forType type: SleepSignalType) -> SCIXyDataSeries {
        let series = SCIXyDataSeries(xType: .float, yType: .float)
        series.seriesName = type.rawValue
        var yValues = SignalFilter.filtered(data: normals.map { $0.value(forType: type) },
                                            mode: preferences.normal.filterMode,
                                            width: preferences.normal.filterWidth,
                                            alpha: preferences.normal.filterAlpha)
        if !preferences.normal.isNormalized,
           let mean = dataSource.dataSet.aggregates?.value(forType: type).mean {
            yValues = yValues.map { $0 / 100 * mean }
        }
        series.append(x: (0..<normals.count).map { Float($0) },
                      y: yValues)
        return series
    }

    private func levelDataSeries(forLevel level: Float, name: String) -> SCIXyDataSeries {
        let series = SCIXyDataSeries(xType: .float, yType: .float)
        series.seriesName = name
        series.append(x: [Float(0), Float(normals.count - 1)], y: [level, level])
        return series
    }

    private func levelRenderable(forLevel level: Float, name: String, color: UIColor) -> SCIXyRenderableSeriesBase {
        let series = SCIFastLineRenderableSeries()
        series.dataSeries = levelDataSeries(forLevel: level, name: name)
        series.strokeStyle = SCISolidPenStyle(colorCode: UInt32(color.hexColor),
                                              thickness: standardStrokeWidth,
                                              strokeDashArray: [7, 3], antiAliasing: true)
        return series
    }

    private func normalRenderables() -> [SCIXyRenderableSeriesBase] {
        var renderables: [SCIXyRenderableSeriesBase] = preferences.normal.selectedTypes.map { type in
            let series = SCIFastLineRenderableSeries()
            series.dataSeries = normalDataSeries(forType: type)
            series.strokeStyle = SCISolidPenStyle(colorCode: UInt32(type.color.hexColor), thickness: standardStrokeWidth)
            return series
        }

        if let level = dataSource.dataSet.level, preferences.normal.isNormalized {
            if preferences.normal.showWakeRemLevel {
                renderables.append(levelRenderable(forLevel: level.wakeRem, name: "Wake-REM Level",
                                                   color: SleepSignalType.highRatio.color))
            }
            if preferences.normal.showWakeLevel {
                renderables.append(levelRenderable(forLevel: level.wake, name: "Wake Level",
                                                   color: SleepSignalType.veryLowRatio.color))
            }
            if preferences.normal.showRemLevel {
                renderables.append(levelRenderable(forLevel: level.rem, name: "REM Level",
                                                   color: SleepSignalType.newBandRatio.color))
            }
        }
        return renderables
    }

    private func motionDataSeries() -> (SCIXyDataSeries, SCIXyDataSeries) {
        let series1 = SCIXyDataSeries(xType: .float, yType: .float)
        series1.seriesName = "motionMean"
        let series2 = SCIXyDataSeries(xType: .float, yType: .float)
        series2.seriesName = "motionMax"

        series1.append(x: 0, y: Float.nan)
        series2.append(x: 0, y: Float.nan)
        for motion in motions where Int(motion.started) <= (normals.count - 1) * 30 {
            let midPoint = (motion.started + motion.stopped) / 30.0 / 2
            series1.append(x: midPoint, y: motion.intensityMean)
            series2.append(x: midPoint, y: motion.intensityMax)
        }
        series1.append(x: normals.count - 1, y: Float.nan)
        series2.append(x: normals.count - 1, y: Float.nan)

        return (series1, series2)
    }

    private func motionRenderables() -> [SCIXyRenderableSeriesBase] {
        let renderMean = SCIFastImpulseRenderableSeries()
        let renderMax = SCIFastImpulseRenderableSeries()
        (renderMean.dataSeries, renderMax.dataSeries) = motionDataSeries()

        let mix = UIColor(mixingColor: .cyan, intoColor: .magenta, atAlpha: 0.5, finalAlpha: 1)
        let darkColor = UIColor(mixingColor: .black, intoColor: .magenta, atAlpha: 0.6, finalAlpha: 1)

        // max
        renderMax.strokeStyle = SCISolidPenStyle(colorCode: UIColor.magenta.hexColor, thickness: standardStrokeWidth)
        let pointMarker1 = SCIEllipsePointMarker()
        pointMarker1.size = CGSize(width: 5, height: 5)
        pointMarker1.fillStyle = SCISolidBrushStyle(colorCode: UIColor.magenta.hexColor)
        renderMax.pointMarker = pointMarker1

        // mean
        renderMean.strokeStyle = SCISolidPenStyle(colorCode: darkColor.hexColor, thickness: standardStrokeWidth)
        let pointMarker2 = SCIEllipsePointMarker()
        pointMarker2.size = CGSize(width: 5, height: 5)
        pointMarker2.fillStyle = SCISolidBrushStyle(colorCode: mix.hexColor)
        renderMean.pointMarker = pointMarker2

        return [renderMax, renderMean]
    }

    private func motionCountDataSeries() -> SCIXyDataSeries {
        let series = SCIXyDataSeries(xType: .float, yType: .float)
        series.seriesName = "motionCounts"

        series.append(x: 0, y: Float.nan)
        for (index, count) in motionCounts.enumerated() where index < normals.count && count > 0 {
            series.append(x: Float(index), y: Float(count))
        }
        series.append(x: normals.count - 1, y: Float.nan)

        return series
    }

    private func motionCountRenderables() -> [SCIXyRenderableSeriesBase] {
        let series = SCIFastImpulseRenderableSeries()
        series.dataSeries = motionCountDataSeries()
        let darkMagenta = UIColor(mixingColor: .black, intoColor: .magenta, atAlpha: 0.25, finalAlpha: 1)
        series.strokeStyle = SCISolidPenStyle(colorCode: darkMagenta.hexColor, thickness: standardStrokeWidth)

        let pointMarker = SCIEllipsePointMarker()
        pointMarker.size = CGSize(width: 5, height: 5)
        pointMarker.fillStyle = SCISolidBrushStyle(colorCode: UIColor.magenta.hexColor)
        series.pointMarker = pointMarker

        return [series]
    }

    private func arousalDataSeries() -> (SCIXyDataSeries, SCIXyDataSeries) {
        let series1 = SCIXyDataSeries(xType: .float, yType: .float)
        series1.seriesName = "arousalLow"
        let series2 = SCIXyDataSeries(xType: .float, yType: .float)
        series2.seriesName = "arousalHigh"

        series1.append(x: 0, y: Float.nan)
        series2.append(x: 0, y: Float.nan)
        for arousal in arousals where Int(arousal.started) <= (normals.count - 1) * 30 {
            let midPoint = (arousal.started + arousal.stopped) / 30.0 / 2
            series1.append(x: midPoint, y: arousal.pulseLow)
            series2.append(x: midPoint, y: arousal.pulseHigh)
        }
        series1.append(x: normals.count - 1, y: Float.nan)
        series2.append(x: normals.count - 1, y: Float.nan)

        return (series1, series2)
    }

    private func arousalRenderables() -> [SCIXyRenderableSeriesBase] {
        let renderLow = SCIFastImpulseRenderableSeries()
        let renderHigh = SCIFastImpulseRenderableSeries()
        (renderLow.dataSeries, renderHigh.dataSeries) = arousalDataSeries()

        let mix = UIColor(mixingColor: .magenta, intoColor: .yellow, atAlpha: 0.5, finalAlpha: 1)
        let darkYellow = UIColor(mixingColor: .black, intoColor: .yellow, atAlpha: 0.75, finalAlpha: 1)

        renderLow.strokeStyle = SCISolidPenStyle(colorCode: darkYellow.hexColor, thickness: standardStrokeWidth)

        let pointMarker = SCIEllipsePointMarker()
        pointMarker.size = CGSize(width: 5, height: 5)
        pointMarker.fillStyle = SCISolidBrushStyle(colorCode: mix.hexColor)
        renderLow.pointMarker = pointMarker

        renderHigh.strokeStyle = SCISolidPenStyle(colorCode: UIColor.yellow.hexColor, thickness: standardStrokeWidth)

        let pointMarkerHigh = SCIEllipsePointMarker()
        pointMarkerHigh.size = CGSize(width: 5, height: 5)
        pointMarkerHigh.fillStyle = SCISolidBrushStyle(colorCode: UIColor.yellow.hexColor)
        renderHigh.pointMarker = pointMarkerHigh

        return [renderHigh, renderLow]
    }

    var baseProtocolLevel: Float { dataSource.dataSet.level?.wake ?? 150 }

    private func protocolDataSeries() -> SCIXyDataSeries {
        let series = SCIXyDataSeries(xType: .float, yType: .float)
        series.seriesName = "protocols"

        for proto in protocols {
            series.append(x: proto.started / 30,
                          y: baseProtocolLevel + Float(proto.mField) / ProtocolPaletteProvider.mFieldEmbeddedScalar)
        }
        return series
    }

    private func protocolScatterRenderables() -> [SCIXyRenderableSeriesBase] {
        let render = SCIXyScatterRenderableSeries()
        render.dataSeries = protocolDataSeries()

        render.strokeStyle = SCISolidPenStyle(colorCode: UIColor.magenta.hexColor, thickness: standardStrokeWidth)
        let pointMarker1 = SCITrianglePointMarker()
        pointMarker1.size = CGSize(width: 10, height: 10)
        pointMarker1.fillStyle = SCISolidBrushStyle(colorCode: UIColor.magenta.hexColor)
        render.pointMarker = pointMarker1
        render.paletteProvider = ProtocolPaletteProvider(baseLevel: baseProtocolLevel)

        return [render]
    }

    private func protocolBkgDataSeries() -> SCIXyDataSeries {
        let series = SCIXyDataSeries(xType: .float, yType: .float)
        series.seriesName = "protocols"

//        let yAxis = chartSurface.yAxes.first()
//        let yDataMax = Float(yAxis.getDataRange(true).maxAsDouble)

        for (index, proto) in protocols.enumerated() {
            series.append(x: proto.started / 30,
                          y: baseProtocolLevel + Float(proto.mField) / ProtocolPaletteProvider.mFieldEmbeddedScalar)
            let endEpoch = index < protocols.count - 1 ? (proto.started + proto.duration) / 30 : Float(normals.count - 1)
            series.append(x: endEpoch,
                          y: baseProtocolLevel + Float(proto.mField) / ProtocolPaletteProvider.mFieldEmbeddedScalar)

            let text = SCITextAnnotation()
            text.fontStyle = SCIFontStyle(fontSize: 10, andTextColor: .white)
//                                          andTextColor: ProtocolPaletteProvider.color(at: Float(proto.mField)))
            text.text = "\(proto.mField)"
            text.set(x1: proto.started / 30)
            text.set(y1: baseProtocolLevel - 1)
            text.rotationAngle = 90
            chartSurface.annotations.add(text)
        }

        return series
    }

    private func protocolBkgRenderables() -> [SCIXyRenderableSeriesBase] {
        let render = SCIFastMountainRenderableSeries()
        render.dataSeries = protocolBkgDataSeries()

        render.strokeStyle = SCISolidPenStyle(colorCode: UIColor.clear.hexColor, thickness: standardStrokeWidth)
//        render.fillBrushStyle = SCISolidBrushStyle(color: UIColor.green)
//        render.areaStyle = SCISolidBrushStyle(colorCode: UIColor.magenta.hexColor)
        render.paletteProvider = ProtocolPaletteProvider(baseLevel: baseProtocolLevel)
//        render.dataPointWidth = 0.5

        return [render]
    }

    private func stageDataSeries() -> SCIXyDataSeries {
        let series = SCIXyDataSeries(xType: .float, yType: .int)
        series.seriesName = "stage"

        let result = dataSource.filteredStages
        series.append(x: (0..<result.sleepLevels.count).map { Float($0) },
                      y: result.sleepLevels)
        return series
    }

    private func stageRenderables() -> [SCIXyRenderableSeriesBase] {
        let series = SCIFastLineRenderableSeries()
        series.dataSeries = stageDataSeries()
        series.strokeStyle = SCISolidPenStyle(colorCode: UIColor.cyan.hexColor, thickness: standardStrokeWidth)
        return [series]
    }

    private func initializeSurface() {
        // add modifiers
//        chartSurface.addStandardPanZoom()
        let zoom = SCIPinchZoomModifier()
        zoom.direction = .xDirection
        zoom.receiveHandledEvents = true
        zoom.eventsGroupTag = "SharedPinchZoom"

        let pan = SCIZoomPanModifier()
        pan.direction = .xDirection
        pan.clipModeX = .clipAtExtents
        pan.zoomExtentsY = false
        pan.receiveHandledEvents = true
        pan.eventsGroupTag = "SharedPan"

//        let modifierGroup = SCIModifierGroup()
//        let args = SCIModifierEventArgs()
//        modifierGroup.eventsGroupTag = "SharedEventGroup"
//        modifierGroup.receiveHandledEvents = true
//        modifierGroup.childModifiers.add(items: zoom, pan, SCICursorModifier(), SCIZoomExtentsModifier())
        let cursor = SCICursorModifier()
        cursor.receiveHandledEvents = true
        cursor.eventsGroupTag = "SharedCursor"

        let zoomExtents = SCIZoomExtentsModifier()
        if graphStyle == .stage {
            zoomExtents.direction = .xDirection
        }
        zoomExtents.receiveHandledEvents = true
        zoomExtents.eventsGroupTag = "SharedZoomExtents"

        chartSurface.chartModifiers.add(items: zoom, pan, cursor, zoomExtents)
//        chartSurface.chartModifiers.add(modifierGroup)
        chartGroup?.addSurface(toGroup: chartSurface)
    }

    private func configureAxesIfNeeded() {
        guard chartSurface.xAxes.count == 0 else { return }

        let xAxis = SCINumericAxis()
        let yAxis = SCINumericAxis()

        switch graphStyle {

        case .default:
            xAxis.axisTitle = "EPOCH"
            yAxis.autoRange = .once
        case .motion, .motionCounts, .arousals:
            xAxis.setTicksAndLabels(visible: false)
            yAxis.autoRange = .once
        case .stage:
            xAxis.setTicksAndLabels(visible: false)
            yAxis.labelProvider = StageLabelProvider()
            yAxis.autoTicks = false
            yAxis.majorDelta = 1 as ISCIComparable
            yAxis.minorDelta = 1 as ISCIComparable
            yAxis.drawMinorGridLines = false
            yAxis.visibleRange = SCIDoubleRange(min: -0.05, max: 3.05)
            yAxis.autoRange = .never
            yAxis.flipCoordinates = true
            yAxis.isLabelCullingEnabled = false
        }

        let range = SCIDoubleRange(min: 0, max: Double(normals.count - 1))
        xAxis.visibleRangeLimit = range
//        xAxis.visibleRange = range
//        xAxis.autoRange = .always

//        let active = preferences.normal.selectedTypes
//            .union(preferences.upSelectedTypes)
//            .union(preferences.downSelectedTypes)
//            .union(preferences.flatSelectedTypes)
//        let range = loadedValues.aggregateExtents(forTypes: active.map {$0})
        // for some reason SCIFloatRange will crash SciChart here
//        yAxis.visibleRange = SCIDoubleRange(min: Double(range.allExtents.lowerBound),
//                                                 max: Double(range.allExtents.upperBound))


        chartSurface.xAxes.add(xAxis)
        chartSurface.yAxes.add(yAxis)
    }

    private func configureSurface() {
        print("************Updating SURFACE***********")
        chartSurface.renderableSeries.toArray().forEach {
            chartSurface.renderableSeries.remove($0)
        }
        chartSurface.annotations.clear()
        configureAxesIfNeeded()

        // add data
        switch graphStyle {
        case .default:
            protocolBkgRenderables()
                .forEach { chartSurface.renderableSeries.add($0) }
            normalRenderables()
                .forEach { chartSurface.renderableSeries.add($0) }
//            protocolScatterRenderables()
//                .forEach { chartSurface.renderableSeries.add($0) }
        case .motion:
            motionRenderables()
                .forEach { chartSurface.renderableSeries.add($0) }
        case .motionCounts:
            motionCountRenderables()
                .forEach { chartSurface.renderableSeries.add($0) }
        case .arousals:
            arousalRenderables()
                .forEach { chartSurface.renderableSeries.add($0) }
        case .stage:
            stageRenderables()
                .forEach { chartSurface.renderableSeries.add($0) }
        }

        let yAxis = chartSurface.yAxes.first()
        if graphStyle == .default, preferences.normal.isOverridingRange {
            yAxis.visibleRange = SCIDoubleRange(min: Double(preferences.normal.overrideMin),
                                                max: Double(preferences.normal.overrideMax))
            yAxis.autoRange = .never
        } else if graphStyle != .stage {
            yAxis.autoRange = .once

//            let yDataRange = yAxis.getDataRange(true)
//            print("\(yDataRange.minAsDouble), \(yDataRange.maxAsDouble)")
//            if graphStyle != .stage, yDataRange.minAsDouble != yAxis.visibleRange.minAsDouble ||
//                yDataRange.maxAsDouble != yAxis.visibleRange.maxAsDouble {
//                yAxis.visibleRange = yDataRange
//                print("Resetting range")
//            }
        }

//        let xAxis = chartSurface.xAxes.first()
//        let range = SCIDoubleRange(min: 0, max: Double(normals.count - 1))
//        if let oldRange = xAxis.visibleRangeLimit as? SCIDoubleRange {
//            if range.min != oldRange.min || range.max != oldRange.max {
//                xAxis.visibleRangeLimit = range
//                xAxis.visibleRange = range
////                xAxis.visibleRange = nil
//            }
//        }

    }
}

extension SleepGraphView {
    // MARK: - Accessor Convenience
    private var normals: [SleepSignal<Float>] {
        dataSource.dataSet.normals
    }

    private var motions: [SleepMotion] {
        dataSource.dataSet.motions
    }

    private var motionCounts: [Int] {
        dataSource.dataSet.motionCounts
    }

    private var arousals: [SleepArousal] {
        dataSource.dataSet.arousals
    }

    private var protocols: [SleepProtocol] {
        dataSource.dataSet.protocols
    }

    private var stages: [SleepStageType] {
        dataSource.dataSet.stages
    }
}

struct SleepGraphView_Previews: PreviewProvider {
    static var previews: some View {
        SCIChartSurface.setRuntimeLicenseKey(Constants.sciChartLicenseKey)

        return SleepGraphView(dataSource: SleepLabDataSource(preferences: SleepLabPreferences()),
                              graphStyle: .default, chartGroup: nil)
            .labTheme()
            .previewDevice("iPhone 8")
    }
}
