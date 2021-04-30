//
//  GraphMountainShape.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/6/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct GraphRenderMountainShape: Shape, GraphRenderView {

    static func strokeMargins(forWidth strokeWidth: CGFloat) -> EdgeInsets {
        EdgeInsets()
    }

    let series: GraphDataSeries
    let strokeWidth: CGFloat

    func path(in rect: CGRect) -> Path {
        var p = Path()

        p.addLines(series.points(in: rect))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))

        return p

//        return p.strokedPath(.init(lineWidth: strokeWidth, lineCap: .round))
    }
}

//struct GraphMountainShape_Previews: PreviewProvider {
//    static var previews: some View {
//        GraphMountainShape()
//    }
//}
