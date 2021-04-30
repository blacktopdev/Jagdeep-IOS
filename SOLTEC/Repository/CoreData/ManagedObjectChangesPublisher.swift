//
//  ManagedObjectChangesPublisher.swift
//  SOLTEC•Z
//
//  Thanks to Matt Moriarty https://www.mattmoriarity.com, from whom this code was lifted almost verbatim.
//  Created by Jiropole on 2/22/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Combine
import CoreData

extension NSManagedObjectContext {
    func changesPublisher<Object: NSManagedObject>(for fetchRequest: NSFetchRequest<Object>) -> ManagedObjectChangesPublisher<Object> {
        ManagedObjectChangesPublisher(fetchRequest: fetchRequest, context: self)
    }
}

struct ManagedObjectChangesPublisher<Object: NSManagedObject>: Publisher {
    typealias Output = CollectionDifference<Object>
    typealias Failure = Error

    let fetchRequest: NSFetchRequest<Object>
    let context: NSManagedObjectContext

    init(fetchRequest: NSFetchRequest<Object>, context: NSManagedObjectContext) {
        self.fetchRequest = fetchRequest
        self.context = context
    }

    func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
        let inner = Inner(downstream: subscriber, fetchRequest: fetchRequest, context: context)
        subscriber.receive(subscription: inner)
    }

    private final class Inner<Downstream: Subscriber>: NSObject, Subscription,
                                                       NSFetchedResultsControllerDelegate
    where Downstream.Input == CollectionDifference<Object>, Downstream.Failure == Error {
        private let downstream: Downstream
        private var fetchedResultsController: NSFetchedResultsController<Object>?

        init(
            downstream: Downstream,
            fetchRequest: NSFetchRequest<Object>,
            context: NSManagedObjectContext
        ) {
            self.downstream = downstream
            fetchedResultsController
                = NSFetchedResultsController(
                    fetchRequest: fetchRequest,
                    managedObjectContext: context,
                    sectionNameKeyPath: nil,
                    cacheName: nil)

            super.init()

            fetchedResultsController!.delegate = self

            do {
                try fetchedResultsController!.performFetch()
                updateDiff()
            } catch {
                downstream.receive(completion: .failure(error))
            }
        }

        private var demand: Subscribers.Demand = .none

        func request(_ demand: Subscribers.Demand) {
            self.demand += demand
            fulfillDemand()
        }

        private var lastSentState: [Object] = []
        private var currentDifferences = CollectionDifference<Object>([])!
        private var fetchedObjects: [Object] { Array(fetchedResultsController?.fetchedObjects ?? []) }

        private func updateDiff() {
            currentDifferences
                = Array(fetchedResultsController?.fetchedObjects ?? []).difference(
                    from: lastSentState)
            fulfillDemand()
        }

        private func fulfillDemand() {
            // Commented bits are original behavior. Changed to ensure *update* events are propagated. Bit of a hack.
            if demand > 0 /*&& !currentDifferences.isEmpty*/ {
                let newDemand: Subscribers.Demand
                if !currentDifferences.isEmpty {
                    newDemand = downstream.receive(currentDifferences)
                } else {
                    _ = downstream.receive(Array().difference(from: fetchedObjects))
                    newDemand = downstream.receive(fetchedObjects.difference(from: []))
                }
//                let newDemand = downstream.receive(currentDifferences)
                lastSentState = Array(fetchedResultsController?.fetchedObjects ?? [])
                currentDifferences = lastSentState.difference(from: lastSentState)

                demand += newDemand
                demand -= 1
            }
        }

        func cancel() {
            fetchedResultsController?.delegate = nil
            fetchedResultsController = nil
        }

        func controllerDidChangeContent(
            _ controller: NSFetchedResultsController<NSFetchRequestResult>
        ) {
            updateDiff()
        }

        override var description: String {
            "ManagedObjectChanges(\(Object.self))"
        }
    }
}

extension Publisher {
    func applyingChanges<Changes: Publisher, ChangeItem>(
        _ changes: Changes,
        _ transform: @escaping (ChangeItem) -> Output.Element
    ) -> AnyPublisher<Output, Failure>
    where Output: RangeReplaceableCollection,
          Output.Index == Int,
          Changes.Output == CollectionDifference<ChangeItem>,
          Changes.Failure == Failure {

        zip(changes) { existing, changes -> Output in
            var objects = existing
            for change in changes {
                switch change {
                case .remove(let offset, _, _):
                    objects.remove(at: offset)
                case .insert(let offset, let obj, _):
                    let transformed = transform(obj)
                    objects.insert(transformed, at: offset)
                }
            }
            return objects
        }.eraseToAnyPublisher()
    }
}

//class ToDoItemsViewModel {
//    private let context: NSManagedObjectContext
//    @Published private(set) var itemViewModels: [ToDoItemCellViewModel] = []
//    var itemChanges: AnyPublisher<CollectionDifference<ToDoItem>, Never> {
//        context.changesPublisher(for: ToDoItem.allItemsFetchRequest())
//            .catch { _ in Empty() }
//            .eraseToAnyPublisher()
//    }
//    init(context: NSManagedObjectContext = .view) {
//        self.context = context
//        $itemViewModels.applyingChanges(itemChanges) { toDoItem in
//            ToDoItemCellViewModel(item: toDoItem)
//        }.assign(to: \.itemViewModels, on: self).store(in: &cancellables)
//    }
//}
