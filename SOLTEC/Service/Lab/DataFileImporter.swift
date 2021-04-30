//
//  DataFileImporter.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 10/16/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import Foundation
import SwiftCSV

extension CSV {
    var namedFloatRows: [[String: Float]] {
        return namedRows.map { row in
            row.reduce(into: [String: Float]()) { (result, tuple) in
                result[tuple.key] = Float(tuple.value)
            }
        }
    }
}

struct DataFileImporter {

    static let remoteBaseUrl = URL(string: "https://soltechealth.com/TroyDan/")

    static func downloadDataset(dataSetName: String, localFolder: ObservableFolder) -> ObservableFolder.LoaderResult {
        guard let remoteUrl = remoteBaseUrl else {
            return .failure("Invalid url")
        }

        var successResult: ObservableFolder.LoaderResult?
        var failResult: ObservableFolder.LoaderResult?

        SleepLabDataSet.Filename.allCases.forEach { (filename) in
            let result = localFolder.loadFile(fromBaseUrl: remoteUrl, path: "\(dataSetName)/\(filename.rawValue)")
            switch result {
            case .failure:
                failResult = result
            default:
                successResult = result
            }
        }

        return failResult ?? successResult ?? .none
    }

    private static func loadCSV(fromURL url: URL) -> CSV? {
        do {
            let contents = try String(contentsOf: url)
            return try CSV(string: contents, delimiter: ",", loadColumns: true)
        } catch let parseError as CSVParseError {
            print("Error parsing CSV: \(parseError)")
        } catch {
            print("Error loading CSV: \(error)")
        }
        return nil
    }

    static func loadEpochNormals(fromURL url: URL) -> [SleepSignal<Float>]? {
        guard let csv = loadCSV(fromURL: url) else { return nil }

        return csv.namedFloatRows.map { row in
            keyDataForNormal(row: row)
        }
    }

    private static let invalidPeak: Float = -1000.0

    static func loadMotions(fromURL url: URL) -> [SleepMotion] {
        guard let csv = loadCSV(fromURL: url) else { return [] }

        var motions = [SleepMotion]()
        var peak: Float = DataFileImporter.invalidPeak
        var sum: Float = 0
        var startTime: Float = 0
        var previousTime: Float = 0
        var count = 0
        for row in csv.namedFloatRows {
            guard let start = row["TIME"], let rawPower = row["POWER"] else { continue }
            let power = abs(rawPower)

            guard power != 0 else {
                if peak != DataFileImporter.invalidPeak {
                    motions.append(.init(started: startTime, duration: previousTime - startTime,
                                         intensityMean: sum / Float(count), intensityMax: peak))
                }
                peak = DataFileImporter.invalidPeak
                sum = 0
                count = 0
                startTime = start
                continue
            }

            peak = max(peak, power)
            sum += power
            count += 1
            previousTime = start
        }

        return motions
    }

    static func loadMotionCounts(fromURL url: URL) -> [Int] {
        guard let csv = loadCSV(fromURL: url) else { return [] }

        return csv.namedFloatRows.compactMap { row in
            Int(row["MOTIONCOUNT"] ?? 0)
        }
    }

    static func loadArousals(fromURL url: URL) -> [SleepArousal] {
        guard let csv = loadCSV(fromURL: url) else { return [] }

        var arousals = [SleepArousal]()
        for row in csv.namedFloatRows {
            guard let start = row["START"], let duration = row["DURATION"],
                  let low = row["LOW"], let high = row["HIGH"] else { continue }

            arousals.append(SleepArousal(started: start, duration: duration,
                                         pulseLow: low, pulseHigh: high))
        }

        return arousals
    }

    static func loadProtocols(fromURL url: URL) -> [SleepProtocol] {
        guard let csv = loadCSV(fromURL: url) else { return [] }

        var previousProtocol = SleepProtocol(started: -1, duration: 0, mField: 0, parameters: nil)
        var protocols = [SleepProtocol]()

        for row in csv.namedFloatRows {
            guard let epoch = row["EPOCH"], let mField = row["MFIELD"] else { continue }

            if previousProtocol.started >= 0 {
                protocols.append(SleepProtocol(started: previousProtocol.started,
                                               duration: epoch * 30 - previousProtocol.started,
                                               mField: previousProtocol.mField, parameters:
                                                previousProtocol.parameters))
            }

            previousProtocol = SleepProtocol(started: epoch * 30, duration: 0,
                                             mField: Int(mField), parameters: nil)
        }
        protocols.append(SleepProtocol(started: previousProtocol.started,
                                       duration: 30,
                                       mField: previousProtocol.mField,
                                       parameters: previousProtocol.parameters))

        return protocols
    }

