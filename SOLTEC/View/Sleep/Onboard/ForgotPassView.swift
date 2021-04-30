//
//  ForgotPassView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/30/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI
import Combine

struct ForgotPassView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject private var coordinator: FormCoordinator<ForgotPassInteractor>

    init(formModel: ForgotPassFormModel? = nil) {
        let model = formModel ?? ForgotPassFormModel()
        let coordinator = FormCoordinator(model: model, interactor: ForgotPassInteractor())

        _coordinator = StateObject(wrappedValue: coordinator)
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Image("logo-soltec-health")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 104)
                        .padding(.bottom, 56)

                    if coordinator.status != .success {
                        resetPasswordContent
                            .transition(.slideAndFade())
                    } else {
                        resetSuccessContent
                            .transition(.slideAndFade())
                    }

                    Spacer()

                    Button {
                        if coordinator.status == .success {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            coordinator.submitForm()
                        }
                    } label: {
                        ActivityButton(Text(coordinator.status == .success ? "Done" : "Reset Password"),
                                       isWorking: coordinator.status == .working)
                        .formBottomActionButton()
                    }
                    .disabled(coordinator.status == .working)
                }
                .padding(Constants.Metrics.padding)
                .frame(minHeight: geometry.size.height)
            }
        }
    }

    private var resetPasswordContent: some View {
        VStack(spacing: 56) {
            if coordinator.status != .error {
                VStack(alignment: .leading, spacing: Constants.Metrics.padding) {
                    Text("Reset Password")
                        .formScreenTitle()
                    Text("Enter the email you used to sign up for your account and we’ll send you a link to create a new password to log in with.")
                        .formScreenText(weight: .semibold)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            if coordinator.status == .error, let error = coordinator.fieldErrors.first?.error {
                WarningCardView(title: error.title, text: error.text)
            }

            FormTextFieldView(id: ForgotPassFormModel.Field.email,
                              title: "Email Address",
                              prompt: "Enter your email address",
                              contentType: .emailAddress, value: $coordinator.model.email,
                              focusedId: $coordinator.focusedId,
                              errors: coordinator.fieldErrors,
                              onStateChange: coordinator.handleFieldChange)
        }
    }

    private var resetSuccessContent: some View {
        VStack(spacing: 56) {
            VStack(alignment: .leading, spacing: Constants.Metrics.padding) {
                Text("Email Instructions Sent")
                    .formScreenTitle()
                Text("We’ve sent an email to the address provided. Check your spam filter to ensure you received it. Follow the instructions inside and you’ll be back in no time.")
                    .formScreenText(weight: .semibold)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.bottom, 56)
    }
}

struct ForgotPassView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPassView()
            .fullscreenTheme()
    }
}
