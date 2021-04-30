//
//  NumberFormatter+Common.swift
//  SOLTEC•Z
//
//  Created by Barry McMahon on 6/25/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import Foundation

extension NumberFormatter {

    func decimalString(places: Int = 1) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesSignificantDigits = true
        formatter.maximumSignificantDigits = places
        formatter.minimumSignificantDigits = places

        return formatter.string(for: self) ?? "~"
    }
}
