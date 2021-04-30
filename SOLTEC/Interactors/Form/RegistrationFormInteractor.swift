//
//  RegistrationFormInteractor.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/21/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI
import Combine

struct RegistrationFormInteractor: FormInteractor {
    static let minimumAge = 13

    private enum SubmitError: TitleTextError {
        case invalidEmail
        case invalidPassword
        case duplicateUser
        case invalidName
        case invalidBirthdate

        var title: LocalizedStringKey {
            switch self {
            case .invalidEmail:
                return "Invalid Email"
            case .invalidPassword:
                return "Weak Password"
            case .duplicateUser:
                return "Account Already Exists"
            case .invalidName:
                return "Too Short"
            case .invalidBirthdate:
                return "Too Young"
            }
        }

        var text: LocalizedStringKey {
            switch self {
            case .invalidEmail:
                return "Please enter a valid email address."
            case .invalidPassword:
                return "Secure your account with a strong password. Try a unique phrase, or mix in upper & lower case letters, numbers, or special characters\n(!@#$%^&*)."
            case .duplicateUser:
                return "You’ve created an account previously. Please try to log in or reset your password."
            case .invalidName:
                return "Please enter a longer name."
            case .invalidBirthdate:
                return "You must be of at least 13 years of age."
            }
        }
    }

    func validateForm(model: RegistrationFormModel) -> AnyPublisher<[FieldError], Never> {
        switch model.page {
        case .credentials:
            return validateCredentials(model: model)
        case .name:
            return validateName(model: model)
        case .birthDate:
            return validateBirthdate(model: model)
        default:
            return Future<[FieldError], Never> { promise in promise(.success([])) }
                .eraseToAnyPublisher()
        }
    }

    func commitForm(model: RegistrationFormModel) -> AnyPublisher<[FieldError], Never> {
        Future<[FieldError], Never> { promise in
            guard model.page == .gender else {
                promise(.success([]))
                return
            }
            print("would commit signup")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                promise(.success([]))
            }
        }
        .eraseToAnyPublisher()
    }
}

extension RegistrationFormInteractor {
    private func validateCredentials(model: RegistrationFormModel) -> AnyPublisher<[FieldError], Never> {
        Future<[FieldError], Never> { promise in
            var errors = [FieldError]()
            if !model.email.isValidEmail() {
                errors.append(FieldError(id: RegistrationFormModel.Field.email, error: SubmitError.invalidEmail))
            }
            if !model.password.isValidPassword() {
                errors.append(FieldError(id: RegistrationFormModel.Field.password, error: SubmitError.invalidPassword))
            }
            promise(.success(errors))
        }
        .eraseToAnyPublisher()
    }

    private func validateName(model: RegistrationFormModel) -> AnyPublisher<[FieldError], Never> {
        Future<[FieldError], Never> { promise in
            var errors = [FieldError]()
            if model.firstName.count < 2 {
                errors.append(FieldError(id: RegistrationFormModel.Field.firstName, error: SubmitError.invalidName))
            }
            if model.lastName.count < 2 {
                errors.append(FieldError(id: RegistrationFormModel.Field.lastName, error: SubmitError.invalidName))
            }
            promise(.success(errors))
        }
        .eraseToAnyPublisher()
    }

    private func validateBirthdate(model: RegistrationFormModel) -> AnyPublisher<[FieldError], Never> {
        Future<[FieldError], Never> { promise in
            var errors = [FieldError]()
            if model.birthDate.isValidBirthdate(minAge: RegistrationFormInteractor.minimumAge) {
                errors.append(FieldError(id: RegistrationFormModel.Field.birthDate, error: SubmitError.invalidBirthdate))
            }
            promise(.success(errors))
        }
        .eraseToAnyPublisher()
    }
}
