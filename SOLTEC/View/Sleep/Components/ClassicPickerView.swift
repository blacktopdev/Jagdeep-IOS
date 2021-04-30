//
//  ClassicPickerView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/31/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct ClassicPickerView: UIViewRepresentable {
    struct Item: Equatable {
        static func == (lhs: ClassicPickerView.Item, rhs: ClassicPickerView.Item) -> Bool {
            return lhs.text == rhs.text
        }

        let text: String
        let value: Any
    }

    let data: [[ClassicPickerView.Item]]
    @Binding var selections: [Item]

    var isDarkStyle: Bool = false

    func makeCoordinator() -> ClassicPickerView.Coordinator {
        Coordinator(self, isDarkStyle: isDarkStyle)
    }

    func makeUIView(context: UIViewRepresentableContext<ClassicPickerView>) -> UIPickerView {
        let picker = UIPickerView(frame: .zero)

        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator

        return picker
    }

    func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<ClassicPickerView>) {
        for i in 0..<(self.selections.count) {
            if let row = data[i].firstIndex(where: { $0 == selections[i] }) {
                view.selectRow(row, inComponent: i, animated: false)
            }
        }
    }

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: ClassicPickerView
        let isDarkStyle: Bool

        init(_ pickerView: ClassicPickerView, isDarkStyle: Bool = false) {
            self.parent = pickerView
            self.isDarkStyle = isDarkStyle
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return self.parent.data.count
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.parent.data[component].count
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return self.parent.data[component][row].text
        }

        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return 100
        }

        func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int,
                        forComponent component: Int) -> NSAttributedString? {

            let color: UIColor = isDarkStyle ? UIColor(Color.appMonoF8) : UIColor(Color.appMono10)
            let attributes = [NSAttributedString.Key.foregroundColor: color]

            return NSAttributedString(string: self.parent.data[component][row].text,
                                      attributes: attributes)
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.selections[component] = self.parent.data[component][row]
        }
    }
}
