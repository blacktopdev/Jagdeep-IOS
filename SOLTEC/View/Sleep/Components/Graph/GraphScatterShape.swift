//
//  GraphScatterShape.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/6/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct GraphRenderScatterShape: Shape, GraphRenderView {

    static func strokeMargins(forWidth strokeWidth: CGFloat) -> EdgeInsets {
        let halfWidth = strokeWidth * 0.5
        return EdgeInsets(top: halfWidth, leading: halfWidth,
                   bottom: halfWidth, trailing: halfWidth)
    }

    let series: GraphDataSeries
    let strokeWidth: CGFloat

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let points = series.points(in: rect)

        points.forEach { point in
            p.addPath(Ellipse().path(in: CGRect(center: point,
                                                 size: CGSize(width: strokeWidth,
                                                              height: strokeWidth))))
        }

        return p
    }
}

//struct GraphScatterShape_Previews: PreviewProvider {
//    static var previews: some View {
//        GraphScatterShape()
//    }
//}
