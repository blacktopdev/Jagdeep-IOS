//
//  GraphLayoutProvider.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/20/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

protocol GraphLayoutProvider {
    func size(forAxis axis: Axis, index: Int) -> CGFloat
    func spacing(afterAxis axis: Axis, index: Int) -> CGFloat
}

struct GraphStandardLayoutProvider: GraphLayoutProvider {
    let size: CGSize
    let spacing: CGSize

    func size(forAxis axis: Axis, index: Int) -> CGFloat {
        return axis == .horizontal ? size.height : size.width
    }

    func spacing(afterAxis axis: Axis, index: Int) -> CGFloat {
        return axis == .horizontal ? spacing.height : spacing.width
    }
}
