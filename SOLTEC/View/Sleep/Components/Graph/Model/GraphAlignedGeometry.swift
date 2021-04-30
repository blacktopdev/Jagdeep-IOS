//
//  GraphAlignedGeometry.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/9/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

class GraphAlignedGeometry {
    let series: [GraphDataSeries]
    let axis: GraphAxis
    let insets: EdgeInsets
    let geometryProvider: GraphStandardGeometryProvider?

    init(series: [GraphDataSeries], axis: GraphAxis, insets: EdgeInsets, gridProvider: GraphStandardGeometryProvider?) {
        self.geometryProvider = gridProvider
        self.series = series
        self.axis = axis
        self.insets = insets
    }

    lazy var aggregateRange: ClosedRange = {
        type(of: self).aggregateRange(with: series, axis: axis.direction)
    }()

    static func aggregateRange(with series: [GraphDataSeries], axis: Axis) -> ClosedRange<Double> {
        guard let aRange = series.first?.range else { return 0...0 }
        switch axis {
        case .vertical:
            return series.reduce(aRange.y) { (result, series) in
                min(result.lowerBound, series.range.y.lowerBound)...max(result.upperBound, series.range.y.upperBound)
            }
        case .horizontal:
            return series.reduce(aRange.x) { (result, series) in
                min(result.lowerBound, series.range.x.lowerBound)...max(result.upperBound, series.range.x.upperBound)
            }
        }
    }

    lazy var gridLineRawPositions: [Double] = {
        guard let gridProvider = geometryProvider else { return [] }

        var lineCount = Int(ceil((aggregateRange.upperBound - aggregateRange.lowerBound) / gridProvider.stride))

        let startPosition = ceil(aggregateRange.lowerBound / gridProvider.stride)
            * gridProvider.stride + gridProvider.offset

//        switch axis.isFlipped {
//        case false:
            return (0...lineCount).compactMap {
                let position = startPosition + Double($0) * gridProvider.stride
                return aggregateRange.contains(position) ? position : nil
            }
//        case true:
//            let endPosition = aggregateRange.upperBound - (startPosition - aggregateRange.lowerBound)
//            return (0...lineCount).compactMap {
//                let position = endPosition - Double($0) * gridProvider.stride
//                return aggregateRange.contains(position) ? position : nil
//            }
//        }
    }()

    func gridLinePositions(in rect: CGRect) -> [CGFloat] {
        let rawPositions = gridLineRawPositions

        let gridRect = rect.inset(by: UIEdgeInsets(top: insets.top, left: insets.leading,
                                                   bottom: insets.bottom, right: insets.trailing))

        let rectRange = axis.direction == .vertical ? gridRect.minY..<gridRect.maxY : gridRect.minX..<gridRect.maxX
        let scale = Double(rectRange.upperBound - rectRange.lowerBound)
            / (aggregateRange.upperBound - aggregateRange.lowerBound)

        switch axis.direction {
        case .vertical:
            return rawPositions.map { position in
                rectRange.upperBound - CGFloat((position - aggregateRange.lowerBound) * scale)
            }
        case .horizontal:
            return rawPositions.map { position in
                rectRange.lowerBound + CGFloat((position - aggregateRange.lowerBound) * scale)
            }
        }
    }
}
