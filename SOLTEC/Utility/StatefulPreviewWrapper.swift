//
//  StatefulPreviewWrapper.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 10/19/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct StatefulPreviewWrapper<Value, Content: View>: View {
    
    @State var value: Value
    var content: (Binding<Value>) -> Content

    var body: some View {
        content($value)
    }

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        self._value = State(wrappedValue: value)
        self.content = content
    }
}