    static func loadStages(fromURL url: URL) -> [SleepStageType] {
        guard let csv = loadCSV(fromURL: url) else { return [] }

        return csv.namedFloatRows.compactMap { row in
            SleepStageType.type(forLevel: Int(row["STAGE"] ?? 0))
        }
    }

    static func loadAggregates(fromURL url: URL) -> SleepSignal<SleepAggregateMetric>? {
        guard let csv = loadCSV(fromURL: url) else { return nil }

        var aggregates = [SleepAggregateMetric]()
        for row in csv.namedFloatRows {
            guard let mean = row["MEAN"], let min = row["MIN"],
                  let max = row["MAX"], let range = row["RANGE"] else { continue }

            aggregates.append(SleepAggregateMetric(mean: mean, min: min, max: max, range: range))
        }

        guard aggregates.count >= SleepSignalType.allCases.count else { return nil }

        return SleepSignal(veryLowPower: aggregates[SleepSignalType.veryLowPower.index],
                            lowPower: aggregates[SleepSignalType.lowPower.index],
                            highPower: aggregates[SleepSignalType.highPower.index],
                            veryLowPeak: aggregates[SleepSignalType.veryLowPeak.index],
                            lowPeak: aggregates[SleepSignalType.lowPeak.index],
                            highPeak: aggregates[SleepSignalType.highPeak.index],
                            veryLowMean: aggregates[SleepSignalType.veryLowMean.index],
                            lowMean: aggregates[SleepSignalType.lowMean.index],
                            highMean: aggregates[SleepSignalType.highMean.index],
                            totalPower: aggregates[SleepSignalType.totalPower.index],
                            highRatio: aggregates[SleepSignalType.highRatio.index],
                            lowRatio: aggregates[SleepSignalType.lowRatio.index],
                            veryLowRatio: aggregates[SleepSignalType.veryLowRatio.index],
                            newBandRatio: aggregates[SleepSignalType.newBandRatio.index],
                            pulseMean: aggregates[SleepSignalType.pulseMean.index],
                            pulseDeviation: aggregates[SleepSignalType.pulseDeviation.index],
                            o2Deviation: aggregates[SleepSignalType.o2Deviation.index],
                            breathMean: aggregates[SleepSignalType.breathMean.index],
                            breathDeviation: aggregates[SleepSignalType.breathDeviation.index],
                            minuteVent: aggregates[SleepSignalType.minuteVent.index])
    }

    static func loadLevels(fromURL url: URL) -> SleepTuningLevel? {
        guard let csv = loadCSV(fromURL: url),
              let row = csv.namedFloatRows.first,
              let REMlev = row["REMlev"],
              let WRlev = row["WRlev"],
              let Wlev = row["Wlev"] else { return nil }

        return SleepTuningLevel(rem: REMlev, wakeRem: WRlev, wake: Wlev)
    }

    private static func keyDataForNormal(row: [String: Float]) -> SleepSignal<Float> {
        // defining local variables to avoid compiler gets fussy about type-checking time
        let veryLowPower = row["VLFPWR"] ?? 0
        let lowPower = row["LFPWR"] ?? 0
        let highPower = row["HFPWR"] ?? 0
        let veryLowPeak = row["VLFP"] ?? 0
        let lowPeak = row["LFP"] ?? 0
        let highPeak = row["HFP"] ?? 0
        let veryLowMean = row["VLFWFV"] ?? 0
        let lowMean = row["LFWFV"] ?? 0
        let highMean = row["HFWFV"] ?? 0
        let totalPower = row["TP"] ?? 0
        let highRatio = row["LFHF"] ?? 0
        let lowRatio = row["FREQRATIO"] ?? 0
        let veryLowRatio = row["FREQRATIOV"] ?? 0
        let newBandRatio = row["NFBV"] ?? 0
        let pulse = row["PR"] ?? 0
        let pulseDeviation = row["SDNN"] ?? 0
        let o2Deviation = row["O2SD"] ?? 0
        let breath = row["BR"] ?? 0
        let breathDeviation = row["SDBB"] ?? 0
        let minuteVent = row["MINVENT"] ?? 0

        return SleepSignal<Float>(veryLowPower: veryLowPower,
                                   lowPower: lowPower,
                                   highPower: highPower,
                                   veryLowPeak: veryLowPeak,
                                   lowPeak: lowPeak,
                                   highPeak: highPeak,
                                   veryLowMean: veryLowMean,
                                   lowMean: lowMean,
                                   highMean: highMean,
                                   totalPower: totalPower,
                                   highRatio: highRatio,
                                   lowRatio: lowRatio,
                                   veryLowRatio: veryLowRatio,
                                   newBandRatio: newBandRatio,
                                   pulseMean: pulse,
                                   pulseDeviation: pulseDeviation,
                                   o2Deviation: o2Deviation,
                                   breathMean: breath,
                                   breathDeviation: breathDeviation,
                                   minuteVent: minuteVent)
    }
}
