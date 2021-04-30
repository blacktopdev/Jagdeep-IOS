//
//  GraphDataSeries.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/6/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

// swiftlint:disable type_name
protocol GraphDataPoint {
    associatedtype T: BinaryFloatingPoint

    var x: T { get }
    var y: T { get }
}

struct GraphStandardPoint: GraphDataPoint {
    let x: Double
    let y: Double
}

struct GraphDataSeries {

    typealias DataRange = (x: ClosedRange<Double>, y: ClosedRange<Double>)

    let name: String
    let data: [GraphStandardPoint]
    let range: DataRange

    init(name: String, data: [GraphStandardPoint],
         rangeX: ClosedRange<Double>? = nil, rangeY: ClosedRange<Double>? = nil) {
        self.name = name
        self.data = data

        let x = rangeX ?? data.reduce(data[0].x...data[0].x) { result, point in
            min(result.lowerBound, point.x)...max(result.upperBound, point.x)
        }
        let y = rangeY ?? data.reduce(data[0].y...data[0].y) { result, point in
            min(result.lowerBound, point.y)...max(result.upperBound, point.y)
        }

        self.range = (x: x, y: y)
    }

    func points(in rect: CGRect) -> [CGPoint] {
        let uDivisorX = max(Double.leastNonzeroMagnitude, range.x.upperBound - range.x.lowerBound)   // avoid divide-by-zero
        let uDivisorY = max(Double.leastNonzeroMagnitude, range.y.upperBound - range.y.lowerBound)   // avoid divide-by-zero
        return data.map { point in
            let clampedPoint = GraphStandardPoint(x: max(range.x.lowerBound, min(range.x.upperBound, point.x)),
                                                  y: max(range.y.lowerBound, min(range.y.upperBound, point.y)))
            let uX = (clampedPoint.x - range.x.lowerBound) / uDivisorX
            let uY = (clampedPoint.y - range.y.lowerBound) / uDivisorY
            return CGPoint(x: rect.minX + CGFloat(uX) * rect.width,
                           y: rect.maxY - CGFloat(uY) * rect.height)
        }
    }

    func zeroY(in rect: CGRect) -> CGFloat {
        let zero = max(range.y.lowerBound, min(range.y.upperBound, 0))
        let uY = CGFloat((zero - range.y.lowerBound) / (range.y.upperBound - range.y.lowerBound))
        return rect.maxY - CGFloat(uY) * rect.height
    }
}
