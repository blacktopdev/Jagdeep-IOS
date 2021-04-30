//
//  Storable.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 9/17/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import CoreData

/// Best if also Identifiable (allows Mappable.merge()), however it's not enforced here because
/// auto-gen NSManagedObject subclasses inject Indentifiable, causing redundant conformance errors.
protocol Storable {
    associatedtype IDType

    var objectID: IDType { get }
}
