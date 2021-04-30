//
//  DeviceSetupView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/10/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct DeviceSetupView: View {
    enum Page {
        case introduction
        case devices
    }

    @State private var page: Page = .introduction

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                switch page {
                case .introduction:
                    introductionView
                        .transition(.slideAndFade(left: true))
                case .devices:
                    deviceSetupView
                        .transition(.slideAndFade(left: true))
                }
            }
            .navigationBarTitle("Device Setup")
            .navigationBarHidden(page == .introduction)
            .padding(Constants.Metrics.padding)
            .fullscreenTheme()
        }
        .colorScheme(.dark)
    }

    private var introductionView: some View {
        VStack(spacing: 56) {
            Spacer()
            Image("device-setup")
                .offset(x: 22)
            FormSectionView(title: "Let's Setup Your Devices",
                            text: "This is a small message about why it’s exciting to get to set up your newly purchased hardware and how easy it’s going to be to set it up in the following series of screens.",
                            centerContent: false) { }
            Button(action: { withAnimation { page = .devices } }) {
                Text("Let's Go")
                    .formBottomActionButton()
            }
        }
    }

    private var deviceSetupView: some View {
        VStack(spacing: 36) {
            NavigationLink(destination: DeviceTrackSetupView()) {
                DeviceStatusCardView(image: Image("device-track"), title: "Z•TRACK")
            }

            NavigationLink(destination: DeviceGenSetupView()) {
                DeviceStatusCardView(image: Image("device-gen"), title: "Z•GEN")
            }
        }
    }
}

struct DeviceSetupView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceSetupView()
            .previewDevice("iPhone 8")
    }
}
