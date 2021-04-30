//
//  CancelBag.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/30/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Combine

final class CancelBag {
    fileprivate(set) var subscriptions = Set<AnyCancellable>()

    var isEmpty: Bool { subscriptions.isEmpty }
    
    func cancel() {
        subscriptions.removeAll()
    }
}

extension AnyCancellable {

    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
