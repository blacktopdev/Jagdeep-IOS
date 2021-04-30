//
//  GraphTestData.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/13/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct GraphTestData {

    static let data1: [GraphStandardPoint] = [.init(x: 0, y: 2),
                                   .init(x: 1, y: 1),
                                   .init(x: 2, y: 4),
                                   .init(x: 3, y: 2),
                                   .init(x: 4, y: 5),
                                   .init(x: 5, y: 5),
                                   .init(x: 6, y: 3),
                                   .init(x: 7, y: 3),
                                   .init(x: 8, y: 8),
                                   .init(x: 9, y: 6)
    ]

    static let data2: [GraphStandardPoint] = [.init(x: -2, y: 3),
                                   .init(x: -1, y: 5)] + data1 + [.init(x: 11, y: 10),
                                                                  .init(x: 12, y: 2),
                                                                  .init(x: 13, y: -2)]

    static let dataSeries = GraphDataSeries(name: "Test Series",
                                            data: GraphTestData.data1, rangeY: 0...8)

    static let dataSeries2 = GraphDataSeries(name: "Test Series 2",
                                            data: GraphTestData.data2)

    static let dataViewBar = GraphDataSeriesView(name: "bar view",
                                                 series: GraphTestData.dataSeries, style: .bar,
//                                                 strokeWidth: 12, cornerRadius: 3, color: .color(.blue),
                                                 strokeWidth: 12, cornerRadius: 3,
                                                 fill: .linearGradient(LinearGradient(gradient: Color.eveningGradient, startPoint: .top, endPoint: .bottom)),
                                                 timingCurve: Constants.Metrics.graphAnimationCurve,
                                                 stagger: Constants.Metrics.graphAnimationStagger)

    static let dataViewScatter = GraphDataSeriesView(name: "scatter view",
                                                     series: GraphTestData.dataSeries, style: .scatter,
                                                     strokeWidth: 9, cornerRadius: 3, fill: .color(.red),
                                                     timingCurve: Constants.Metrics.graphAnimationCurve,
                                                     stagger: Constants.Metrics.graphAnimationStagger)

    static let dataViewLine = GraphDataSeriesView(name: "line view",
                                                  series: GraphTestData.dataSeries, style: .line,
                                                  strokeWidth: 9, cornerRadius: 3, fill: .color(.white))

    static let dataViewLine2 = GraphDataSeriesView(name: "line view",
                                                  series: GraphTestData.dataSeries2, style: .line,
                                                  strokeWidth: 6, cornerRadius: 3, fill: .color(.white))

    static let dataViewMountain = GraphDataSeriesView(name: "mountain view",
                                                      series: GraphTestData.dataSeries, style: .mountain,
                                                      strokeWidth: 9, cornerRadius: 3, fill: .color(.yellow))

    static let xAxis = GraphAxis(name: "Time", direction: .horizontal,
                                 labelProvider: GraphStandardLabelProvider(stride: 1, offset: 0, formatter: NumberFormatter()),
                                 gridProvider: GraphStandardGridProvider(stride: 2, offset: 0, strokeWidth: 1, dashPattern: [5, 8]))

    static let yAxis = GraphAxis(name: "Y", direction: .vertical,
                                 labelProvider: GraphStandardLabelProvider(stride: 2, formatter: NumberFormatter()),
                                 gridProvider: GraphStandardGridProvider(stride: 2, offset: 0, strokeWidth: 1))
}
