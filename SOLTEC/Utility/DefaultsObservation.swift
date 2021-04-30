//
//  DefaultsObservation.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 3/25/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation
import Combine

class DefaultsObservation<T: PropertyListValue>: NSObject {
    let key: Key
    private var onChange: (T?, T?) -> Void

    // 1
    init(key: Key, onChange: @escaping (T?, T?) -> Void) {
        self.onChange = onChange
        self.key = key
        super.init()
        UserDefaults.standard.addObserver(self, forKeyPath: key.rawValue, options: [.old, .new], context: nil)
    }

    // 2
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change, object != nil, keyPath == key.rawValue else { return }
        onChange(change[.oldKey] as? T, change[.newKey] as? T)
    }

    // 3
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: key.rawValue, context: nil)
    }
}

// The marker protocol
protocol PropertyListValue {}

extension Data: PropertyListValue {}
extension String: PropertyListValue {}
extension Date: PropertyListValue {}
extension Bool: PropertyListValue {}
extension Int: PropertyListValue {}
extension Double: PropertyListValue {}
extension Float: PropertyListValue {}

// Every element must be a property-list type
extension Array: PropertyListValue where Element: PropertyListValue {}
extension Dictionary: PropertyListValue where Key == String, Value: PropertyListValue {}

struct Key: RawRepresentable {
    let rawValue: String
}

extension Key: ExpressibleByStringLiteral {
    init(stringLiteral: String) {
        rawValue = stringLiteral
    }
}

@propertyWrapper
struct UserDefault<T: PropertyListValue> {
    let key: Key
    let defaultValue: T

    var wrappedValue: T? {
        get { UserDefaults.standard.value(forKey: key.rawValue) as? T }
        set { UserDefaults.standard.set(newValue, forKey: key.rawValue) }
    }

    var projectedValue: UserDefault<T> { return self }

//    var publisher: CurrentValueSubject<T, Never>
//
//    private var defaultsObserver: DefaultsObservation<T>?

    init(key: Key, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
//        self.publisher = CurrentValueSubject(defaultValue)
//        defaultsObserver = DefaultsObservation(key: key) { [weak self] old, new in
//            if let new = new {
//                self?.publisher.value = new
//            }
//        }
    }

    func observe(change: @escaping (T?, T?) -> Void) -> NSObject {
        change(nil, wrappedValue)
        return DefaultsObservation<T>(key: key, onChange: change)
//        { old, new in
//            change(old, new)
//        }
    }
}

