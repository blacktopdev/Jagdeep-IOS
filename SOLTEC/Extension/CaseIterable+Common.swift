//
//  CaseIterable+Common.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/2/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

extension CaseIterable where Self: Equatable, AllCases: BidirectionalCollection {
    var allCases: AllCases { Self.allCases }

    static var first: Self {
        allCases.first!
    }

    static var last: Self {
        allCases.last!
    }

    var next: Self {
        guard Self.last != self else { return self }
        return allCases[allCases.index(after: index)]
    }

    var previous: Self {
        guard Self.first != self else { return self }
        return allCases[allCases.index(before: index)]
    }

    var index: Self.AllCases.Index {
        allCases.firstIndex(of: self)!
    }
}
