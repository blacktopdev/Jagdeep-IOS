//
//  GraphGeometryProvider.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/17/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import Foundation

// swiftlint:disable type_name
protocol GraphGeometryProvider {
    associatedtype T: BinaryFloatingPoint

    var stride: T { get }
    var offset: T { get }
}

class GraphStandardGeometryProvider: GraphGeometryProvider {
    let stride: Double
    let offset: Double

    init(stride: Double, offset: Double) {
        self.stride = stride
        self.offset = offset
    }
}
