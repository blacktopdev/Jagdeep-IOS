//
//  FormLabeledFieldView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/5/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct FormTextFieldView: View {

    let id: String
    let title: LocalizedStringKey
    let prompt: LocalizedStringKey
    var contentType: UITextContentType?
    @Binding var value: String
    @Binding var focusedId: String
    var nextId: String = ""
    var errors: [FieldError] = []

    var onStateChange: ((FormTextField.Change) -> Void)?

    @State private var isEditing: Bool = false

    private var hasError: Bool { errors.first { $0.id == id } != nil }

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Metrics.halfPadding) {
            Text(title)
                .rowTitleFont()
                .foregroundColor(hasError ? .appMagentaDark : .appMonoF8)

            textField
                .calloutFont()
                .clearButton($value, isHidden: !isEditing)
                .placeHolder(Text(prompt).calloutFont(), show: value.isEmpty, hasError: hasError)
                .formTextField(hasError: hasError)
        }
    }

    private var textField: some View {
        FormTextField(id: id, nextId: nextId, focusedId: $focusedId,
                      text: $value, contentType: contentType) { change in
            switch change {
            case .didFocus:
                isEditing = true
            case .didUnfocus:
                isEditing = false
            case .didCommit:
                isEditing = false
            case .didSubmit:
                isEditing = false
            }
            onStateChange?(change)
        }
    }
}

struct FormLabeledFieldView2_Previews: PreviewProvider {
    enum TestError: TitleTextError {
        case someError

        var title: LocalizedStringKey { return "title of it" }
        var text: LocalizedStringKey { return "text of it" }
    }

    static var errors: [FieldError] { [FieldError(id: "two", error: TestError.someError)] }

    static var previews: some View {
        StatefulPreviewWrapper("one") { focusedId in
            VStack(spacing: 26) {
                StatefulPreviewWrapper("") { value in
                    FormTextFieldView(id: "one", title: "Favorite Vegetable",
                                       prompt: "Enter your favorite vegetable",
                                       contentType: .name, value: value,
                                       focusedId: focusedId, nextId: "two", errors: errors)
                }
                StatefulPreviewWrapper("ji@jiropole.net") { value in
                    FormTextFieldView(id: "two", title: "Email Address",
                                       prompt: "Enter your email address",
                                       contentType: .emailAddress, value: value,
                                       focusedId: focusedId, nextId: "three", errors: errors)
                }
                StatefulPreviewWrapper("") { value in
                    FormTextFieldView(id: "three", title: "Password",
                                       prompt: "Enter your password",
                                       contentType: .password,
                                       value: value, focusedId: focusedId, errors: errors)
                }
            }
        }
        .padding()
        .fullscreenTheme()
    }
}
