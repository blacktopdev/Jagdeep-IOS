//
//  RegistrationFormModel.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/22/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

class RegistrationFormModel: ObservableObject {
    enum Page: CaseIterable {
        case introduction
        case credentials
        case name
        case birthDate
        case height
        case weight
        case gender
        case complete
    }

    struct Field {
        static let email = "email"
        static let password = "password"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let birthDate = "birthDate"
        static let height = "height"
        static let weight = "weight"
        static let gender = "gender"
    }

    @Published var page: Page = .introduction

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var birthDate: Date = Calendar.current.date(byAdding: .year, value: -40, to: Date()) ?? Date()
    @Published var heightSelections = FormHelpers.defaultHeightComponentValues
    @Published var weightSelections = FormHelpers.defaultWeightComponentValues
    @Published var genderSelections = FormHelpers.defaultGenderComponentValues
}
