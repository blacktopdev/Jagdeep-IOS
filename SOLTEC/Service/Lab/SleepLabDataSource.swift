//
//  SleepLabDataSource.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 3/25/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

private let defaultSleepNormalsFilename = "builtin"

class SleepLabDataSource: ObservableObject {

    @UserDefault(key: .selectedSleepNormalsPath,
                 defaultValue: defaultSleepNormalsFilename) var selectedSleepNormalsPath: String?

    private var preferredDocumentsURL: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }

    private var selectedSleepNormalsURL: URL! {
        if let path = selectedSleepNormalsPath {
            return preferredDocumentsURL?.appendingPathComponent(path)
        }
        return defaultURL
    }

    private let defaultURL: URL! = Bundle.main.bundleURL.appendingPathComponent(defaultSleepNormalsFilename)

    @Published var preferences: SleepLabPreferences

    @Published var dataSet: SleepLabDataSet
    @Published var filteredStages: StageFilter.Result = StageFilter.Result(sleepLevels: [], filteredCount: 0, correctedCount: 0)

    private let cancelBag = CancelBag()
    private var pathObserver: NSObject?

    init(preferences: SleepLabPreferences) {
        self.preferences = preferences
        dataSet = SleepLabDataSet(baseUrl: defaultURL)

        createPipelines()
    }

    private func createPipelines() {
        preferences.objectWillChange.sink {
            [weak self] _ in self?.objectWillChange.send()
        }
        .store(in: cancelBag)

        pathObserver = $selectedSleepNormalsPath.observe { [weak self] (old, new) in guard let self = self else { return }
            self.dataSet = SleepLabDataSet(baseUrl: self.selectedSleepNormalsURL)
        }

        preferences.$staging.combineLatest($dataSet).sink { [weak self] staging, data in guard let self = self else { return }
            let levelData: [Int] = data.stages.map { $0.sleepLevel }
            self.filteredStages = StageFilter.filtered(data: levelData,
                                                       filterMode: staging.filterMode,
                                                       width: staging.filterWidth,
                                                       stagingMode: staging.displayMode,
                                                       motionAffectsStaging: staging.motionAffectsStaging,
                                                       motionCounts: self.dataSet.motionCounts)
        }
        .store(in: cancelBag)
    }
}
