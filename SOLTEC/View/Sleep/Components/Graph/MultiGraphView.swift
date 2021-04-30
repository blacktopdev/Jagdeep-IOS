//
//  MultiGraphView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/13/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct MultiGraphView: View {

    struct LayoutGroup {
        let keySpecIndex: Int
        let range: ClosedRange<Double>
        let strokeMargins: EdgeInsets
        let spacing: CGFloat
        let size: CGFloat
    }

    /// 2-dimensional array of graphs, in row-major order, e.g.
    /// [[upperLeft, upperRight], [lowerLeft, lowerRight]]
    let specs: [[GraphSpec]]
    let axisSpacing: CGSize

    private let rowGroups: [LayoutGroup]
    private let colGroups: [LayoutGroup]

    @State private var nameMappedRects = [String: CGRect]()

    private func graphSize(for spec: GraphSpec) -> CGSize {
        return nameMappedRects[spec.name ?? ""]?.size ?? CGSize.zero
    }

    init(specs: [[GraphSpec]], axisSpacing: CGSize? = nil, layout: GraphLayoutProvider? = nil) {

        let layout = layout ?? GraphStandardLayoutProvider(size: Constants.Metrics.graphSpacing,
                                                           spacing: Constants.Metrics.axisSpacing)
        let rowGroups = type(of: self).rowGroups(with: specs, layout: layout)
        let colGroups = type(of: self).colGroups(with: specs, layout: layout)

        self.specs = type(of: self).convert(specs: specs, rowGroups: rowGroups, colGroups: colGroups)
        self.axisSpacing = axisSpacing ?? Constants.Metrics.axisSpacing
        self.rowGroups = rowGroups
        self.colGroups = colGroups
    }

    // swiftlint:disable reduce_boolean
    private func has(axis: Axis) -> Bool {
        switch axis {
        case .horizontal:
            return (0..<specs[0].count).reduce(false) { (result, index) in
                result || specs[colGroups[index].keySpecIndex][index].xAxis.labelProvider != nil
            }
        case .vertical:
            return (0..<specs.count).reduce(false) { (result, index) in
                result || specs[index][rowGroups[index].keySpecIndex].yAxis.labelProvider != nil
            }
        }
    }
    // swiftlint:enable reduce_boolean

    private func yAxisView(for group: LayoutGroup, row: Int) -> some View {
        let spec = specs[row][group.keySpecIndex]
        let size = graphSize(for: spec)
        let yAxisView = GraphAxisView(axis: spec.yAxis,
                                      aligned: GraphAlignedGeometry(series: spec.seriesViews.map { $0.series },
                                                                    axis: spec.yAxis,
                                                                    insets: group.strokeMargins,
                                                                    gridProvider: spec.yAxis.labelProvider),
                                      graphSize: size)
            .applying(fill: spec.yAxis.labelFill)
            .font(spec.yAxis.font)
            .frame(height: size.height)

        return Group {
            if let builder = spec.yAxis.builder {
                builder(AnyView(yAxisView))
            } else {
                yAxisView
            }
        }
    }

    private func xAxisView(for group: LayoutGroup, col: Int) -> some View {
        let spec = specs[colGroups[col].keySpecIndex][col] //specs.map { $0[col] }[group.keySpecIndex]
        let size = graphSize(for: spec)
        let xAxisView = GraphAxisView(axis: spec.xAxis,
                                      aligned: GraphAlignedGeometry(series: spec.seriesViews.map { $0.series },
                                                                    axis: spec.xAxis,
                                                                    insets: group.strokeMargins,
                                                                    gridProvider: spec.xAxis.labelProvider),
                                      graphSize: size)
            .applying(fill: spec.xAxis.labelFill)
            .font(spec.xAxis.font)
            .frame(width: size.width)

        return Group {
            if let builder = spec.xAxis.builder {
                builder(AnyView(xAxisView))
            } else {
                xAxisView
            }
        }
    }

    private func graphView(row: Int, col: Int) -> some View {
        let spec = specs[row][col]
        let view = GraphView(spec: spec,
                  renderLabels: false, renderGrids: false)
            .frameOverride(size: graphFrame(forRow: row, col: 0))

        return Group {
            if let builder = spec.builder {
                builder(AnyView(view))
            } else {
                view
            }
        }
    }

    private func backgroundView(for group: LayoutGroup, row: Int) -> some View {
        let spec = specs[row][group.keySpecIndex]
        return GraphGridShape(geometry:
                        GraphAlignedGeometry(series: spec.seriesViews.map { $0.series },
                                             axis: spec.yAxis, insets: spec.strokeMargins,
                                             gridProvider: spec.yAxis.gridProvider))
            .applying(fill: spec.gridFill)
    }

    private func backgroundView(for group: LayoutGroup, col: Int) -> some View {
        let spec = specs.map { $0[col] }[group.keySpecIndex]
        return GraphGridShape(geometry:
                        GraphAlignedGeometry(series: spec.seriesViews.map { $0.series },
                                             axis: spec.xAxis, insets: spec.strokeMargins,
                                             gridProvider: spec.xAxis.gridProvider))
            .applying(fill: spec.gridFill)
    }

    private var columnBackgroundViews: some View {
        HStack(spacing: 0) {
            ForEach(0..<specs[0].count) { col in
                let spec = specs.map { $0[col] }[colGroups[col].keySpecIndex]
                let size = graphSize(for: spec)
                backgroundView(for: colGroups[col], col: col)
                    .frame(width: size.width)
                    .frame(maxHeight: .infinity)
                spacer(forAxis: .horizontal, index: col)
            }
        }
    }

    private func spacer(forAxis axis: Axis, index: Int) -> some View {
        switch axis {
        case .horizontal:
            return Color.clear
                .frame(width: index < colGroups.count - 1 ? colGroups[index].spacing : 0, height: 0)
        case .vertical:
            return Color.clear
                .frame(width: 0, height: index < rowGroups.count - 1 ? rowGroups[index].spacing : 0)
        }
    }

    private func graphFrame(forRow row: Int, col: Int) -> CGSize {
        return CGSize(width: colGroups[col].size,
                      height: rowGroups[row].size)
    }

    var body: some View {
        HStack(alignment: .top, spacing: axisSpacing.width) {
            if has(axis: .vertical) { // Side axes
                VStack(alignment: .trailing, spacing: 0) {
                    ForEach(0..<specs.count) { row in
                        yAxisView(for: rowGroups[row], row: row)
                        spacer(forAxis: .vertical, index: row)
                    }
                }
            }

            VStack(alignment: .trailing, spacing: axisSpacing.height) {
                // Vertical stack of graph rows
                VStack(alignment: .trailing, spacing: 0) {
                    ForEach(0..<specs.count) { row in

                        // Horizontal stack of graphs
                        HStack(spacing: 0) {
                            ForEach(0..<specs[row].count) { col in
                                graphView(row: row, col: col)
//                                GraphView(spec: specs[row][col],
//                                          renderLabels: false, renderGrids: false)
//                                    .frameOverride(size: graphFrame(forRow: row, col: 0))
                                spacer(forAxis: .horizontal, index: col)
                            }
                        }
                        .background(backgroundView(for: rowGroups[row], row: row))
                        spacer(forAxis: .vertical, index: row)
                    }
                }
                .background(columnBackgroundViews)

                if has(axis: .horizontal) { // Bottom axes
                    HStack(spacing: 0) {
                        ForEach(0..<specs[0].count) { col in
                            xAxisView(for: colGroups[col], col: col)
                            spacer(forAxis: .horizontal, index: col)
                        }
                    }
                }
            }
        }
        .onPreferenceChange(GraphPreferenceKey.self) { preferences in
            for p in preferences {
                if let name = p.spec.name {
                    nameMappedRects[name] = p.rect
                }
            }
        }
    }
}

