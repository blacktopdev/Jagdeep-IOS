//
//  StatusRingShape.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 11/21/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct StatusRingShape: Shape {
    let lineWidth: CGFloat
    let completeness: Double

    func path(in rect: CGRect) -> Path {
        if completeness > 0 {
            let halfAngle = 360 * completeness / 100 / 2
            var p = Path()
            p.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                     radius: rect.width / 2,
                     startAngle: .degrees(90 - halfAngle),
                     endAngle: .degrees(90 + halfAngle),
                     clockwise: false)
            return p.strokedPath(.init(lineWidth: lineWidth, lineCap: .round))
        } else {
            return Path(ellipseIn: rect)
        }
    }
}

struct StatusRingShape_Previews: PreviewProvider {
    static var previews: some View {
        StatusRingShape(lineWidth: 9, completeness: 88)
            .fill(Color.appGreen)
            .frame(width: 128, height: 128)
            .padding()
            .background(Color.appMono25)
            .previewLayout(.sizeThatFits)
    }
}
