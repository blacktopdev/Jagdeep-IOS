//
//  FormModels.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/10/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

protocol TitleTextError: Error {
    var title: LocalizedStringKey { get }
    var text: LocalizedStringKey { get }
}

struct FieldError: Identifiable {
    var id: String
    var error: TitleTextError
}

// not presently in use; meant if migrating to none-None error publisher
//struct FormError: Error {
//    enum Phase {
//        case validation
//        case commit
//    }
//
//    let phase: Phase
//    let errors: [FieldError]
//}

enum FormSubmitStatus {
    case idle
//    case validating
    case validated
    case working
    case success
    case error
}
