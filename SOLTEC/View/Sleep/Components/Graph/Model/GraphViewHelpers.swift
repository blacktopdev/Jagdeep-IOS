//
//  GraphViewHelpers.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/12/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

private struct GraphYAxisAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        return context[.leading]
    }
}

extension HorizontalAlignment {
    static let graphViewYAxis: HorizontalAlignment = HorizontalAlignment(GraphYAxisAlignment.self)
}

struct GraphPreferenceData: Equatable {
    let spec: GraphSpec
    let rect: CGRect
}

struct GraphPreferenceKey: PreferenceKey {
    typealias Value = [GraphPreferenceData]

    static var defaultValue: [GraphPreferenceData] = []

    static func reduce(value: inout [GraphPreferenceData],
                       nextValue: () -> [GraphPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

struct GraphPreferencesSetter: View {
    let spec: GraphSpec

    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .preference(key: GraphPreferenceKey.self,
                            value: [GraphPreferenceData(spec: spec, rect: geometry.frame(in: .local))])
        }
    }
}
