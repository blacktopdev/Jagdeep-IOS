//
//  NSManagedObject+App.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/15/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import CoreData

extension NSManagedObject {

    static var entityName: String {
        return String(describing: self).deletingPrefix("Core")
    }
}
