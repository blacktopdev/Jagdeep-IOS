//
//  SCIChartSurface+Common.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 10/19/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import Foundation
import SciChart

extension SCIChartSurface {

    func addStandardPanZoom() {
        let zoom = SCIPinchZoomModifier()
        zoom.direction = .xDirection

        let pan = SCIZoomPanModifier()
        pan.direction = .xDirection
        pan.clipModeX = .clipAtExtents
//        pan.clipModeY = .clipAtExtents
        chartModifiers.add(items: zoom, pan, SCIZoomExtentsModifier())
    }
}
