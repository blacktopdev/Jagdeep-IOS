//
//  DateComponentsFormatter+Common.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 3/10/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

extension DateComponentsFormatter {
    static var minuteDuration: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute]
        formatter.unitsStyle = .brief
        return formatter
    }

    static var mediumDuration: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.unitsStyle = .brief
        return formatter
    }

    static var shortDuration: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.unitsStyle = .positional
        return formatter
    }

    static var longDuration: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
//        formatter.unitsStyle = .abbreviated
        return formatter
    }
}
