//
//  TrendedMetric.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 3/2/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation
import Combine
import CoreData

enum AggregateMetricType {
    /// Qualitative metric, [0, 100] scale.
    case quality(metric: TrendedMetric)
    /// Absolute duration. e.g. "7 hr 30 min (100%)"
    case duration(metric: TrendedMetric)
    /// Relative duration, by category.
    case ratio(metricA: TrendedMetric, metricB: TrendedMetric, category: String)
    /// Average events per hour.
    case index(metric: TrendedMetric)
    /// Event count by category.
    case count(metric: TrendedMetric, category: String)

    case event(metric: TrendedMetric)

    var metric: TrendedMetric {
        switch self {
        case .quality(let metric):
            return metric
        case .duration(let metric):
            return metric
        case .ratio(let metricA, _, _):
            return metricA
        case .index(let metric):
            return metric
        case .count(let metric, _):
            return metric
        case .event(let metric):
            return metric
        }
    }
}

class TrendedMetric: ObservableObject {
    @Published var yearData: [Double] = []

    func dataForDays(_ days: Int) -> [Double] {
        let count = min(days, yearData.count)
        let difference = days - count
        return Array(yearData[0..<count]) + (0..<difference).map { _ in Double(0) }
    }

//    var weekPoints: [GraphStandardPoint] {
//        pointsForDays(7)
//    }

    func pointsForDays(_ days: Int) -> [GraphStandardPoint] {
        let count = min(days, yearData.count)
        return dataForDays(days).reversed().enumerated().map { index, value in
            GraphStandardPoint(x: Double(-count + 1 + index), y: value)
        }
    }
}

class TrendedMetricPump<MType: Mappable> where MType.StorableType: NSManagedObject {

    let target: TrendedMetric
    let keyPath: AnyKeyPath
    let fetch: NSFetchRequest<MType.StorableType>

    typealias MapClosure = (MType.StorableType, Double) -> Double
    let map: MapClosure?

    private var yearData: [Double] = []

    private let cancelBag = CancelBag()

    init(repo: CoreDataRepository, keyPath: AnyKeyPath, target: TrendedMetric = TrendedMetric(), map: MapClosure? = nil) {
        self.keyPath = keyPath
        self.map = map
        self.target = target

        self.fetch = CoreDataQuery(predicate: nil,
                                   sorts: [NSSortDescriptor(keyPath: \CoreSleepScore.session?.started, ascending: false)])
            .fetchRequest(type: MType.self)
        subscribeToSource(repo: repo)
    }

    private func subscribeToSource(repo: CoreDataRepository) {
        let keyPath = self.keyPath
        let map = self.map
        target.$yearData.applyingChanges(objectChanges(repo: repo)) { (storable) -> Double in
            guard let s = storable[keyPath: keyPath] as? NSNumber else { return 0 }
            guard let map = map else { return Double(truncating: s) }
            return map(storable, Double(truncating: s))
//            return Double(truncating: s)
        }
        .sink { [weak target] objects in
            Dlog("Updating state: trended metric")
            target?.yearData = objects
        }
        .store(in: cancelBag)
    }

    private func objectChanges(repo: CoreDataRepository) -> AnyPublisher<CollectionDifference<MType.StorableType>, Never> {
        return repo.changesPublisher(for: fetch)
            .catch { _ in Empty() }
            .eraseToAnyPublisher()
    }
}

class DoubleTrendedMetricPump<MTypeA: Mappable, MTypeB: Mappable> where MTypeA.StorableType: NSManagedObject, MTypeB.StorableType: NSManagedObject {

    let targetA = TrendedMetric()
    let targetB = TrendedMetric()

    let pumpA: TrendedMetricPump<MTypeA>
    let pumpB: TrendedMetricPump<MTypeB>

    init(repo: CoreDataRepository,
         keyPathA: AnyKeyPath, keyPathB: AnyKeyPath,
         mapA: TrendedMetricPump<MTypeA>.MapClosure? = nil,
         mapB: TrendedMetricPump<MTypeB>.MapClosure? = nil) {
        pumpA = TrendedMetricPump<MTypeA>(repo: repo, keyPath: keyPathA, target: targetA, map: mapA)
        pumpB = TrendedMetricPump<MTypeB>(repo: repo, keyPath: keyPathB, target: targetB, map: mapB)
    }
}
