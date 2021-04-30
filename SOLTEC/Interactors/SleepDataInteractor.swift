//
//  SleepDataInteractor.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/13/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

private let startDelay = 0.1

class SleepDataInteractor {

    private let appState: AppState
    private let dataRepo: CoreDataRepository
    private let webRepo: SleepWebRepository
    private let syncInterval: TimeInterval

//    private var lastError: Error?
    private let timerBag = CancelBag()
    private let cancelBag = CancelBag()

    // used temporarily
    private var loadedUser: User?

    init(appState: AppState, dataRepo: CoreDataRepository, webRepo: SleepWebRepository, syncInterval: TimeInterval = 60*30) {
        self.appState = appState
        self.dataRepo = dataRepo
        self.webRepo = webRepo
        self.syncInterval = syncInterval

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in self?.start() }
    }

    /// When enabled, the server is queried for new updates at `syncInterval`.
    var isAutocheckingUpdates: Bool = false {
        didSet {
            guard isAutocheckingUpdates != oldValue else { return }
            if isAutocheckingUpdates {
                self.checkForUpdates()
                guard timerBag.isEmpty else { return }

                Timer.publish(every: syncInterval, on: .main, in: .default)
                    .autoconnect()
                    .sink { [weak self] _ in self?.checkForUpdates() }
                    .store(in: self.timerBag)
            } else {
                timerBag.cancel()
            }
        }
    }

    private func start() {
        DispatchQueue.main.asyncAfter(deadline: .now() + startDelay) { [weak self] in
            self?.isAutocheckingUpdates = true
        }

        appState.$recentSessions.applyingChanges(sessionChanges) { (storable) -> SleepSession in
            MappableSleepSession(storable: storable).domain
        }
        .sink { [weak self] sessions in
            Dlog("Updating state: recentSessions")
            // here is where we'd probably run another process to re-qualify recent sessions as night or nap
            //
            // <stuff>
            self?.appState.recentSessions = sessions
        }
        .store(in: cancelBag)
    }

    private var sessionChanges: AnyPublisher<CollectionDifference<CoreSleepSession>, Never> {
        let request = CoreDataQuery(predicate: nil,
                                    sorts: [NSSortDescriptor(key: "started", ascending: false)],
                                    pageRange: 0..<2)
            .fetchRequest(type: MappableSleepSession.self)
        return dataRepo.changesPublisher(for: request)
            .catch { _ in Empty() }
            .eraseToAnyPublisher()
    }

    private func checkForUpdates() {
        // for now, just loading test data. Don't keep loading larger test data.
        guard appState.recentSessions.count < 2 else {
            return
        }
        appState.prefs.isCloudSyncing = true
        
        webRepo.loadMockData()
            .sink(receiveCompletion: { (completion) in
                Dlog("Completed load: \(completion)")
            }) { [weak self] user in
                self?.update(objects: [MappableUser(domain: user)])
                self?.loadedUser = user
            }
            .store(in: cancelBag)
    }

    private func update<M: Mappable>(objects: [M]) where M.StorableType: CoreDataRepository.StorableType,
                                                         M.ConnectorType == CoreDataRepository.ConnectorType,
                                                         M.DomainType: DomainObject {
        dataRepo.update(items: objects)
            .sink(receiveCompletion: { (completion) in
                Dlog("Completed update: \(completion)")
            }, receiveValue: { [weak self] (count) in
                Dlog("Merged \(count) \(String(describing: M.DomainType.self))")
                self?.appState.prefs.isCloudSyncing = false
                // control of currentUser will be shared with future authentication module
                if let user = self?.loadedUser { self?.appState.currentUser = user }
            })
            .store(in: cancelBag)
    }

//    func merge(objects: [SleepSession]) {
//        update(objects: objects.map { MappableSleepSession(domain: $0) })
//    }
//
//    func update(user: User) {
//        update(objects: [MappableUser(domain: user)])
//    }

//
//    let responsePredicate = NSPredicate(format: "%K.%K.%K.%K != %@", Response.KeyNames.responseTemplate,
//                                        ResponseTemplate.KeyNames.queryTemplate,
//                                        QueryTemplate.KeyNames.surveyTemplate,
//                                        SurveyTemplate.KeyNames.personaTemplate, corePT)
    
//    func getMotions(startDate: Date, window: TimeInterval) -> AnyPublisher<[SleepMotion], Error> {
//
//    }
}

extension SleepDataInteractor {
    // MARK: - Sleep Score Trends

