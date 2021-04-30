//
//  CoreDataQuery.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/21/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import CoreData

struct CoreDataQuery: RepositoryQuery {

    let predicate: NSPredicate?
    var sorts: [NSSortDescriptor]?
    var pageRange: Range<Int>?

    var fetchBatchSize: Int = 500

    func fetchRequest<M: Mappable>(type: M.Type) -> NSFetchRequest<M.StorableType> where M.StorableType: NSManagedObject {
        let request = NSFetchRequest<M.StorableType>(entityName: M.StorableType.entityName)

//    func fetchRequest<Object: NSManagedObject>(type: Object.Type) -> NSFetchRequest<Object> {
//        let request = NSFetchRequest<Object>(entityName: Object.entityName)

        request.fetchBatchSize = fetchBatchSize
        request.predicate = predicate
        request.sortDescriptors = sorts

        if let range = pageRange {
            request.fetchOffset = range.lowerBound
            request.fetchLimit = range.upperBound - range.lowerBound
        }
        return request
    }
}
