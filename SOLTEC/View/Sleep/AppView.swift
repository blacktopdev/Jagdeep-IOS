//
//  AppView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 11/13/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct AppView: View {

//    @Environment(\.injected) private var injected: AppInjection
    @EnvironmentObject private var appState: AppState

//    @State var selectedTab: Tab = .preview

    enum Tab {
        case sleep
        case settings
        case preview
    }

    init() {
        UITabBar.appearance().barTintColor = .black
        UITabBar.appearance().unselectedItemTintColor =  UIColor(Color.appMono8E)

        UINavigationBar.appearance().backgroundColor = UIColor(Color.appMono19)
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.appMonoF8)]

        UITableView.appearance().backgroundColor = .clear
    }

    var body: some View {
        TabView(selection: $appState.routing.appView.selectedTab) {
            SleepTabView()
                .tabItem {
                    Image("icon-tab-sleep")
                    Text("Sleep")
                }
                .tag(Tab.sleep)
            SettingsTabView()
                .tabItem {
                    Image("icon-tab-settings")
                    Text("Settings")
                }
                .tag(Tab.settings)
            PreviewTronicView()
                .tabItem {
                    Image(systemName: "list.bullet.below.rectangle")
                    Text("Previews")
                }
                .tag(Tab.preview)
        }
    }
}

extension AppView {
    struct Routing: Hashable {
        var selectedTab: Tab = .sleep
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
