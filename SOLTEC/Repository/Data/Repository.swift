//
//  Repository.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 10/1/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import Foundation
import Combine
import CoreData

protocol RepositoryQuery {}

protocol Repository {
    associatedtype QueryType: RepositoryQuery
    associatedtype StorableType: Storable
    associatedtype ConnectorType: RelationshipConnector

    func list<M: Mappable>(type: M.Type, query: QueryType) -> AnyPublisher<[M], Error> where M.StorableType == StorableType

    func get<M: Mappable>(type: M.Type, ids: [StorableType.IDType]) -> AnyPublisher<[M], Error> where M.StorableType == StorableType

    func update<M: Mappable>(items: [M]) -> AnyPublisher<Int, Error> where M.StorableType == StorableType, M.ConnectorType == ConnectorType
}

protocol RelationshipConnector {
//    typealias RepoType = CoreDataRepository
    associatedtype StorableType: Storable

    func connect<P: Storable, C: Mappable>(_ relationship: RelationshipToOne<P, C>) throws where C.StorableType == StorableType, C.ConnectorType == Self

    func connect<P: Storable, C: Mappable>(_ relationship: RelationshipToMany<P, C>) throws where C.StorableType == StorableType, C.ConnectorType == Self
}

struct RelationshipToOne<Parent: Storable, Child: Mappable> {
    let parent: Parent
    let child: Child?
    let keyPath: ReferenceWritableKeyPath<Parent, Child.StorableType?>
    var options: RelationshipOption = RelationshipOption.Preset.complete
}

struct RelationshipToMany<Parent: Storable, Child: Mappable> {
    let parent: Parent
    let children: [Child]
    let keyPath: ReferenceWritableKeyPath<Parent, [Child.StorableType]?>
    var options: RelationshipOption = RelationshipOption.Preset.complete
}

struct RelationshipOption: OptionSet {
    let rawValue: Int
    static let overwrite = RelationshipOption(rawValue: 1 << 0)
    static let insert = RelationshipOption(rawValue: 1 << 1)
    static let delete = RelationshipOption(rawValue: 1 << 2)

    struct Preset {
        static let additiveMerge: RelationshipOption = [.overwrite, .insert]
        static let complete: RelationshipOption = [.overwrite, .insert, .delete]
    }
}
