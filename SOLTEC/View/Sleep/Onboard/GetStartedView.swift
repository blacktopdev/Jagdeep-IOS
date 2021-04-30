//
//  GetStartedView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/27/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct GetStartedView: View {
    var getStartedAction: (() -> Void)?

    var body: some View {
        VStack {
            Spacer()
            Image("logo-soltec-health")
            Spacer()

            NavigationLink(destination: RegistrationView()) {
                Text("Get Started")
                    .highlightButton()
            }
            .padding([.leading, .trailing], Constants.Metrics.padding)
        }
        .padding(.bottom, 137)
    }
}

struct GetStartedView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedView()
            .fullscreenTheme()
    }
}
