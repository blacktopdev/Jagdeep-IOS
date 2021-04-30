//
//  GraphView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/5/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct GraphView: View {

    let spec: GraphSpec
    let renderLabels: Bool
    let renderGrids: Bool
    let axisSpacing: CGSize

    @State private var graphSize = CGSize.zero

    init(spec: GraphSpec, renderLabels: Bool = true, renderGrids: Bool = true, axisSpacing: CGSize? = nil) {
        self.spec = spec
        self.renderLabels = renderLabels
        self.renderGrids = renderGrids
        self.axisSpacing = axisSpacing ?? Constants.Metrics.axisSpacing
    }

    init(xAxis: GraphAxis, yAxis: GraphAxis, seriesViews: [GraphDataSeriesView]) {
        self.init(spec: GraphSpec(xAxis: xAxis, yAxis: yAxis, seriesViews: seriesViews))
    }

    var backgroundView: some View {
        return ZStack {
            GraphGridShape(geometry:
                            GraphAlignedGeometry(series: spec.seriesViews.map { $0.series },
                                                 axis: spec.xAxis, insets: spec.strokeMargins,
                                                 gridProvider: spec.xAxis.gridProvider))
                .applying(fill: spec.gridFill)

            GraphGridShape(geometry:
                            GraphAlignedGeometry(series: spec.seriesViews.map { $0.series },
                                                 axis: spec.yAxis, insets: spec.strokeMargins,
                                                 gridProvider: spec.yAxis.gridProvider))
                .applying(fill: spec.gridFill)
        }
    }

    var xAxisView: some View {
        GraphAxisView(axis: spec.xAxis,
                      aligned: GraphAlignedGeometry(series: spec.seriesViews.map { $0.series },
                                                    axis: spec.xAxis, insets: spec.strokeMargins,
                                                    gridProvider: spec.xAxis.labelProvider),
                      graphSize: graphSize)
    }

    var yAxisView: some View {
        GraphAxisView(axis: spec.yAxis,
                      aligned: GraphAlignedGeometry(series: spec.seriesViews.map { $0.series },
                                                    axis: spec.yAxis, insets: spec.strokeMargins,
                                                    gridProvider: spec.yAxis.labelProvider),
                      graphSize: graphSize)
    }

    var content: some View {
        ZStack {
            if renderGrids {
                backgroundView
            }

            if graphSize != CGSize.zero {
                ForEach(spec.seriesViews, id: \.name) { view in
                    view
                        .padding(spec.strokeMargins)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    var contentWithAxes: some View {
        HStack(alignment: .top, spacing: axisSpacing.width) {
            if spec.yAxis.labelProvider != nil {
                yAxisView
                    .applying(fill: spec.yAxis.labelFill)
                    .font(spec.yAxis.font)
                    .frame(height: graphSize.height)
            }

            VStack(spacing: axisSpacing.height) {
                content
                    .background(GraphPreferencesSetter(spec: spec))

                if spec.xAxis.labelProvider != nil {
                    xAxisView
                        .applying(fill: spec.xAxis.labelFill)
                        .font(spec.xAxis.font)
                        .frame(width: graphSize.width)
                }
            }
        }
    }

    var body: some View {
        VStack {
            if renderLabels {
                contentWithAxes
            } else {
                content
                    .background(GraphPreferencesSetter(spec: spec))
            }
        }
        .onPreferenceChange(GraphPreferenceKey.self) { preferences in
            for p in preferences {
                graphSize = p.rect.size
            }
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {

        return Group {
            GraphView(xAxis: GraphTestData.xAxis, yAxis: GraphTestData.yAxis,
                      seriesViews: [GraphTestData.dataViewBar])
                .fullscreenTheme()
                .frame(width: 300, height: 120, alignment: .center)
                .previewLayout(.sizeThatFits)

            GraphView(xAxis: GraphTestData.xAxis, yAxis: GraphTestData.yAxis,
                      seriesViews: [GraphTestData.dataViewScatter])
                .fullscreenTheme()
                .frame(width: 300, height: 120, alignment: .center)
                .previewLayout(.sizeThatFits)

            GraphView(xAxis: GraphTestData.xAxis, yAxis: GraphTestData.yAxis,
                      seriesViews: [GraphTestData.dataViewLine])
                .fullscreenTheme()
                .frame(width: 300, height: 120, alignment: .center)
                .previewLayout(.sizeThatFits)

            GraphView(xAxis: GraphTestData.xAxis, yAxis: GraphTestData.yAxis,
                      seriesViews: [GraphTestData.dataViewMountain])
                .fullscreenTheme()
                .frame(width: 300, height: 120, alignment: .center)
                .previewLayout(.sizeThatFits)

            GraphView(xAxis: GraphTestData.xAxis, yAxis: GraphTestData.yAxis,
                      seriesViews: [GraphTestData.dataViewMountain, GraphTestData.dataViewBar,
                                    GraphTestData.dataViewLine, GraphTestData.dataViewScatter])
                .fullscreenTheme()
                .frame(width: 300, height: 120, alignment: .center)
                .previewLayout(.sizeThatFits)
        }
        .padding()
        .background(Color.appMono25)
    }
}
