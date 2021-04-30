//
//  SettingsTabView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 11/13/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct SettingsTabView: View {
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        UserRowView(name: "Dan Cohen", date: Date())
                            .padding(.top, 20)

                        VStack(spacing: Constants.Metrics.padding) {
                            NavigationLink(destination: TrackerInformationView()) {
                                DeviceStatusCardView(image: Image("device-track"),
                                                     title: "Z•TRACK", status: .connected)
                            }
                            NavigationLink(destination: GenInformationView()) {
                                DeviceStatusCardView(image: Image("device-gen"),
                                                     title: "Z•GEN", status: .notConfigured)
                            }
                        }
                        .padding(EdgeInsets(top: 36, leading: 16, bottom: 36, trailing: 16))

                        NavigationLink(destination: ProfileInformationView()) {
                            LinkRowView(title: "Profile Information")
                        }
                        LinkRowView(title: "Terms of Service")
                        LinkRowView(title: "Privacy Policy")
                    }
                    .padding(.bottom, Constants.Metrics.padding)
                    .frame(minHeight: geometry.size.height)
    //                .background(Color.blue)
                    .fullscreenTheme()

                }
            }
            .fullscreenTheme(darkness: .darker)
//            .navigationBarHidden(true)
            .navigationBarTitle("Settings")
        }
        .colorScheme(.dark)
    }

//    private var trackerDestination: some View {
//        // this can switch which destination is in use, based on whether device needs to be set up
//    }
}

private struct UserRowView: View {
    let name: String
    let date: Date

    var joinDateString: String {
        Constants.DateFormatters.longDate.string(from: date)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    Text(name)
                        .headlineFont(weight: .regular)

                    Text("Joined \(joinDateString)")
                        .standardFont(size: 13, weight: .regular)
                        .foregroundColor(.appMono8E)
                }
                Spacer()
            }
            .padding([.top, .bottom], Constants.Metrics.padding)
            .padding([.leading, .trailing], Constants.Metrics.padding)

            ListDividerView()
                .padding([.leading], Constants.Metrics.padding)
        }
        .background(Color.appMono19)
    }
}

private struct LinkRowView: View {
    let title: LocalizedStringKey

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .standardFont(size: 17, weight: .regular)

                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.appMono62)
            }
            .padding([.top, .bottom], 11.5)
            .padding([.leading, .trailing], Constants.Metrics.padding)

            ListDividerView()
                .padding([.leading], Constants.Metrics.padding)
        }
        .background(Color.appMono19)
    }
}

struct SettingsTabView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTabView()
            .previewDevice("iPhone 11 Plus")
    }
}
