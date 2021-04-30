//
//  GraphSpec.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/13/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct GraphSpec: Equatable {
    static func == (lhs: GraphSpec, rhs: GraphSpec) -> Bool {
        return lhs.xAxis.name == rhs.xAxis.name &&
            lhs.yAxis.name == rhs.yAxis.name
    }

    /// Define X axes.
    let xAxis: GraphAxis
    /// Define Y axes.
    let yAxis: GraphAxis
    /// Graph content.
    let seriesViews: [GraphDataSeriesView]
    /// Graph content.
    let clipBleed: Bool

    let name: String?

    var builder: ((AnyView) -> AnyView)?
    
    /// Maximum necessary margins based on stroke width or other bleed styles
    let strokeMargins: EdgeInsets

    let xRange: ClosedRange<Double>
    let yRange: ClosedRange<Double>

    let gridFill: GraphFillStyle

    /// If omitted, `strokeMargins` is calculated automatically.
    init(xAxis: GraphAxis, yAxis: GraphAxis, seriesViews: [GraphDataSeriesView],
         gridFill: GraphFillStyle = .color(Color.gray.opacity(0.33)),
         clipBleed: Bool = false, strokeMargins: EdgeInsets? = nil,
         name: String? = nil, builder: ((AnyView) -> AnyView)? = nil) {

        self.xAxis = xAxis
        self.yAxis = yAxis
        self.seriesViews = seriesViews
        self.gridFill = gridFill
        self.clipBleed = clipBleed
        self.name = name
        self.builder = builder

        self.strokeMargins = clipBleed ? EdgeInsets()
            : strokeMargins ?? EdgeInsets.union(insets: seriesViews.map { $0.strokeMargins })

        let series = seriesViews.map { $0.series }
        self.xRange = GraphAlignedGeometry.aggregateRange(with: series, axis: .horizontal)
        self.yRange = GraphAlignedGeometry.aggregateRange(with: series, axis: .vertical)
    }
}