extension MultiGraphView {

    fileprivate static func rowGroups(with specs: [[GraphSpec]], layout: GraphLayoutProvider) -> [LayoutGroup] {
        return specs.enumerated().map { index, rowSpecs -> LayoutGroup in
            let range = rowSpecs.reduce(rowSpecs[0].yRange) { (result, def) in
                min(result.lowerBound, def.yRange.lowerBound)...max(result.upperBound, def.yRange.upperBound)
            }
            let margins = EdgeInsets.union(insets: rowSpecs.map { $0.strokeMargins })
            let spacing = layout.spacing(afterAxis: .vertical, index: index)
            let size = layout.size(forAxis: .vertical, index: index)
            return LayoutGroup(keySpecIndex: 0, range: range, strokeMargins: margins,
                         spacing: spacing, size: size)
        }
    }

    fileprivate static func colGroups(with specs: [[GraphSpec]], layout: GraphLayoutProvider) -> [LayoutGroup] {
        return (0..<specs[0].count).enumerated().map { index, col -> LayoutGroup in
            let colSpecs = specs.map { $0[col] }
            let range = colSpecs.reduce(colSpecs[0].xRange) { (result, def) in
                min(result.lowerBound, def.xRange.lowerBound)...max(result.upperBound, def.xRange.upperBound)
            }
            let margins = EdgeInsets.union(insets: colSpecs.map { $0.strokeMargins })
            let spacing = layout.spacing(afterAxis: .horizontal, index: index)
            let size = layout.size(forAxis: .horizontal, index: index)
            return LayoutGroup(keySpecIndex: colSpecs.count - 1, range: range, strokeMargins: margins,
                         spacing: spacing, size: size)
        }
    }

