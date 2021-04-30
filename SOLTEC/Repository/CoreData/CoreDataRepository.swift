//
//  CoreDataRepository.swift
//  SOLTEC•Z
//
//  Inspired by design of Alexey Naumov on 12.04.2020.
//
//  Created by Jiropole on 10/25/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import CoreData
import Combine

extension NSManagedObject: Storable {
    typealias IDType = NSManagedObjectID

    enum StorableError: Error {
        case propertyNotFound
    }
}

class CoreDataRepository {

    enum RepositoryError: Error {
        case wrongStorableType
        case insertionFailure
        case persistentStore

        var description: String {
            switch self {
            case .wrongStorableType:
                return "Wrong Storable type for managed object"
            case .insertionFailure:
                return "Insertion failure"
            case .persistentStore:
                return "Persistent store error"
            }
        }
    }

    typealias DBOperation<Result> = (NSManagedObjectContext) throws -> Result

    private let container: NSPersistentContainer
    private let isStoreLoaded = CurrentValueSubject<Bool, Error>(false)
    private let bgQueue = DispatchQueue(label: "cdrepository")

    init(modelName: String,
         isMemoryOnly: Bool = false,
         path: String? = nil,
         deleteExisting: Bool = false) {

        container = NSPersistentContainer(name: modelName)
        let url = isMemoryOnly ? URL(fileURLWithPath: "/dev/null") : dbFileURL(modelName, path, .documentDirectory, .userDomainMask)
        guard let storeUrl = url else {
            isStoreLoaded.send(completion: .failure(RepositoryError.persistentStore))
            #if DEBUG
            assertionFailure(RepositoryError.persistentStore.description)
            #endif
            return
        }

        if deleteExisting {
            do {
                try FileManager().removeItem(at: storeUrl)
            } catch {
                Dlog("Failed to remove previous persistent store: \(error)")
            }
        }

        let description = NSPersistentStoreDescription(url: storeUrl)
        container.persistentStoreDescriptions = [description]

        bgQueue.async { [weak isStoreLoaded, weak container] in
            container?.loadPersistentStores { (_, error) in
                guard let container = container else { return }
                DispatchQueue.main.async {
                    if let error = error {
                        isStoreLoaded?.send(completion: .failure(error))
                    } else {
                        CoreDataRepository.configure(context: container.viewContext)
                        isStoreLoaded?.value = true
                    }
                }
            }
        }
    }

    private func dbFileURL(_ name: String,
                           _ path: String?,
                           _ directory: FileManager.SearchPathDirectory,
                           _ domainMask: FileManager.SearchPathDomainMask) -> URL? {
        return FileManager.default
            .urls(for: directory, in: domainMask).first?
            .appendingPathComponent(path ?? "")
            .appendingPathComponent("\(name).sql")
    }

    private static func configure(context: NSManagedObjectContext) {
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.undoManager = nil
        context.shouldDeleteInaccessibleFaults = true
    }

    private var onStoreIsReady: AnyPublisher<Void, Error> {
        return isStoreLoaded
            .filter { $0 }
            .map { _ in }
            .eraseToAnyPublisher()
    }
}

extension CoreDataRepository: Repository {

    typealias QueryType = CoreDataQuery
    typealias StorableType = NSManagedObject
    typealias ConnectorType = CoreDataConnector

    /// Retrieve mappable items matching the given query.
    func list<M: Mappable>(type: M.Type, query: QueryType) -> AnyPublisher<[M], Error> where M.StorableType: StorableType {
        let request = query.fetchRequest(type: type)

        let fetch = Future<[M], Error> { [weak container] promise in
            guard let context = container?.viewContext else { return }
            context.performAndWait {
                do {
                    let results = try context.fetch(request).map { M(storable: $0) }
                    promise(.success(results))
                } catch {
                    promise(.failure(error))
                }
            }
        }

        return onStoreIsReady
            .flatMap { fetch }
            .eraseToAnyPublisher()
    }

    /// Retrieve storables corresponding to the given ids.
    private func get<S: StorableType>(type: S.Type, ids: [NSManagedObjectID]) -> AnyPublisher<[S], Error> {
        let fetch = Future<[S], Error> { [weak container] promise in
            guard let context = container?.viewContext else { return }
            let result = ids.compactMap { context.object(with: $0) as? S }
            promise(.success(result))
        }
        return onStoreIsReady
            .flatMap { fetch }
            .eraseToAnyPublisher()
    }

    /// Retrieve mappables corresponding to the given ids.
    func get<M: Mappable>(type: M.Type, ids: [NSManagedObjectID]) -> AnyPublisher<[M], Error> where M.StorableType: StorableType {
        get(type: M.StorableType.self, ids: ids)
            .map { $0.map { M(storable: $0) } }
            .eraseToAnyPublisher()
    }

    /// Merge mappable `items` to storables.
//    func update<M: Mappable>(items: [M]) -> AnyPublisher<[M], Error>
    func update<M: Mappable>(items: [M]) -> AnyPublisher<Int, Error>
                where M.StorableType: StorableType, M.ConnectorType == ConnectorType {
        self.update { context in
            try self.updateRaw(items: items, context: context)
        }
        .flatMap { storables in
            Just(storables.count)
        }
//        .flatMap { storables in
//            // retrieve main context objects
//            self.get(type: M.self, ids: storables.map { $0.objectID })
//        }
        .eraseToAnyPublisher()
    }
}