    var overallMetric: TrendedMetricPump<MappableSleepScore> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepScore.overall)
    }

    var asleepMetric: TrendedMetricPump<MappableSleepScore> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepScore.duration)
    }

    var deltaMetric: TrendedMetricPump<MappableSleepScore> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepScore.delta)
    }

    var remMetric: TrendedMetricPump<MappableSleepScore> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepScore.rem)
    }

    var latencyMetric: TrendedMetricPump<MappableSleepScore> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepScore.latency)
    }

    var efficiencyMetric: TrendedMetricPump<MappableSleepScore> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepScore.efficiency)
    }

    var o2seMetric: TrendedMetricPump<MappableSleepScore> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepScore.o2seIndex)
    }
}

extension SleepDataInteractor {
    // MARK: - Sleep Time Trends

    var recordingTimeMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepSessionMetric.recordDuration)
    }

    var sleepTimeMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepSessionMetric.sleepDuration)
    }

    var sleepOnsetMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepSessionMetric.sleepOnset)
    }

    var sleepPercentMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepSessionMetric.sleepDuration) { storable, value in
            value / Double(storable.recordDuration) * 100
        }
    }
}

extension SleepDataInteractor {
    // MARK: - Stages Report Trends

    var wakeTimeMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo,
                          keyPath: \CoreSleepSessionMetric.cumulativeTime?.wake)
    }

    var wakePercentNightMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo,
                          keyPath: \CoreSleepSessionMetric.cumulativeTime?.wake) { storable, value in
            value / Double(storable.recordDuration) * 100
        }
    }

    var remTimeMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo,
                          keyPath: \CoreSleepSessionMetric.cumulativeTime?.rem)
    }

    var remPercentNightMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo,
                          keyPath: \CoreSleepSessionMetric.cumulativeTime?.rem) { storable, value in
            value / Double(storable.recordDuration) * 100
        }
    }

    var remPercentSleepMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo,
                          keyPath: \CoreSleepSessionMetric.cumulativeTime?.rem) { storable, value in
            value / Double(storable.sleepDuration) * 100
        }
    }

    var lightTimeMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo,
                          keyPath: \CoreSleepSessionMetric.cumulativeTime?.light)
    }

    var lightPercentNightMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo,
                          keyPath: \CoreSleepSessionMetric.cumulativeTime?.light) { storable, value in
            value / Double(storable.recordDuration) * 100
        }
    }

    var lightPercentSleepMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo,
                          keyPath: \CoreSleepSessionMetric.cumulativeTime?.light) { storable, value in
            value / Double(storable.sleepDuration) * 100
        }
    }

    var deltaTimeMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo,
                          keyPath: \CoreSleepSessionMetric.cumulativeTime?.delta)
    }

    var deltaPercentNightMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo,
                          keyPath: \CoreSleepSessionMetric.cumulativeTime?.delta) { storable, value in
            value / Double(storable.recordDuration) * 100
        }
    }

    var deltaPercentSleepMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo,
                          keyPath: \CoreSleepSessionMetric.cumulativeTime?.delta) { storable, value in
            value / Double(storable.sleepDuration) * 100
        }
    }
}

extension SleepDataInteractor {
    // MARK: - O2SE Report Trends

    var remO2SEsMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepSessionMetric.remEvent?.o2seCount)
    }

    var remDesatsMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepSessionMetric.remEvent?.desatCount)
    }

    var remSnoresMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepSessionMetric.remEvent?.soundCount)
    }

    var remArousalsMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepSessionMetric.remEvent?.arousalCount)
    }

    var lightO2SEsMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepSessionMetric.lightEvent?.o2seCount)
    }

    var lightDesatsMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepSessionMetric.lightEvent?.desatCount)
    }

    var lightSnoresMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepSessionMetric.lightEvent?.soundCount)
    }

    var lightArousalsMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepSessionMetric.lightEvent?.arousalCount)
    }

    var deltaO2SEsMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepSessionMetric.deltaEvent?.o2seCount)
    }

    var deltaDesatsMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepSessionMetric.deltaEvent?.desatCount)
    }

    var deltaSnoresMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepSessionMetric.deltaEvent?.soundCount)
    }

    var deltaArousalsMetric: TrendedMetricPump<MappableSleepSessionMetric> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepSessionMetric.deltaEvent?.arousalCount)
    }

    // MARK: Index Trends
    var o2SEIndexMetric: TrendedMetricPump<MappableSleepScore> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepScore.o2seIndex)
    }

    var desatIndexMetric: TrendedMetricPump<MappableSleepScore> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepScore.desatIndex)
    }

    var snoreIndexMetric: TrendedMetricPump<MappableSleepScore> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepScore.soundIndex)
    }

    var arousalIndexMetric: TrendedMetricPump<MappableSleepScore> {
        TrendedMetricPump(repo: dataRepo, keyPath: \CoreSleepScore.arousalIndex)
    }
}
