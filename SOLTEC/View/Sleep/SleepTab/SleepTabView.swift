//
//  ContentView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 11/13/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct SleepTabView: View {
    var body: some View {
        NavigationView {
            DashboardView()
                .navigationBarHidden(true)
        }
        .colorScheme(.dark) // just to make collapsed navbar have dark blur effect
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SleepTabView()
    }
}
