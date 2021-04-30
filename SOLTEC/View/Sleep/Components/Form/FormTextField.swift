//
//  FormTextField.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/9/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct FormTextField: UIViewRepresentable {
    enum Change {
        case didFocus
        case didUnfocus
        case didCommit
        case didSubmit
    }

    let id: String
    let nextId: String
    @Binding var focusedId: String
    @Binding var text: String
    var textColor: Color?
    var contentType: UITextContentType?
    var font: UIFont?

    var onStateChange: ((Change) -> Void)?

    func makeUIView(context: UIViewRepresentableContext<FormTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.keyboardType = keyboardType
        textField.returnKeyType = nextId.isEmpty ? .done : .next
        textField.autocapitalizationType = capitalizationType
        textField.autocorrectionType = autocorrectionType
        textField.isSecureTextEntry = contentType == .password

        // Would be better to get these from swiftUI, not possible at this time
        textField.textColor = UIColor(textColor ?? .appMono25)
        textField.font = font ?? UIFont.systemFont(ofSize: 16)

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<FormTextField>) {
        uiView.text = text

        if self.id == self.focusedId {
            uiView.becomeFirstResponder()
        }
    }

    func makeCoordinator() -> FormTextField.Coordinator {
        return Coordinator(parent: self, text: $text)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        private let parent: FormTextField
        @Binding private var text: String

        init(parent: FormTextField, text: Binding<String>) {
            self.parent = parent
            self._text = text
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.text = textField.text ?? ""
            }
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            self.parent.focusedId = self.parent.id
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.parent.onStateChange?(.didFocus)
            }
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            self.parent.focusedId = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.parent.onStateChange?(.didUnfocus)
            }
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.parent.focusedId = self.parent.nextId

            if isFinalField {
                textField.resignFirstResponder()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.parent.onStateChange?(.didCommit)
                if self.isFinalField {
                    self.parent.onStateChange?(.didSubmit)
                }
            }
            return false
        }

        var isFinalField: Bool { parent.nextId.isEmpty }
    }
}

extension FormTextField {
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

    private var autocorrectionType: UITextAutocorrectionType {
        guard let type = contentType else { return .default }
        switch type {
        case .emailAddress, .URL, .password, .username:
            return .no
        default:
            return .default
        }
    }
}

//struct FormTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        FormTextField()
//    }
//}
