//
//  GraphGridProvider.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/9/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import UIKit

protocol GraphGridProvider: GraphGeometryProvider {
    func strokeWidth(for value: T) -> CGFloat
    func dashPattern(for value: T) -> [CGFloat]
}

class GraphStandardGridProvider: GraphStandardGeometryProvider, GraphGridProvider {
    let strokeWidth: CGFloat
    let dashPattern: [CGFloat]

    init(stride: T, offset: T, strokeWidth: CGFloat = 1, dashPattern: [CGFloat] = []) {
        self.strokeWidth = strokeWidth
        self.dashPattern = dashPattern
        super.init(stride: stride, offset: offset)
    }

    func strokeWidth(for value: T) -> CGFloat {
        return strokeWidth
    }

    func dashPattern(for value: T) -> [CGFloat] {
        return dashPattern
    }
}
