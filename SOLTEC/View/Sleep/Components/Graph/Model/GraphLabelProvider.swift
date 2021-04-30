//
//  GraphLabelProvider.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/9/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

protocol GraphLabelProvider: GraphGeometryProvider {
    func label(for value: T) -> String?
}

class GraphBasicLabelProvider: GraphStandardGeometryProvider, GraphLabelProvider {
    let text: String?    // these all need to be updated to LocalizedStringKey

    init(stride: T, offset: T = 0, text: String? = nil) {
        self.text = text
        super.init(stride: stride, offset: offset)
    }

    func label(for value: T) -> String? {
        return text
    }
}

class GraphStandardLabelProvider: GraphBasicLabelProvider {
    let formatter: Formatter
    let hideZero: Bool

    init(stride: T, offset: T = 0, text: String? = nil, formatter: Formatter? = nil, hideZero: Bool = false) {
        self.formatter = formatter ?? NumberFormatter()
        self.hideZero = hideZero
        super.init(stride: stride, offset: offset, text: text)
    }
    
    override func label(for value: T) -> String? {
        if hideZero && value == 0 {
            return ""
        }
        return formatter.string(for: value) ?? text
    }
}

class GraphDateLabelProvider: GraphStandardLabelProvider {

//    var axisUnitsToDate: (TimeInterval) -> Date? = { value in Date() - value }

    override func label(for value: TimeInterval) -> String? {
//        if let date = axisUnitsToDate(value) {
            return formatter.string(for: Date(timeIntervalSinceReferenceDate: value))
//        }
//        return nil
    }
}
