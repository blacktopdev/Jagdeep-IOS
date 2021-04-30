//
//  GraphAxisView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/9/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct GraphAxisView: View {

    let axis: GraphAxis
    let aligned: GraphAlignedGeometry
    let graphSize: CGSize

    private func labelOffset(in rect: CGRect, for position: CGFloat) -> CGPoint {
        switch axis.direction {
        case .vertical:
            return CGPoint(x: 0, y: position - rect.midY)
        case .horizontal:
            return CGPoint(x: position - rect.midX, y: 0)
        }
    }

    var body: some View {
        let rect = CGRect(x: 0, y: 0, width: graphSize.width, height: graphSize.height)
        let positions = aligned.gridLinePositions(in: rect)
        let rawPositions = aligned.gridLineRawPositions
        let labelProvider = axis.labelProvider

        ZStack(alignment: .topTrailing) {
            ForEach(0..<positions.count) { (index) in
                let position = positions[index]
                let rawPosition = rawPositions[index]
                let offset = labelOffset(in: rect, for: CGFloat(position))

                Text(labelProvider?.label(for: rawPosition * 1) ?? "\(String(format: "%.1f", rawPosition))")
                    .offset(x: offset.x, y: offset.y)
            }
        }
    }
}

//struct GraphAxisView_Previews: PreviewProvider {
//    static var previews: some View {
//        GraphAxisView()
//    }
//}
