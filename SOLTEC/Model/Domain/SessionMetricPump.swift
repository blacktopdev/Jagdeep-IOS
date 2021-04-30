//
//  SessionMetricPump.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 3/15/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation
import Combine
import CoreData

class SessionMetric: ObservableObject {
    @Published var sessionData: [Double] = []

//    private let session: SleepSession
//
//    init(session: SleepSession) {
//        self.session = session
//    }

//    var points: [GraphStandardPoint] {
//        sessionData.map { }
//    }
//
//    func pointsForDays(_ days: Int) -> [GraphStandardPoint] {
//        let count = min(days, yearData.count)
//        let difference = days - count
//        let paddedData = Array(yearData[0..<count]) + (0..<difference).map { _ in Double(0) }
//        return paddedData.reversed().enumerated().map { index, value in
//            GraphStandardPoint(x: Double(-count + 1 + index), y: value)
//        }
//    }
}

class SessionEventPump<MType: Mappable>: ObservableObject where MType.StorableType: NSManagedObject {

    let target = SessionMetric()
    let keyPath: AnyKeyPath
    let fetch: NSFetchRequest<MType.StorableType>

    typealias MapClosure = (MType.StorableType, Double) -> Double
    let map: MapClosure?

    private var yearData: [Double] = []

    private let cancelBag = CancelBag()

    init(repo: CoreDataRepository, keyPath: AnyKeyPath, map: MapClosure? = nil) {
        self.keyPath = keyPath
        self.map = map
        self.fetch = CoreDataQuery(predicate: nil,
                                   sorts: [NSSortDescriptor(keyPath: \CoreSleepScore.session?.started, ascending: false)])
            .fetchRequest(type: MType.self)
        subscribeToSource(repo: repo)
    }

    private func subscribeToSource(repo: CoreDataRepository) {
        let keyPath = self.keyPath
        let map = self.map
        target.$sessionData.applyingChanges(objectChanges(repo: repo)) { (storable) -> Double in
            guard let s = storable[keyPath: keyPath] as? NSNumber else { return 0 }
            guard let map = map else { return Double(truncating: s) }
            return map(storable, Double(truncating: s))
//            return Double(truncating: s)
        }
        .sink { [weak target] objects in
            Dlog("Updating state: trended metric")
            target?.sessionData = objects
        }
        .store(in: cancelBag)
    }

    private func objectChanges(repo: CoreDataRepository) -> AnyPublisher<CollectionDifference<MType.StorableType>, Never> {
        return repo.changesPublisher(for: fetch)
            .catch { _ in Empty() }
            .eraseToAnyPublisher()
    }
}
