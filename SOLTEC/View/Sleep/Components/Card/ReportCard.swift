//
//  ReportCardView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 11/30/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct ReportCard<T: View>: View {

    let headerView: T
    let gradient: Gradient

    let title: LocalizedStringKey
    let text: LocalizedStringKey

    var body: some View {
        VStack {
            headerView
                .southEast(gradient: gradient)
                .frame(height: 61)
                .clipped()
            
            VStack(alignment: .leading) {
                Text(title).subHeadlineFont()

                Text(text).conciseBodyFont()
                    .padding(.top, 1)
            }
            .padding(EdgeInsets(top: Constants.Metrics.lightPadding,
                                leading: Constants.Metrics.padding,
                                bottom: 60,
                                trailing: Constants.Metrics.padding))
        }
        .foregroundColor(.appMonoF8)
    }
}

struct ReportCardView_Previews: PreviewProvider {
    static var previews: some View {
        return ReportCard(headerView: EmptyView(),
                              gradient: Color.eveningGradient,
                              title: "Description of the Graph",
                              text: "A longer description about the meaning of the graph.")
            .background(Color.appMono25)
            .previewLayout(.sizeThatFits)
    }
}
