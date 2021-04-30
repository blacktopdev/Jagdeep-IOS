//
//  OnboardingPageView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/21/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct OnboardingPageView: View {
    let image: Image
    let title: String
    let statement: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            image
                .frame(maxWidth: .infinity, maxHeight: 232)
                .background(Color.appMonoD8)
                .cornerRadius(Constants.Metrics.cornerRadiusTight)
                .padding(.bottom, 8)
            Text(title)
                .standardFont(size: 24, weight: .bold)
            Text(statement)
                .standardFont(size: 17, weight: .regular)

            Spacer()
        }
        .padding([.leading, .trailing], Constants.Metrics.padding)
    }
}

struct TutorialPageView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageView(image: Image("logo-soltec-health"),
                         title: "Feel like a new person",
                         statement: "This is a small, very small blurb about how much better you will feel.")
            .fullscreenTheme()
    }
}
