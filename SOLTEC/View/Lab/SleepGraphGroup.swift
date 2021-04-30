//
//  SleepGraphGroup.swift
//  SOLTEC•Lab
//
//  Created by Jiropole on 11/23/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI
import SciChart

struct SleepGraphGroup: View {
    @ObservedObject var dataSource: SleepLabDataSource

    @Binding var isMetricsDisplayed: Bool

    @State private var chartGroup = SCIChartVerticalGroup()

    private var stageResult: StageFilter.Result { dataSource.filteredStages }

    var stagesEpochInfo: [[String]] {
        [["W:", "R:", "L:", "D:"],
         ["\(stageResult.wakeEpochs)",
          "\(stageResult.remEpochs)",
          "\(stageResult.lightEpochs)",
          "\(stageResult.deltaEpochs)"],
         ["\(stageResult.wakePercent)%",
          "\(stageResult.remPercent)%",
          "\(stageResult.lightPercent)%",
          "\(stageResult.deltaPercent)%"]]
    }

    var stagesFilterInfo: [[String]] {
        [["Filtered:", "Corrected:"],
         ["\(stageResult.filteredCount)",
          "\(stageResult.correctedCount)"]]
    }

    private var motionCountCounts: Int { dataSource.dataSet.motionCounts.filter { $0 > 0 }.count }
    private var motionCountTotal: Int { dataSource.dataSet.motionCounts.reduce(0, +) }

    var motionInfo: [[String]] {
        guard !dataSource.preferences.motion.rawMode else {
            return [["Events:", "Index:"],
             ["\(dataSource.dataSet.motions.count)",
              String(format: "%.1f", Float(dataSource.dataSet.motions.count) /
                        Float(dataSource.dataSet.normals.count * 30 / 3600))]]
        }
        return [["Epochs:", "Motions:", "Index:"],
                ["\(motionCountCounts)",
                 "\(motionCountTotal)",
                 String(format: "%.1f", Float(motionCountCounts) /
                            Float(dataSource.dataSet.normals.count * 30 / 3600))]]
    }

    var arousalInfo: [[String]] {
        [["Events:", "Index:"],
         ["\(dataSource.dataSet.arousals.count)",
          String(format: "%.1f", Float(dataSource.dataSet.arousals.count) / Float(dataSource.dataSet.normals.count * 30 / 3600))]]
    }

    var body: some View {
        HStack(spacing: 8) {
            sidebarView
            graphsView
        }
        .animation(.easeInOut(duration: 0.4))
    }

    private var graphsView: some View {
        VStack(spacing: 8) {
            if dataSource.preferences.staging.displayMode != .hidden {
                SleepGraphView(dataSource: dataSource,
                               graphStyle: .stage, chartGroup: chartGroup)
                    .frame(maxHeight: 90)
            }

            if dataSource.preferences.motion.enabled {
                SleepGraphView(dataSource: dataSource,
                               graphStyle: dataSource.preferences.motion.rawMode ? .motion : .motionCounts,
                               chartGroup: chartGroup)
                    .frame(maxHeight: 70)

                SleepGraphView(dataSource: dataSource, graphStyle: .arousals, chartGroup: chartGroup)
                    .frame(maxHeight: 70)
            }

            SleepGraphView(dataSource: dataSource, graphStyle: .default, chartGroup: chartGroup)
        }
    }

    private var sidebarView: some View {
        VStack(spacing: 8) {
            if isMetricsDisplayed {
                if dataSource.preferences.staging.displayMode != .hidden {
                    VStack {
                        Spacer()
                        metricsView(with: stagesEpochInfo)
                        metricsView(with: stagesFilterInfo)
                    }
                    .frame(height: 90)
                }

                if dataSource.preferences.motion.enabled {
                    VStack {
                        Spacer()
                        metricsView(with: motionInfo)
                    }
                    .frame(height: 70)

                    VStack {
                        Spacer()
                        metricsView(with: arousalInfo)
                    }
                    .frame(height: 70)
                }

                VStack(alignment: .trailing) {
                    ForEach(Array(dataSource.preferences.normal.selectedTypes), id: \.self) { dataType in
                        Text(dataType.rawValue)
                            .foregroundColor(Color(dataType.color))
                    }
                }
                .frame(maxHeight: .infinity)
            }
        }
        .standardFont(size: 12, weight: .light)
    }

    private func metricsView(with items: [[String]]) -> some View {
        HStack {
            ForEach(items, id: \.self) { colItems in
                VStack(alignment: .trailing) {
                    ForEach(colItems, id: \.self) { text in
                        Text(text)
                    }
                }
            }
        }
    }
}

struct SleepGraphGroup_Previews: PreviewProvider {
    static var previews: some View {
        SCIChartSurface.setRuntimeLicenseKey(Constants.sciChartLicenseKey)
        
        return StatefulPreviewWrapper(true) { state in
            SleepGraphGroup(dataSource: SleepLabDataSource(preferences: SleepLabPreferences()),
                            isMetricsDisplayed: state)
                .labTheme()
                .previewDevice("iPhone 8")
        }
    }
}
