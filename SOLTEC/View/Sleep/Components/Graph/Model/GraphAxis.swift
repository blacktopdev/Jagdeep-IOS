//
//  GraphAxis.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/9/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct GraphAxis {
    let name: String

    let direction: Axis

    var labelFill: GraphFillStyle = .color(Color.appMonoD8.opacity(0.4))

    var font: Font = .system(size: UIFontMetrics.default.scaledValue(for: 12))

    var labelProvider: GraphBasicLabelProvider?
    
    var gridProvider: GraphStandardGridProvider?

    var builder: ((AnyView) -> AnyView)?
}
