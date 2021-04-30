//
//  SignalFilter.swift
//  SOLTEC•Lab
//
//  Created by Jiropole on 11/22/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import Foundation

struct SignalFilter {

    enum Mode {
        case none
        case classic
//        case realtime
        case lowpass
        case hann
    }

    static func filtered(data: [Float], mode: Mode, width: Int, alpha: Float = 0.25) -> [Float] {
        guard width > 1,
              data.count > width,
              mode != .none else { return data }

        if mode == .lowpass {
            return lowpassFiltered(data: data, alpha: alpha)
        }

        let halfWidth = Int((Float(width) / 2.0))
        let hannNominalArea = Float(StageFilter.hannNominalValue(forBins: width, alpha: 0.5))

        return data.enumerated().map { (index, _) in
            let range = (index - halfWidth)...(index + halfWidth)
            let windowedData: [Float]
            switch index {
            case 0..<halfWidth:
                let padCount = -range.lowerBound
                windowedData = (0..<padCount).map { _ in data[0] } + data.prefix(width - padCount)
            case _ where index >= data.count - halfWidth:
                let padCount = range.upperBound - (data.count - 1)
                windowedData = data.suffix(width - padCount)
                    + ((data.count - 1)..<range.upperBound).map { _ in data[data.count - 1] }
            default:
                windowedData = Array(data[range])
            }

            return filtered(data: windowedData, mode: mode, hannNominalArea: hannNominalArea)
        }
    }

    static func filtered(data: [Float], mode: Mode, hannNominalArea: Float) -> Float {
        switch mode {
        case .classic:
            return data.reduce(0, +) / Float(data.count)
        default:
            return data.enumerated()
                .reduce(0.0) { (result, tuple) -> Float in
                    let u = Double(tuple.offset) / Double(data.count - 1)
                    return result + tuple.element * Float(StageFilter.hannWindowValue(forU: u, alpha: 0.5))
                }
                // offset window gain
                / Float(hannNominalArea)
        }
    }

    static func lowpassFiltered(data: [Float], alpha: Float) -> [Float] {
        return data.enumerated().reduce([Float]()) { (result, iterator) in
            let last = result.last ?? 0
            let new = last + alpha * (iterator.element - last)
            return result + [new]
        }
    }
}
