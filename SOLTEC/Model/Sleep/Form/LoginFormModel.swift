//
//  LoginFormModel.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/22/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

class LoginFormModel: ObservableObject {
    struct Field {
        static let email = "email"
        static let password = "password"
    }

    @Published var email: String
    @Published var password: String

    init(email: String = "", password: String = "") {
        self.email = email
        self.password = password
    }
}
