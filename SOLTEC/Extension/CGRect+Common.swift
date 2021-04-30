//
//  CGRect+Common.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/6/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import UIKit

extension CGRect {

    init(center: CGPoint, size: CGSize) {
        self.init(origin: CGPoint(x: center.x - size.width * 0.5,
                                  y: center.y - size.height * 0.5), size: size)
    }
}
