//
//  TutorialView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/21/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    enum Page: Int {
        case tech
        case score
        case results
        case begin

        var next: Page {
            switch self {
            case .tech: return .score
            case .score: return .results
            case .results: return .begin
            case .begin: return .begin
            }
        }

        static var last: Page {
            return .begin
        }

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
        VStack {
            skipBarView

            ZStack(alignment: .bottom) {
                TabView(selection: $page) {
                    Group {
                        TutorialPageView(image: Image("symbol-wearable"),
                                         title: "State of the art hardware",
                                         statement: "This is a small, very small blurb about the innovative sleep tracking hardware.")
                            .tag(Page.tech)

                        TutorialPageView(image: Image("symbol-wearable"),
                                         title: "Find your Sleep Score",
                                         statement: "This is a small, very small blurb about the value of understanding your sleep metrics.")
                            .tag(Page.score)

                        TutorialPageView(image: Image("symbol-wearable"),
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

                outerButton
                    .padding([.leading, .trailing], Constants.Metrics.padding)
                    .offset(x: 0, y: -66)
            }
        }
        .padding(.bottom, Constants.Metrics.padding)
        .fullscreenTheme()
        .navigationBarTitle("Welcome")
    }

    private var outerButton: some View {
        HStack {
            if page == .begin {
                NavigationLink(destination: LoginView(email: "", password: "")) {
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
    }

    private var skipBarView: some View {
        HStack {
            Spacer()
            Button(action: {
                withAnimation {
                    page = .last
                }
            }) {
                Text("Skip")
                    .frame(maxHeight: .infinity)
                    .padding([.leading, .trailing], Constants.Metrics.padding)
                    .foregroundColor(.blue)
            }
            .isHidden(page == .begin)
        }
        .frame(height: 44)
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(page: .tech)
            .fullscreenTheme()
    }
}
