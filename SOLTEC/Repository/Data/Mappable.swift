//
//  Mappable.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 11/15/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import CoreData

protocol Mappable {
    associatedtype DomainType
    associatedtype StorableType: Storable
    associatedtype ConnectorType: RelationshipConnector

    /// Domain object.
    var domain: DomainType { get }

    /// Storable unique identifier.
    var storableIdentifier: StorableType.IDType? { get }

    // this isn't right, but quick and dirty fix. The whole storable/mappable thing is damn hard to abstract properly,
    // to where I'm starting to wonder its real facility.
    var findPredicate: NSPredicate? { get }

    /// Create a new mappable with the given domain object.
    init(domain: DomainType, storableIdentifier: StorableType.IDType?)

    /// Create a new mappable with the given storable object.
    init(storable: StorableType)

    /// Create a new mappable with the given `domain`, keeping previous identifier.
    func updating(domain: DomainType) -> Self

    /// Map the domain attribute values into the given storable.
    /// This may be a deep copy, creating any necessary structure.
    func map(storable: StorableType, connector: ConnectorType) throws
}

extension Mappable {
    var findPredicate: NSPredicate? {
        return nil
    }

    func updating(domain: DomainType) -> Self {
        return type(of: self).init(domain: domain, storableIdentifier: storableIdentifier)
    }
}
