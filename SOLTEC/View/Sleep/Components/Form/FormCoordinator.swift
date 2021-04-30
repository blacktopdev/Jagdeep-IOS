//
//  FormCoordinator.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/10/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI
import Combine

protocol FormInteractor {
    associatedtype Model: ObservableObject

    func validateForm(model: Model) -> AnyPublisher<[FieldError], Never>
    func commitForm(model: Model) -> AnyPublisher<[FieldError], Never>
}

final class FormCoordinator<Interactor: FormInteractor>: ObservableObject {
    @Published var focusedId: String = ""
    @Published var fieldErrors: [FieldError] = []
    @Published var status: FormSubmitStatus = .idle

    @Published var model: Interactor.Model
    let interactor: Interactor

    private var cancellable: AnyCancellable?

    init(model: Interactor.Model, interactor: Interactor) {
        self.model = model
        self.interactor = interactor
        cancellable = model.objectWillChange.sink { [weak self] _ in self?.objectWillChange.send() }
    }

    func handleFieldChange(_ change: FormTextField.Change) {
        switch change {
        case .didFocus:
            update(errors: [], status: .idle)
        case .didSubmit:
            submitForm()
        default:
            break
        }
    }

    private func update(errors: [FieldError]?, status: FormSubmitStatus?) {
        withAnimation(.easeInOut) {
            if let errors = errors {
                self.fieldErrors = errors
            }
            if let status = status {
                self.status = status
            }
        }
    }

    func submitForm(commit: Bool = true) {
//        update(errors: fieldErrors, status: .validating)

        interactor.validateForm(model: model)
            .subscribe(Subscribers.Sink(receiveCompletion: { _ in }, receiveValue: { [weak self] errors in
                guard let self = self else { return }

                self.update(errors: errors, status: errors.isEmpty ? (commit ? .working : .validated) : .error)
                guard errors.isEmpty, commit else { return }

                self.interactor.commitForm(model: self.model)
                    .subscribe(Subscribers.Sink(receiveCompletion: { _ in }, receiveValue: { [weak self] errors in
                        guard let self = self else { return }
                        self.update(errors: errors, status: errors.isEmpty ? .success : .error)
                    }))
            }))
    }
}