extension CoreDataRepository {
    func changesPublisher<Object: NSManagedObject>(for fetchRequest: NSFetchRequest<Object>) -> ManagedObjectChangesPublisher<Object> {
        ManagedObjectChangesPublisher(fetchRequest: fetchRequest, context: container.viewContext)
    }
}

// MARK: - Internals

extension CoreDataRepository {
    /// Lower level call to query objects, using the current thread context.
    fileprivate func listRaw<M: Mappable>(type: M.Type, context: NSManagedObjectContext, query: QueryType) -> [M.StorableType] where M.StorableType: StorableType {
        return (try? context.fetch(query.fetchRequest(type: type))) ?? []
    }

    /// Lower level call to merge mappable `items` to storables, using the current thread context.
    fileprivate func updateRaw<M: Mappable>(items: [M], context: NSManagedObjectContext) throws -> [M.StorableType] where M.StorableType: StorableType, M.ConnectorType == ConnectorType {
        let connector = CoreDataConnector(repo: self, context: context)

        return try items.compactMap { item in
            if let identifier = item.storableIdentifier {
                guard let storable = context.object(with: identifier) as? M.StorableType else {
                    throw RepositoryError.wrongStorableType
                }

                try item.map(storable: storable, connector: connector)
                return storable
            }

            if let pred = item.findPredicate,
               let storable = listRaw(type: M.self, context: context, query: QueryType(predicate: pred)).first {
                try item.map(storable: storable, connector: connector)
                return storable
            }

            guard let storable = NSEntityDescription
                    .insertNewObject(forEntityName: M.StorableType.entityName, into: context) as? M.StorableType else {
                throw RepositoryError.insertionFailure
            }

            try item.map(storable: storable, connector: connector)
            return storable
        }
    }

    fileprivate func deleteRaw<S: StorableType.IDType>(ids: [S], context: NSManagedObjectContext) throws {
        for id in ids {
            context.delete(context.object(with: id))
        }
    }

    /// Lower level call to update the context using any `operation`. Executes on background context, publishes on main.
    private func update<Result>(_ operation: @escaping DBOperation<Result>) -> AnyPublisher<Result, Error> {
        let update = Future<Result, Error> { [weak bgQueue, weak container] promise in
            bgQueue?.async {
                guard let context = container?.newBackgroundContext() else { return }
//                CoreDataRepository.configure(context: context)
                context.mergePolicy = NSOverwriteMergePolicy    // no need to share this context
                context.performAndWait {
                    do {
                        let result = try operation(context)
                        if context.hasChanges {
                            try context.save()
                        }
                        context.reset()
                        promise(.success(result))
                    } catch {
                        context.reset()
                        promise(.failure(error))
                    }
                }
            }
        }
        return onStoreIsReady
            .flatMap { update }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// MARK: - CoreDataConnector

struct CoreDataConnector: RelationshipConnector {
    typealias RepoType = CoreDataRepository
    typealias StorableType = RepoType.StorableType

    private let repo: RepoType
    private let context: NSManagedObjectContext

    init(repo: RepoType, context: NSManagedObjectContext) {
        self.repo = repo
        self.context = context
    }

    func connect<P: Storable, C: Mappable>(_ relationship: RelationshipToOne<P, C>) throws where C.StorableType: StorableType, C.ConnectorType == CoreDataConnector {
        let existingChild = relationship.parent[keyPath: relationship.keyPath]
        if let child = existingChild {
            if let newChild = relationship.child {
                if relationship.options.contains(.overwrite) {
                    try newChild.map(storable: child, connector: self)
                }
            } else {
                try repo.deleteRaw(ids: [child.objectID], context: context)
            }
        } else if relationship.options.contains(.insert), let newChild = relationship.child {
            try relationship.parent[keyPath: relationship.keyPath] = repo.updateRaw(items: [newChild], context: context).first
        }
    }

    /// Not presently offering exacting control of overwrite/insert, assuming both are enabled for to-many relationships.
    /// This is a gap, but there is no plan to be connecting Mappables pre-associated with Storables, for now.
    func connect<P: Storable, C: Mappable>(_ relationship: RelationshipToMany<P, C>) throws where C.StorableType: StorableType, C.ConnectorType == CoreDataConnector {
        if let existingChildren = relationship.parent[keyPath: relationship.keyPath] {
            let updatedStorables = try repo.updateRaw(items: relationship.children, context: context)

            if relationship.options.contains(.delete) {
                let existingIds = Set(existingChildren.map { $0.objectID })
                let disusedIds = existingIds.subtracting(updatedStorables.map { $0.objectID })
                try repo.deleteRaw(ids: Array(disusedIds), context: context)
            }
            relationship.parent[keyPath: relationship.keyPath] = updatedStorables
        } else if relationship.options.contains(.insert) {
            try relationship.parent[keyPath: relationship.keyPath] = repo.updateRaw(items: relationship.children, context: context)
        } else if relationship.options.contains(.delete) {
            relationship.parent[keyPath: relationship.keyPath] = nil
        }
    }
}
