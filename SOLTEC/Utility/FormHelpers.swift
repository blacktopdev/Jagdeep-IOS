//
//  FormHelpers.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/4/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct FormHelpers {
    static var heightComponents: [[ClassicPickerView.Item]] {
        switch Locale.current.usesMetricSystem {
        case true:
            let centimeters = (10...250).map { cm in
                ClassicPickerView.Item(text: "\(cm) cm", value: cm) }
            return [centimeters]

        case false:
            let feet = (1...8).map { feet in
                ClassicPickerView.Item(text: "\(feet)'", value: feet) }
            let inches = (0..<12).map { inches in
                ClassicPickerView.Item(text: "\(inches)\"", value: inches) }

            return [feet, inches]
        }
    }

    static var defaultHeightComponentValues: [ClassicPickerView.Item] {
        switch Locale.current.usesMetricSystem {
        case true:
            return [ClassicPickerView.Item(text: "150 cm", value: 150)]
        case false:
            return [ClassicPickerView.Item(text: "5'", value: 5),
                    ClassicPickerView.Item(text: "0\"", value: 0)]
        }
    }

    static var weightComponents: [[ClassicPickerView.Item]] {
        let values = (50...400).map { value in
            ClassicPickerView.Item(text: "\(value)", value: value)
        }
        return [values, [ClassicPickerView.Item(text: "lbs", value: "lbs"),
                         ClassicPickerView.Item(text: "kg", value: "kg")]]
    }

    static var defaultWeightComponentValues: [ClassicPickerView.Item] {
        switch Locale.current.usesMetricSystem {
        case true:
            return [ClassicPickerView.Item(text: "70", value: 70),
                    ClassicPickerView.Item(text: "kg", value: "kg")]
        case false:
            return [ClassicPickerView.Item(text: "150", value: 150),
                    ClassicPickerView.Item(text: "lbs", value: "lbs")]
        }
    }

    static var genderComponents: [[ClassicPickerView.Item]] {
        return [[ClassicPickerView.Item(text: "Female", value: "female"),
                 ClassicPickerView.Item(text: "Male", value: "male")]]
    }

    static var defaultGenderComponentValues: [ClassicPickerView.Item] {
        return [ClassicPickerView.Item(text: "Female", value: "female")]
    }
}
