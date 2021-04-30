//
//  SleepLabData.swift
//  SOLTEC•Lab
//
//  Created by Jiropole on 11/23/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import Foundation
import Combine

struct SleepLabDataSet {

    enum Filename: String, CaseIterable {
        case fsen = "fsen.csv"
        case fsm = "fsm.csv"
        case fmovperepoch = "fmovperepoch.csv"
        case farousals = "farousals.csv"
        case fstage = "frawstage.csv"
        case flev = "flev.csv"
        case fint = "fint.csv"
        case faggregate = "file_sessionAggregates_mmm.csv"
    }

    let normals: [SleepSignal<Float>]
    let motions: [SleepMotion]
    let motionCounts: [Int]
    let arousals: [SleepArousal]
    let protocols: [SleepProtocol]
    let stages: [SleepStageType]
    let aggregates: SleepSignal<SleepAggregateMetric>?
    let level: SleepTuningLevel?

    init(baseUrl url: URL) {
        let normalsUrl = url.appendingPathComponent(Filename.fsen.rawValue)
        normals = DataFileImporter.loadEpochNormals(fromURL: normalsUrl) ?? []

        let motionsUrl = url.appendingPathComponent(Filename.fsm.rawValue)
        motions = DataFileImporter.loadMotions(fromURL: motionsUrl)

        let motionCountsUrl = url.appendingPathComponent(Filename.fmovperepoch.rawValue)
        motionCounts = DataFileImporter.loadMotionCounts(fromURL: motionCountsUrl)

        let arousalsUrl = url.appendingPathComponent(Filename.farousals.rawValue)
        arousals = DataFileImporter.loadArousals(fromURL: arousalsUrl)

        let protocolsUrl = url.appendingPathComponent(Filename.fint.rawValue)
        protocols = DataFileImporter.loadProtocols(fromURL: protocolsUrl)

        let stagesUrl = url.appendingPathComponent(Filename.fstage.rawValue)
        stages = DataFileImporter.loadStages(fromURL: stagesUrl)

        let aggregatesUrl = url.appendingPathComponent(Filename.faggregate.rawValue)
        aggregates = DataFileImporter.loadAggregates(fromURL: aggregatesUrl)

        let levelsUrl = url.appendingPathComponent(Filename.flev.rawValue)
        level = DataFileImporter.loadLevels(fromURL: levelsUrl)
    }
}
