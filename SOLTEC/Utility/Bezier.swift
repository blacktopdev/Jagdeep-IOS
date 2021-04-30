//
//  Bezier.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/7/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import UIKit

struct CubicBezier<T: BinaryFloatingPoint> {
    let start: T
    let c1: T
    let c2: T
    let end: T

    init(start: T, c1: T, c2: T, end: T) {
        self.start = start
        self.c1 = c1
        self.c2 = c2
        self.end = end
    }

    func value(at t: T) -> T {
        let t_ = (T(1) - t)
        let tt_ = t_ * t_
        let ttt_ = t_ * t_ * t_

        let tt = t * t
        let ttt = t * t * t

        let startWeight = start * ttt_
        let c1Weight = T(3) * c1 * tt_ * t
        let c2Weight = T(3) * c2 * t_ * tt
        let endWeight = end * ttt

        return startWeight + c1Weight + c2Weight + endWeight

        // causes my compiler to fail checking types in reasonable type
        //        return start * ttt_
        //            + T(3) * c1 * tt_ * t
        //            + T(3) * c2 * t_ * tt
        //            + end * ttt
    }
}
