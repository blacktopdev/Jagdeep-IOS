//
//  LabTheme.swift
//  SOLTEC•Lab
//
//  Created by Jiropole on 11/23/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

extension View {

    func labTheme() -> some View {
        modifier(LabTheme())
    }
}

private struct LabTheme: ViewModifier {

    func body(content: Content) -> some View {
        ZStack {
            Color.appMono25.edgesIgnoringSafeArea(.all)
            content
//                .padding([.leading, .trailing], Constants.Metrics.padding)
                .padding(0)
        }
        .foregroundColor(Color.appMonoF8)
        .background(Color.appMono25)
    }
}