    fileprivate static func convert(specs: [[GraphSpec]], rowGroups: [LayoutGroup], colGroups: [LayoutGroup]) -> [[GraphSpec]] {
        return specs.enumerated().map { row, rowSpecs in
            rowSpecs.enumerated().map { col, spec in

                let xAxis = GraphAxis(name: spec.xAxis.name, direction: .horizontal,
                                      labelFill: spec.xAxis.labelFill,
                                      font: spec.xAxis.font,
                                      labelProvider: spec.xAxis.labelProvider,
                                      gridProvider: spec.xAxis.gridProvider,
                                      builder: spec.xAxis.builder)

                let yAxis = GraphAxis(name: spec.yAxis.name, direction: .vertical,
                                      labelFill: spec.yAxis.labelFill,
                                      font: spec.yAxis.font,
                                      labelProvider: spec.yAxis.labelProvider,
                                      gridProvider: spec.yAxis.gridProvider,
                                      builder: spec.yAxis.builder)

                let views = spec.seriesViews.map { view -> GraphDataSeriesView in
                    let series = GraphDataSeries(name: view.series.name, data: view.series.data,
                                                 rangeX: colGroups[col].range, rangeY: rowGroups[row].range)
                    return GraphDataSeriesView(name: view.name, series: series, style: view.style,
                                               strokeWidth: view.strokeWidth, cornerRadius: view.cornerRadius,
                                               fill: view.fill, timingCurve: view.timingCurve,
                                               stagger: view.stagger)
                }

                let strokeMargins = EdgeInsets(top: rowGroups[row].strokeMargins.top,
                                               leading: colGroups[col].strokeMargins.leading,
                                               bottom: rowGroups[row].strokeMargins.bottom,
                                               trailing: colGroups[col].strokeMargins.trailing)

                return GraphSpec(xAxis: xAxis, yAxis: yAxis, seriesViews: views, gridFill: spec.gridFill,
                                 clipBleed: spec.clipBleed, strokeMargins: strokeMargins,
                                 name: "\(row)-\(col)", builder: spec.builder)
            }
        }
    }
}

private struct GraphFrameModifier: ViewModifier {
    let size: CGSize

    func body(content: Content) -> some View {
        return Group {
            if size.width > 0 {
                content.frame(width: size.width)
            } else if size.height > 0 {
                content.frame(height: size.height)
            } else {
                content
            }
        }
    }
}

extension View {
    func frameOverride(size: CGSize) -> some View {
        return modifier(GraphFrameModifier(size: size))
    }
}

struct MultiGraphView_Previews: PreviewProvider {
    static var previews: some View {
        let gridFill = GraphFillStyle.color(Color.appMonoA3.opacity(0.3))
        
        let specBar = GraphSpec(xAxis: GraphTestData.xAxis, yAxis: GraphTestData.yAxis,
                                seriesViews: [GraphTestData.dataViewBar],
                                gridFill: gridFill, clipBleed: false)
        let specMountain = GraphSpec(xAxis: GraphTestData.xAxis, yAxis: GraphTestData.yAxis,
                                     seriesViews: [GraphTestData.dataViewMountain],
                                     gridFill: gridFill, clipBleed: false)
        let specLine = GraphSpec(xAxis: GraphTestData.yAxis, yAxis: GraphTestData.yAxis,
                                 seriesViews: [GraphTestData.dataViewLine],
                                 gridFill: gridFill, clipBleed: false)
        let specLine2 = GraphSpec(xAxis: GraphTestData.yAxis, yAxis: GraphTestData.yAxis,
                                 seriesViews: [GraphTestData.dataViewLine2],
                                 gridFill: gridFill, clipBleed: false)
        let specScatter = GraphSpec(xAxis: GraphTestData.xAxis, yAxis: GraphTestData.yAxis,
                                    seriesViews: [GraphTestData.dataViewScatter],
                                    gridFill: gridFill, clipBleed: false)

        Group {
            MultiGraphView(specs: [[specBar, specMountain, specLine],
                                   [specScatter, specLine2, specBar],
                                   [specMountain, specLine, specScatter]],
                           axisSpacing: CGSize(width: Constants.Metrics.padding,
                                               height: 10),
                           layout: GraphStandardLayoutProvider(size: CGSize.zero,
                                                               spacing: CGSize(width: Constants.Metrics.padding,
                                                                               height: Constants.Metrics.padding)))
                .fullscreenTheme()
                .frame(height: 360, alignment: .center)
                .previewLayout(.sizeThatFits)
        }
        .padding()
        .background(Color.appMono25)
    }
}
