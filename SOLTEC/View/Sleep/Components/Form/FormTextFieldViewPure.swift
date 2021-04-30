//
//  FormTextFieldViewPure.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/5/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct FormTextFieldViewPure: View {

    let title: LocalizedStringKey
    let prompt: LocalizedStringKey
    @Binding var value: String
    var contentType: UITextContentType?
    var hasError: Bool = false

    /// Called with parameters (isEditing: Bool, didCommit: Bool).
    typealias UpdateCallback = (Bool, Bool) -> Void

    var onUpdate: UpdateCallback?

    @State private var isEditing: Bool = false

    private var keyboardType: UIKeyboardType {
        guard let type = contentType else { return .default }
        switch type {
        case .emailAddress:
            return .emailAddress
        case .URL:
            return .URL
        case .telephoneNumber:
            return .phonePad
        default:
            return .default
        }
    }

    private var capitalizationType: UITextAutocapitalizationType {
        guard let type = contentType else { return .sentences }
        switch type {
        case .emailAddress, .URL, .password, .username:
            return .none
        case .name, .nickname, .organizationName:
            return .words
        default:
            return .sentences
        }
    }

    private var isAutocorrectionDisabled: Bool? {
        guard let type = contentType else { return nil }
        switch type {
        case .emailAddress, .URL, .password, .username:
            return true
        default:
            return nil
        }
    }

    var isErrorActive: Bool { hasError && !isEditing }

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Metrics.halfPadding) {
            Text(title)
                .rowTitleFont()
                .foregroundColor(isErrorActive ? .appMagentaDark : .appMonoF8)

            textField
            .textContentType(contentType)
            .keyboardType(keyboardType)
            .autocapitalization(capitalizationType)
            .disableAutocorrection(isAutocorrectionDisabled)
            .calloutFont()
            .clearButton($value, isHidden: !isEditing)
            .placeHolder(Text(prompt).calloutFont(), show: value.isEmpty, hasError: isErrorActive)
            .formTextField(hasError: isErrorActive)
        }
    }

    private var textField: some View {
        VStack {
            if let type = contentType, type == .password {
                SecureField("", text: $value) {
                    self.isEditing = false
                    self.onUpdate?(false, true)
                }
            } else {
                TextField("", text: $value) { isEditing in
                    self.isEditing = isEditing
                    self.onUpdate?(isEditing, false)
                } onCommit: {
                    self.isEditing = false
                    self.onUpdate?(false, true)
                }
            }
        }
    }
}

struct FormLabeledFieldView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 26) {
            StatefulPreviewWrapper("") { value in
                FormTextFieldViewPure(title: "Favorite Vegetable", prompt: "Enter your favorite vegetable",
                                     value: value, contentType: .name, hasError: false)
            }
            StatefulPreviewWrapper("ji@jiropole.net") { value in
                FormTextFieldViewPure(title: "Email Address", prompt: "Enter your email address",
                                     value: value, contentType: .emailAddress, hasError: false)
            }
            StatefulPreviewWrapper("") { value in
                FormTextFieldViewPure(title: "Password", prompt: "Enter your password",
                                     value: value, contentType: .password, hasError: true)
            }
        }
        .padding()
        .fullscreenTheme()
    }
}
