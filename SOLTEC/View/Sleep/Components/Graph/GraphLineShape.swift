//
//  GraphLineShape.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/6/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct GraphRenderLineShape: Shape, GraphRenderView {

    static func strokeMargins(forWidth strokeWidth: CGFloat) -> EdgeInsets {
        let halfWidth = strokeWidth * 0.5
        return EdgeInsets(top: halfWidth, leading: halfWidth,
                   bottom: halfWidth, trailing: halfWidth)
    }

    let series: GraphDataSeries
    let strokeWidth: CGFloat

    func path(in rect: CGRect) -> Path {
        var p = Path()

        p.addLines(series.points(in: rect))

        return p.strokedPath(.init(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round))
    }
}

//struct GraphLineShape_Previews: PreviewProvider {
//    static var previews: some View {
//        GraphLineShape()
//    }
//}
