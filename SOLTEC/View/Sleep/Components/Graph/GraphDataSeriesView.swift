//
//  GraphDataSeriesView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/6/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct GraphDataSeriesView: View {

    enum Style {
        case line
        case bar
        case scatter
        case mountain
    }

    let name: String
    let series: GraphDataSeries
    let style: Style

    let strokeWidth: CGFloat
    let cornerRadius: Float
    let fill: GraphFillStyle

    var timingCurve = TimingCurve(c1: CGPoint(x: 0.24, y: 0.07),
                                  c2: CGPoint(x: 0.47, y: 1.17), duration: 0.5)
    var stagger: CGFloat = 0.4

    @State private var uAnimation: CGFloat = 0

    var strokeMargins: EdgeInsets {
        switch style {
        case .line:
            return GraphRenderLineShape.strokeMargins(forWidth: strokeWidth)
        case .bar:
            return GraphRenderBarsShape.strokeMargins(forWidth: strokeWidth)
        case .scatter:
            return GraphRenderScatterShape.strokeMargins(forWidth: strokeWidth)
        case .mountain:
            return GraphRenderMountainShape.strokeMargins(forWidth: strokeWidth)
        }
    }

    private var shape: some View {
        Group {
            switch style {
            case .line:
                GraphRenderLineShape(series: series, strokeWidth: strokeWidth,
                                     timingCurve: timingCurve, stagger: stagger, uAnimation: uAnimation)
                    .applying(fill: fill)
            case .bar:
                GraphRenderBarsShape(series: series, strokeWidth: strokeWidth, cornerRadius: 3,
                                     timingCurve: timingCurve, stagger: stagger, uAnimation: uAnimation)
                    .applying(fill: fill)
            case .scatter:
                GraphRenderScatterShape(series: series, strokeWidth: strokeWidth,
                                        timingCurve: timingCurve, stagger: stagger, uAnimation: uAnimation)
                    .applying(fill: fill)
            case .mountain:
                GraphRenderMountainShape(series: series, strokeWidth: strokeWidth,
                                         timingCurve: timingCurve, stagger: stagger, uAnimation: uAnimation)
                    .applying(fill: fill)
            }
        }
    }

    var body: some View {
        shape
            .animation(Animation.linear(duration: timingCurve.duration))
            .onAppear { uAnimation = 1 }
    }
}

//struct GraphDataSeriesView_Previews: PreviewProvider {
//    static var previews: some View {
//        GraphDataSeriesView()
//    }
//}

extension GraphDataSeriesView: Hashable {
    static func == (lhs: GraphDataSeriesView, rhs: GraphDataSeriesView) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(style)
    }
}
