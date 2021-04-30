//
//  OnboardingView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/21/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    enum Page: CaseIterable {
        case tech
        case score
        case results
        case begin

        var color: Color {
            switch self {
            case .tech: return Color.appBlue
            case .score: return Color.appMagenta
            case .results: return Color.appLightOchre
            case .begin: return Color.appGreen
            }
        }
    }

    @State var page: Page

    var body: some View {
//        NavigationView {
            VStack {
                skipBarView

                ZStack(alignment: .bottom) {
                    tabView
                    outerButton
                        .padding([.leading, .trailing], Constants.Metrics.padding)
                }
            }
            .padding(.bottom, Constants.Metrics.padding)
            .fullscreenTheme()
//            .navigationBarTitle("", displayMode: .inline)
//            .navigationBarHidden(true)
//        }

//                .navigationBarTitle("", displayMode: .inline)
//                .navigationBarItems(leading: Button(action: {
//                    withAnimation(.easeInOut) { page = page.previous }
//                }) {
//                    HStack(spacing: 2) {
//                        Image(systemName: "chevron.left")
//                        Text("Back")
//                    }
//                    .foregroundColor(.blue)
//                })
//                .navigationBarHidden(page == .introduction)
//                .fullscreenTheme()

    }

    private var tabView: some View {
        TabView(selection: $page) {
            Group {
                OnboardingPageView(image: Image("symbol-wearable"),
                                 title: "State of the art hardware",
                                 statement: "This is a small, very small blurb about the innovative sleep tracking hardware.")
                    .tag(Page.tech)

                OnboardingPageView(image: Image("symbol-wearable"),
                                 title: "Find your Sleep Score",
                                 statement: "This is a small, very small blurb about the value of understanding your sleep metrics.")
                    .tag(Page.score)

                OnboardingPageView(image: Image("symbol-wearable"),
                                 title: "Feel like a new person",
                                 statement: "This is a small, very small blurb describing how you will feel better.")
                    .tag(Page.results)

                GetStartedView(getStartedAction: {
                    print("get started")
                })
                .tag(Page.begin)
            }
        }
//                .accentColor(currentPage.color)
//                .foregroundColor(currentPage.color)
        .tabViewStyle(PageTabViewStyle())
    }

    private var outerButton: some View {
        HStack {
            if page == .begin {
                NavigationLink(destination: LoginView()) {
                    Text("Login")
                        .standardButton()
                }
            } else {
                Button(action: {
                    withAnimation {
                        page = page.next
                    }
                }) {
                    Text("Next")
                        .standardButton()
                }
            }
        }
        .padding(.top, Constants.Metrics.padding)
        .background(Color.appMono25)
        .padding(.bottom, 66)
    }

    private var skipBarView: some View {
        BasicNavigationBar(hasBackButton: false) {
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        page = .last
                    }
                }) {
                    Text("Skip")
                        .foregroundColor(.blue)
                        .frame(maxHeight: .infinity)
                        .padding([.leading, .trailing], Constants.Metrics.padding)
                }
                .isHidden(page == .begin)
            }
            .frame(height: 44)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(page: .begin)
            .fullscreenTheme()
    }
}
