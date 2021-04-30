//
//  GraphGridShape.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/8/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct GraphGridShape: Shape {
    let geometry: GraphAlignedGeometry

    func path(in rect: CGRect) -> Path {
        var path = Path()
        var rects = [CGRect]()
        guard let gridProvider = geometry.geometryProvider as? GraphStandardGridProvider else { return path }

        geometry.gridLinePositions(in: rect).forEach { position in
            let localPosition = CGFloat(position)
            let strokeWidth = gridProvider.strokeWidth(for: GraphStandardGridProvider.T(position))
            let dashPattern = gridProvider.dashPattern(for: GraphStandardGridProvider.T(position))

            switch geometry.axis.direction {
            case .vertical:
                if !dashPattern.isEmpty {
                    let ranges = dashRanges(length: rect.width, pattern: dashPattern)
                    ranges.forEach { x in
                        rects.append(CGRect(x: rect.minX + x.lowerBound,
                                            y: localPosition - strokeWidth * 0.5,
                                            width: x.upperBound - x.lowerBound,
                                            height: strokeWidth))
                    }
                } else {
                    rects.append(CGRect(x: rect.minX,
                                        y: localPosition - strokeWidth * 0.5,
                                        width: rect.width,
                                        height: strokeWidth))
                }

            case .horizontal:
                if !dashPattern.isEmpty {
                    let ranges = dashRanges(length: rect.height, pattern: dashPattern)
                    ranges.forEach { y in
                        rects.append(CGRect(x: localPosition - strokeWidth * 0.5,
                                            y: rect.maxY - y.upperBound,
                                            width: strokeWidth,
                                            height: y.upperBound - y.lowerBound))
                    }
                } else {
                    rects.append(CGRect(x: localPosition - strokeWidth * 0.5,
                                        y: rect.minY,
                                        width: strokeWidth,
                                        height: rect.height))
                }
            }
        }

        path.addRects(rects)
        return path
    }

    private func dashRanges(length: CGFloat, pattern: [CGFloat]) -> [Range<CGFloat>] {
        guard !pattern.isEmpty else { return [] }

        var x: CGFloat = 0
        var patternOffset = 0
        var result = [Range<CGFloat>]()

        while x < length {
            let onLength = pattern[patternOffset]
            result.append(x..<min(length, x + onLength))
            patternOffset = (patternOffset + 1) % pattern.count
            x += onLength + pattern[patternOffset]
            patternOffset = (patternOffset + 1) % pattern.count
        }

        return result
    }
}

//struct GraphGridShape_Previews: PreviewProvider {
//
//    static var axis: GraphView.Axis {
//        GraphView.Axis(name: "test",
//                       isFlipped: false,
//                       labelProvider: GraphView.StandardLabelProvider(stride: 20, formatter: NumberFormatter()),
//                       gridProvider: GraphView.StandardGridProvider(stride: 20, offset: 10, strokeWidth: 1))
//    }
//
//    static var previews: some View {
//        GraphGridShape(axis: axis)
//            .previewLayout(.sizeThatFits)
//            .fullscreenTheme()
//    }
//}
