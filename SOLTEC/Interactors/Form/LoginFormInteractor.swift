//
//  LoginFormInteractor.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/19/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI
import Combine

struct LoginFormInteractor: FormInteractor {
    private enum SubmitError: TitleTextError {
        case invalidEmail
        case invalidPassword
        case invalidCredentials

        var title: LocalizedStringKey {
            switch self {
            case .invalidEmail:
                return "Invalid Email"
            case .invalidPassword:
                return "Invalid Password"
            case .invalidCredentials:
                return "Wrong Email / Password"
            }
        }

        var text: LocalizedStringKey {
            switch self {
            case .invalidEmail:
                return "Please enter a valid email address."
            case .invalidPassword:
                return "Please enter your secure password."
            case .invalidCredentials:
                return "Please try logging in again, or tap this message to reset your password."
            }
        }
    }

    func validateForm(model: LoginFormModel) -> AnyPublisher<[FieldError], Never> {
        Future<[FieldError], Never> { promise in
            var errors = [FieldError]()
            if !model.email.isValidEmail() {
                errors.append(FieldError(id: LoginFormModel.Field.email, error: SubmitError.invalidEmail))
            }
            if !model.password.isValidPassword() {
                errors.append(FieldError(id: LoginFormModel.Field.password, error: SubmitError.invalidPassword))
            }
            promise(.success(errors))
        }
        .eraseToAnyPublisher()
    }

    func commitForm(model: LoginFormModel) -> AnyPublisher<[FieldError], Never> {
        Future<[FieldError], Never> { promise in
            print("would commit login")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                promise(.success([]))
            }
        }
        .eraseToAnyPublisher()
    }
}
