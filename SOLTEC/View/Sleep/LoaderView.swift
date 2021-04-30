//
//  LoaderView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/21/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct LoaderView: View {
    enum Paradigm {
        case launching
        case firstTime
        case notAuthenticated
        case authenticated
        case expert
    }

    @State var paradigm = Paradigm.firstTime

    var body: some View {
//        MacawSVGView(filename: "atom")
//        MacawSVGView(filename: "SOLTEC-logo-animated")

//        VStack {
//            WebView(svgName: "SOLTEC-logo-animated.svg")
//                .frame(height: 240)
//        }

        AppView()
            .fullscreenTheme()
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
    }
}
