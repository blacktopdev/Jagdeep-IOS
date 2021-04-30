//
//  GraphRenderView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/11/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

protocol GraphRenderView {
    static func strokeMargins(forWidth strokeWidth: CGFloat) -> EdgeInsets

    var timingCurve: TimingCurve { get }
    var stagger: CGFloat { get }
    var uAnimation: CGFloat { get set }
}

extension GraphRenderView {

//    var animatableData: CGFloat {
//        get { uAnimation }
//        set { uAnimation = newValue }
//    }

    func interpolated(_ points: [CGPoint], in rect: CGRect, zeroY: CGFloat) -> [CGPoint] {
        let flipStagger = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
        let mapRangeStart = flipStagger ? stagger..<1 : 0..<(1 - stagger)
        let mapRangeEnd = flipStagger ? 0..<(1 - stagger) : stagger..<1

        let uDivisor = max(CGFloat.leastNonzeroMagnitude, CGFloat(points.count - 1))    // avoid divide by zero
        return points.enumerated().map { index, point in
            let uPoint = CGFloat(index) / uDivisor
            let uPointInv = 1 - uPoint

            // offset the animation range across points
            let map = (uPointInv * mapRangeStart.lowerBound + uPoint * mapRangeEnd.lowerBound) ..<
                (uPointInv * mapRangeStart.upperBound + uPoint * mapRangeEnd.upperBound)
            // remap uAnimation
            let uLinear = min(1, max(0, uAnimation - map.lowerBound) / (map.upperBound - map.lowerBound))
            let uMapped = timingCurve.value(at: uLinear)

            return CGPoint(x: point.x, y: zeroY * (1 - uMapped) + point.y * uMapped)
        }
    }
}
