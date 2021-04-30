//
//  ProtocolPaletteProvider.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 3/25/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation
import SciChart.Protected.SCILabelProviderBase

class ProtocolPaletteProvider: SCIPaletteProviderBase<SCIXyRenderableSeriesBase>,
                               ISCIPointMarkerPaletteProvider, ISCIFillPaletteProvider {

    static let mFieldEmbeddedScalar: Float = 50000
    private let colors = SCIUnsignedIntegerValues()
    private let transColors = SCIUnsignedIntegerValues()
    private let baseLevel: Float

    var pointMarkerColors: SCIUnsignedIntegerValues { return colors }
    var fillColors: SCIUnsignedIntegerValues { return transColors }

    init(baseLevel: Float) {
        self.baseLevel = baseLevel
        super.init(renderableSeriesType: SCIXyRenderableSeriesBase.self)
    }

    override func update() {
        let rSeries = renderableSeries
        let rpd: SCIXyRenderPassData! = rSeries?.currentRenderPassData as? SCIXyRenderPassData

        let count = rpd.pointsCount
        colors.count = count
        transColors.count = count

        for i in 0..<count {
            let yValue = Float(rpd.yValues.getValueAt(i))
            let level = (yValue - baseLevel) * ProtocolPaletteProvider.mFieldEmbeddedScalar   // rehydrate to mField scale
            colors.set(ProtocolPaletteProvider.color(at: level).hexColor, at: i)
            transColors.set(ProtocolPaletteProvider.color(at: level).withAlphaComponent(0.12).hexColor, at: i)
        }
    }

    static func color(at level: Float) -> UIColor {
        switch level {
        case 0..<100:
            return .clear
        case 100..<200:
            return .white
        case 200..<300:
            return .yellow
        case 300..<400:
            return .red
        default:
            return .blue
        }
    }
}
