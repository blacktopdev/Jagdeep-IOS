//
//  TimingCurve.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/7/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import UIKit

struct TimingCurve {
    let duration: TimeInterval
    let c1: CGPoint
    let c2: CGPoint

    init(c1: CGPoint, c2: CGPoint, duration: TimeInterval) {
        self.duration = duration
        self.c1 = c1
        self.c2 = c2
    }

    func value(at x: CGFloat) -> CGFloat {
        return calcBezier(aT: getTForX(x), aA1: c1.y, aA2: c2.y)
    }

    private func A(_ aA1: CGFloat, _ aA2: CGFloat) -> CGFloat {
        return 1.0 - 3.0 * aA2 + 3.0 * aA1
    }
    private func B(_ aA1: CGFloat, _ aA2: CGFloat) -> CGFloat {
        return 3.0 * aA2 - 6.0 * aA1
    }
    private func C(_ aA1: CGFloat) -> CGFloat {
        return 3.0 * aA1
    }

    // Returns x(t) given t, x1, and x2, or y(t) given t, y1, and y2.
    private func calcBezier(aT: CGFloat, aA1: CGFloat, aA2: CGFloat) -> CGFloat {
        return ((A(aA1, aA2)*aT + B(aA1, aA2))*aT + C(aA1))*aT
    }

    // Returns dx/dt given t, x1, and x2, or dy/dt given t, y1, and y2.
    private func getSlope(aT: CGFloat, aA1: CGFloat, aA2: CGFloat) -> CGFloat {
        return 3.0 * A(aA1, aA2)*aT*aT + 2.0 * B(aA1, aA2) * aT + C(aA1)
    }

    private func getTForX(_ aX: CGFloat) -> CGFloat {
        // Newton raphson iteration
        var aGuessT = aX
        for _ in 0..<4 {
            let currentSlope = getSlope(aT: aGuessT, aA1: c1.x, aA2: c2.x)
            guard currentSlope != 0.0 else { return aGuessT }
            let currentX = calcBezier(aT: aGuessT, aA1: c1.x, aA2: c2.x) - aX
            aGuessT -= currentX / currentSlope
        }
        return aGuessT
    }
}
