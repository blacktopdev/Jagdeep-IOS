//
//  Binding+Common.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 10/27/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

extension Binding {
    func didSet(execute: @escaping (Value) -> Void) -> Binding {
        return Binding(
            get: {
                return self.wrappedValue
            },
            set: {
                self.wrappedValue = $0
                execute($0)
            }
        )
    }
}
