//
//  LoginView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/30/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI
import Combine

struct LoginView: View {
    @StateObject private var coordinator: FormCoordinator<LoginFormInteractor>

    init(formModel: LoginFormModel? = nil) {
        let model = formModel ?? LoginFormModel()
        let coordinator = FormCoordinator(model: model, interactor: LoginFormInteractor())

        _coordinator = StateObject(wrappedValue: coordinator)
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer()
                    headerView
                    Spacer()
                    
                    VStack(spacing: Constants.Metrics.heavyPadding) {
                        FormTextFieldView(id: LoginFormModel.Field.email,
                                          title: "Email Address",
                                          prompt: "Enter your email address",
                                          contentType: .emailAddress, value: $coordinator.model.email,
                                          focusedId: $coordinator.focusedId,
                                          nextId: LoginFormModel.Field.password,
                                          errors: coordinator.fieldErrors,
                                          onStateChange: coordinator.handleFieldChange)
                        FormTextFieldView(id: LoginFormModel.Field.password,
                                          title: "Password",
                                          prompt: "Enter your password",
                                          contentType: .password, value: $coordinator.model.password,
                                          focusedId: $coordinator.focusedId,
                                          errors: coordinator.fieldErrors,
                                          onStateChange: coordinator.handleFieldChange)
                    }
                    
                    Spacer()

                    Button { coordinator.submitForm() } label: {
                        ActivityButton(Text("Login"),
                                       isWorking: coordinator.status == .working)
                            .formBottomActionButton()
                    }
                    .disabled(coordinator.status == .working)
                }
                .padding([.leading, .trailing], Constants.Metrics.padding)
                .frame(minHeight: geometry.size.height)
            }
        }
        .onAppear {
            coordinator.status = .idle  // clear any error
        }
    }

    private var headerView: some View {
        VStack(spacing: 24) {
            Image("logo-soltec-health")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: coordinator.status == .error ? 104 : 175)
                .padding(.bottom, 24)

            if coordinator.status == .error, let error = coordinator.fieldErrors.first?.error {
                NavigationLink(destination:
                                ForgotPassView(formModel: ForgotPassFormModel(email: coordinator.model.email))) {
                    WarningCardView(title: error.title, text: error.text)
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .fullscreenTheme()
    }
}
