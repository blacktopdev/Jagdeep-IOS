//
//  ForgotPassModel.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/22/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

class ForgotPassFormModel: ObservableObject {
    struct Field {
        static let email = "email"
    }

    @Published var email: String

    init(email: String = "") {
        self.email = email
    }
}
