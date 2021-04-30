//
//  PropertyWrappers.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 3/1/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

@propertyWrapper
struct Clamping<Value: Comparable> {
    var value: Value
    let range: ClosedRange<Value>

    init(initialValue value: Value, _ range: ClosedRange<Value>) {
        precondition(range.contains(value))
        self.value = value
        self.range = range
    }

    var wrappedValue: Value {
        get { value }
        set { value = min(max(range.lowerBound, newValue), range.upperBound) }
    }
}

