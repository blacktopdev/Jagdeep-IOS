//
//  StageFilter.swift
//  SOLTEC•Lab
//
//  Created by Jiropole on 11/22/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import Foundation

struct StageFilter {

    enum StagingMode {
        case hidden
        case raw
        case filtered
        case final
    }

    enum FilterMode {
        case classic
        case hamming
        case hann
    }

    struct Result {
        let sleepLevels: [Int]
        let filteredCount: Int
        let correctedCount: Int

        let wakeEpochs: Int
        let remEpochs: Int
        let lightEpochs: Int
        let deltaEpochs: Int

        var wakePercent: Int {
            return Int(round(100 * Double(wakeEpochs) / Double(sleepLevels.count)))
        }
        var remPercent: Int {
            return Int(round(100 * Double(remEpochs) / Double(sleepLevels.count)))
        }
        var lightPercent: Int {
            return Int(round(100 * Double(lightEpochs) / Double(sleepLevels.count)))
        }
        var deltaPercent: Int {
            return Int(round(100 * Double(deltaEpochs) / Double(sleepLevels.count)))
        }

        init(sleepLevels: [Int], filteredCount: Int, correctedCount: Int) {
            self.sleepLevels = sleepLevels
            self.filteredCount = filteredCount
            self.correctedCount = correctedCount

            wakeEpochs = sleepLevels.filter { $0 == 0 }.count
            remEpochs = sleepLevels.filter { $0 == 1 }.count
            lightEpochs = sleepLevels.filter { $0 == 2 }.count
            deltaEpochs = sleepLevels.filter { $0 == 3 }.count
        }
    }

    // swiftlint:disable function_parameter_count
    static func filtered(data: [Int], filterMode: FilterMode, width: Int,
                         stagingMode: StagingMode, motionAffectsStaging: Bool,
                         motionCounts: [Int]) -> Result {
        guard width > 1,
              data.count > width,
              stagingMode == .filtered || stagingMode == .final else {
            return Result(sleepLevels: data, filteredCount: 0, correctedCount: 0)
        }

        let halfWidth = Int((Float(width) / 2.0))

        var filteredCount = 0
        let filtered = data.enumerated().map { (index, _) -> Int in
            switch index {
            case 0..<halfWidth:
                return data[halfWidth]
            case _ where index >= data.count - halfWidth:
                return data[data.count - halfWidth]
            default:
                let subArray = Array(data[(index - halfWidth)...(index + halfWidth)])

                switch filterMode {

                case .classic:
                    let wakes = subArray.filter { $0 == SleepStageType.wake.sleepLevel }.count
                    let rems = subArray.filter { $0 == SleepStageType.rem.sleepLevel }.count
                    let lights = subArray.filter { $0 == SleepStageType.light.sleepLevel }.count
                    let deltas = subArray.filter { $0 == SleepStageType.delta.sleepLevel }.count

                    if wakes > halfWidth && data[index] != SleepStageType.wake.sleepLevel {
                        filteredCount += 1
                        return SleepStageType.wake.sleepLevel
                    }
                    if rems > halfWidth && data[index] != SleepStageType.rem.sleepLevel {
                        filteredCount += 1
                        return SleepStageType.rem.sleepLevel
                    }
                    if lights > halfWidth && data[index] != SleepStageType.light.sleepLevel {
                        filteredCount += 1
                        return SleepStageType.light.sleepLevel
                    }
                    if deltas > halfWidth && data[index] != SleepStageType.delta.sleepLevel {
                        filteredCount += 1
                        return SleepStageType.delta.sleepLevel
                    }
                    return data[index]

                case .hamming, .hann:
                    let windowAlpha = filterMode == .hamming ? 0.54 : 0.5
                    let predominant = cosineWindowPredominant(typeIn: subArray,
                                                              alpha: windowAlpha)
                    if predominant.sleepLevel != data[index] {
                        filteredCount += 1
                    }
                    return predominant.sleepLevel
                }
            }
        }

        guard stagingMode == .final else {
            return Result(sleepLevels: filtered, filteredCount: filteredCount, correctedCount: 0)
        }

        var correctedCount = 0

        let final = filtered.enumerated().map { (index, sleepLevel) -> Int in
            guard motionAffectsStaging,
                  index < motionCounts.count,
                  motionCounts[index] > 0,
                  sleepLevel != SleepStageType.wake.sleepLevel,
                  data[index] != SleepStageType.wake.sleepLevel else {
                return sleepLevel
            }

            correctedCount += 1
            return SleepStageType.wake.sleepLevel
        }

        return Result(sleepLevels: final, filteredCount: filteredCount, correctedCount: correctedCount)
    }

    private static func cosineWindowPredominant(typeIn data: [Int], alpha: Double) -> SleepStageType {
        let wakeWeight = cosineWeight(ofValue: SleepStageType.wake.sleepLevel, inArray: data, alpha: alpha)
        let remWeight = cosineWeight(ofValue: SleepStageType.rem.sleepLevel, inArray: data, alpha: alpha)
        let lightWeight = cosineWeight(ofValue: SleepStageType.light.sleepLevel, inArray: data, alpha: alpha)
        let deltaWeight = cosineWeight(ofValue: SleepStageType.delta.sleepLevel, inArray: data, alpha: alpha)

        let predominant =
            [(type: SleepStageType, weight: Double)](arrayLiteral: (SleepStageType.wake, wakeWeight),
                                                     (SleepStageType.rem, remWeight),
                                                     (SleepStageType.light, lightWeight),
                                                     (SleepStageType.delta, deltaWeight))
            .sorted { (a, b) -> Bool in
                a.weight <= b.weight
            }.last!

        return predominant.type
    }

    private static func cosineWeight(ofValue value: Int, inArray array: [Int], alpha: Double) -> Double {
        return array.enumerated().reduce(0.0) { (result, tuple) in
            guard tuple.element == value else { return result }
            return result + hannWindowValue(forU: Double(tuple.offset) / Double(array.count - 1), alpha: alpha)
        }
    }

    static func hannWindowValue(forU u: Double, alpha: Double = 0.54) -> Double {
        return alpha - (1 - alpha) * cos(2 * .pi * u)
    }

    static func hannNominalValue(forBins bins: Int, alpha: Double) -> Double {
        return (0..<bins).reduce(0.0) { (result, index) in
            return result + hannWindowValue(forU: Double(index) / Double(bins - 1), alpha: alpha)
        }
    }
}
