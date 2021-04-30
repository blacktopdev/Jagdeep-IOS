//
//  FormInfoRow.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/3/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct FormInfoRow<Title: View, Content: View>: View {
    let title: Title
    let content: Content
    var action: (() -> Void)?

    var body: some View {

        VStack(spacing: 0) {
            if let action = action {
                Button(action: {
                    action()
                }) {
                    fieldContent
                }
            } else {
                fieldContent
            }

            ListDividerView()
                .padding([.leading], Constants.Metrics.padding)
        }
        .frame(minHeight: 44)
    }

    private var fieldContent: some View {
        HStack {
            title
                .rowTitleFont(weight: .regular)
            Spacer()

            content
                .rowTitleFont(weight: .regular)
                .foregroundColor(.appMono8E)
        }
        .padding([.top, .bottom], 12)
        .padding([.leading, .trailing], Constants.Metrics.padding)
    }
}
struct FormInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            FormInfoRow(title: Text("Weight"), content: Text("155 lbs"))
            FormInfoRow(title: Text("Delete Account").foregroundColor(.red), content: EmptyView())
        }
        .fullscreenTheme(darkness: .darker)
    }
}
