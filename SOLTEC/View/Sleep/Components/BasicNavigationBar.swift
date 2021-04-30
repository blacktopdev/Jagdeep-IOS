//
//  BasicNavigationBar.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/10/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct BasicNavigationBackButtonContent: View {
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: "chevron.left")
                .headlineFont(weight: .medium)
            Text("Back")
        }
        .padding([.leading, .trailing], Constants.Metrics.rowPadding)
        .frame(height: 44)
        .foregroundColor(.blue)
    }
}

struct BasicNavigationBar<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode

    let hasBackButton: Bool
    let content: Content

    init(hasBackButton: Bool, @ViewBuilder content: () -> Content ) {
        self.hasBackButton = hasBackButton
        self.content = content()
    }

    var body: some View {
        HStack {
            if hasBackButton {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    BasicNavigationBackButtonContent()
                }

                Spacer()
            }

            content
//                .padding([.leading, .trailing], Constants.Metrics.rowPadding)
        }
        .frame(minHeight: 44)
    }
}

struct BasicNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            BasicNavigationBar(hasBackButton: true) {
                Text("In the bar")
            }

            BasicNavigationBar(hasBackButton: false) {
                Text("In the bar")
            }
        }
        .fullscreenTheme()
    }
}
