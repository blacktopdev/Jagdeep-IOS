//
//  GraphRenderBarsShape.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/7/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct GraphRenderBarsShape: Shape, GraphRenderView {

    static func strokeMargins(forWidth strokeWidth: CGFloat) -> EdgeInsets {
        let halfWidth = strokeWidth * 0.5
        return EdgeInsets(top: 0, leading: halfWidth,
                   bottom: 0, trailing: halfWidth)
    }
    
    let series: GraphDataSeries
    let strokeWidth: CGFloat
    let cornerRadius: CGFloat

    var timingCurve = TimingCurve(c1: CGPoint(x: 0.2, y: 0),
                                  c2: CGPoint(x: 0.8, y: 1), duration: 0.5)
    var stagger: CGFloat = 0.0
    var uAnimation: CGFloat = 0

    var animatableData: CGFloat {
        get { uAnimation }
        set { uAnimation = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let points = series.points(in: rect)
        let zeroY = series.zeroY(in: rect)
        let currentPoints = interpolated(points, in: rect, zeroY: zeroY)
        let halfBarWidth = strokeWidth * 0.5
        let cornerSize = CGSize(width: cornerRadius, height: cornerRadius)

        for point in currentPoints {
            if point.y < zeroY {            // standard up-bars
                let barRect = CGRect(x: point.x - halfBarWidth,
                                     y: point.y,
                                     width: strokeWidth,
                                     height: zeroY - point.y)

                let subPath = UIBezierPath(roundedRect: barRect,
                                           byRoundingCorners: [.topLeft, .topRight],
                                           cornerRadii: cornerSize)

                p.addPath(Path(subPath.cgPath))
            } else if point.y > zeroY {     // down-bars
                let barRect = CGRect(x: point.x - halfBarWidth,
                                     y: zeroY,
                                     width: strokeWidth,
                                     height: point.y - zeroY)

                let subPath = UIBezierPath(roundedRect: barRect,
                                           byRoundingCorners: [.bottomLeft, .bottomRight],
                                           cornerRadii: cornerSize)

                p.addPath(Path(subPath.cgPath))
            }
        }

        return p
    }
}

//struct GraphRenderBarsShape_Previews: PreviewProvider {
//    static var previews: some View {
//        GraphRenderBarsShape()
//    }
//}
