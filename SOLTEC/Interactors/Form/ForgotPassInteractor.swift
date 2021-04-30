//
//  ForgotPassInteractor.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/19/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI
import Combine

struct ForgotPassInteractor: FormInteractor {
    private enum SubmitError: TitleTextError {
        case invalidEmail

        var title: LocalizedStringKey { "Invalid Email" }
        var text: LocalizedStringKey { "Please enter a valid email address." }
    }

    func validateForm(model: ForgotPassFormModel) -> AnyPublisher<[FieldError], Never> {
        Future<[FieldError], Never> { promise in
            var errors = [FieldError]()
            if !model.email.isValidEmail() {
                errors.append(FieldError(id: ForgotPassFormModel.Field.email, error: SubmitError.invalidEmail))
            }
            promise(.success(errors))
        }
        .eraseToAnyPublisher()
    }

    func commitForm(model: ForgotPassFormModel) -> AnyPublisher<[FieldError], Never> {
        Future<[FieldError], Never> { promise in
            print("would commit reset")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                promise(.success([]))
            }
        }
        .eraseToAnyPublisher()
    }
}
