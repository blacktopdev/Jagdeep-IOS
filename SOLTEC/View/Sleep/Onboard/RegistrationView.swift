//
//  RegistrationView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/31/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject private var coordinator: FormCoordinator<RegistrationFormInteractor>
    @State private var isSlidingLeft: Bool = true

    private let cancelBag = CancelBag()

    init(formModel: RegistrationFormModel? = nil) {
        let model = formModel ?? RegistrationFormModel()
//        model.email = "you@them.tld"
//        model.password = "asdfasdfopuiwer"
        let coordinator = FormCoordinator(model: model, interactor: RegistrationFormInteractor())
        _coordinator = StateObject(wrappedValue: coordinator)

        coordinator.$status.dropFirst().sink { status in
            if status == .validated || status == .success {
                withAnimation(.easeInOut) {
//                    isSlidingLeft = true
                    coordinator.model.page = coordinator.model.page.next
                }
            }
        }
        .store(in: cancelBag)
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation(.easeInOut) {
                        coordinator.status = .idle  // in case it was error
                        isSlidingLeft = false
                        coordinator.model.page = coordinator.model.page.previous
                    }
                }) {
                    BasicNavigationBackButtonContent()
                }
                Spacer()
            }
            .isHidden(coordinator.model.page == .introduction)

            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        switch coordinator.model.page {
                        case .introduction:
                            Spacer()
                            introductionView
                                .transition(.slideAndFade(left: isSlidingLeft))
                                .onAppear { isSlidingLeft = true }
                        case .credentials:
                            credentialView
                                .transition(.slideAndFade(left: isSlidingLeft))
                                .onAppear { isSlidingLeft = true }
                        case .name:
                            nameInformationView
                                .transition(.slideAndFade(left: isSlidingLeft))
                                .onAppear { isSlidingLeft = true }
                        case .birthDate:
                            birthDateView
                                .transition(.slideAndFade(left: isSlidingLeft))
                                .onAppear { isSlidingLeft = true }
                        case .height:
                            heightView
                                .transition(.slideAndFade(left: isSlidingLeft))
                                .onAppear { isSlidingLeft = true }
                        case .weight:
                            weightView
                                .transition(.slideAndFade(left: isSlidingLeft))
                                .onAppear { isSlidingLeft = true }
                        case .gender:
                            genderView
                                .transition(.slideAndFade(left: isSlidingLeft))
                                .onAppear { isSlidingLeft = true }
                        case .complete:
                            completionView
                                .transition(.slideAndFade(left: isSlidingLeft))
                                .onAppear { isSlidingLeft = true }
                        }
                        Spacer()

                        Button(action: {
                            coordinator.submitForm(commit: coordinator.model.page == .gender)
                        }) {
                            ActivityButton(Text(coordinator.model.page == .introduction || coordinator.model.page == .complete ? "Let's Go" : "Next"),
                                           isWorking: coordinator.status == .working)
                                .formBottomActionButton()
                        }
                    }
                    .padding([.top, .leading, .trailing], Constants.Metrics.padding)
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
    }

    private var formErrorView: some View {
        VStack {
            if coordinator.status == .error, let error = coordinator.fieldErrors.first?.error {
                NavigationLink(destination:
                                ForgotPassView(formModel: ForgotPassFormModel(email: coordinator.model.email))) {
                    WarningCardView(title: error.title, text: error.text)
                }
            }
        }
    }

    private var introductionView: some View {
        VStack(spacing: 56) {
            Image("users-silhouette")
            FormSectionView(title: "Let's Setup Your Account",
                                    text: "Before we can set up your new devices we need to have you create an account with us.") { }
        }
    }

    private var completionView: some View {
        VStack(spacing: 56) {
            Image("icon-checkmark-large")
            FormSectionView(title: "Account Created",
                                    text: "You’re all set with creating your account for SolTec and are on your way to getting a better nights rest.") { }
        }
    }

    private var credentialView: some View {
        FormSectionView(title: "Create An Account",
                                text: "This is the information you will use to log in to your SolTec account.",
                                centerContent: false) {
            formErrorView
            FormTextFieldView(id: RegistrationFormModel.Field.email,
                              title: "Email Address",
                              prompt: "Enter your email address",
                              contentType: .emailAddress, value: $coordinator.model.email,
                              focusedId: $coordinator.focusedId,
                              nextId: RegistrationFormModel.Field.password,
                              errors: coordinator.fieldErrors,
                              onStateChange: coordinator.handleFieldChange)
            FormTextFieldView(id: RegistrationFormModel.Field.password,
                              title: "Password",
                              prompt: "Enter a password",
                              contentType: .password, value: $coordinator.model.password,
                              focusedId: $coordinator.focusedId,
                              errors: coordinator.fieldErrors,
                              onStateChange: coordinator.handleFieldChange)
        }
    }

    private var nameInformationView: some View {
        FormSectionView(title: "Personal Information",
                                text: "Help us identify your profile by giving us your name for a more personalized feel.",
                                centerContent: false) {
            formErrorView
            FormTextFieldView(id: RegistrationFormModel.Field.firstName,
                              title: "First Name",
                              prompt: "Enter your first name",
                              contentType: .name, value: $coordinator.model.firstName,
                              focusedId: $coordinator.focusedId,
                              nextId: RegistrationFormModel.Field.lastName,
                              errors: coordinator.fieldErrors,
                              onStateChange: coordinator.handleFieldChange)
            FormTextFieldView(id: RegistrationFormModel.Field.lastName,
                              title: "Last Name",
                              prompt: "Enter your last name",
                              contentType: .familyName, value: $coordinator.model.lastName,
                              focusedId: $coordinator.focusedId,
                              errors: coordinator.fieldErrors,
                              onStateChange: coordinator.handleFieldChange)
        }
    }

    private var birthDateView: some View {
        FormSectionView(title: "Date of Birth",
                                text: "This will help us improve our accuracy to provide you with better sleep data.") {
            formErrorView
            DatePicker("", selection: $coordinator.model.birthDate, displayedComponents: [.date])
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .colorScheme(.dark)
        }
    }

    private var heightView: some View {
        FormSectionView(title: "Height",
                                text: "This will help us improve our accuracy to provide you with better sleep data.") {
            ClassicPickerView(data: FormHelpers.heightComponents,
                              selections: $coordinator.model.heightSelections, isDarkStyle: true)
                .colorScheme(.dark)
        }
    }

    private var weightView: some View {
        FormSectionView(title: "Weight",
                                text: "This will help us improve our accuracy to provide you with better sleep data.") {
            ClassicPickerView(data: FormHelpers.weightComponents,
                              selections: $coordinator.model.weightSelections, isDarkStyle: true)
                .colorScheme(.dark)
        }
    }

    private var genderView: some View {
        FormSectionView(title: "Gender",
                                text: "This will help us improve our accuracy to provide you with better sleep data.") {
            ClassicPickerView(data: FormHelpers.genderComponents,
                              selections: $coordinator.model.genderSelections, isDarkStyle: true)
                .colorScheme(.dark)
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
            .fullscreenTheme()
    }
}
