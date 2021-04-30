//
//  FormSectionView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/29/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct FormSectionView<Content: View>: View {
    var image: Image?
    let title: LocalizedStringKey
    let text: LocalizedStringKey
    let centerContent: Bool
    let content: Content

    init(image: Image? = nil, title: LocalizedStringKey, text: LocalizedStringKey,
         centerContent: Bool = true, @ViewBuilder content: () -> Content) {
        self.image = image
        self.title = title
        self.text = text
        self.centerContent = centerContent
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 56) {
            image
            VStack(spacing: centerContent ? 0 : 26) {
                VStack(alignment: .leading, spacing: Constants.Metrics.padding) {
                    Text(title)
                        .formScreenTitle()
                    Text(text)
                        .formScreenText()
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.bottom, centerContent ? 0 : 30)
                .frame(maxWidth: .infinity, alignment: .leading)

                if centerContent { Spacer() }
                content
                if centerContent { Spacer() }
            }
        }
    }
}

struct FormSectionView_Previews: PreviewProvider {
    static var previews: some View {
        FormSectionView(image: Image("device-track-low"),
                        title: "Low Battery Indicator",
                        text: "Make sure the device is charged before going to sleep, otherwise the Z•TRACK won’t be able to track your entire nights sleep.\n\nThe blue light on the device will flash slowly when the battery is low.") {
            Text("Form section content here")
        }
        .fullscreenTheme()
    }
}
