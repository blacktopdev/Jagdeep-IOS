//
//  WarningCardView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/9/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct WarningCardView: View {
    let title: LocalizedStringKey
    let text: LocalizedStringKey

    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .rowTitleFont()
            Text(text)
                .multilineTextAlignment(.center)
                .calloutFont()
        }
        .frame(maxWidth: .infinity)
        .warningCard()
        .fixedSize(horizontal: false, vertical: true)
        .padding(.bottom, Constants.Metrics.padding)
        .transition(AnyTransition.move(edge: .bottom)
                        .combined(with: .opacity).animation(.easeInOut))
    }
}

struct WarningCardView_Previews: PreviewProvider {
    static var previews: some View {
        WarningCardView(title: "Big Old Heading",
                        text: "Some paragraph text to give you a much better idea of what is happening.")
            .fullscreenTheme()
    }
}
