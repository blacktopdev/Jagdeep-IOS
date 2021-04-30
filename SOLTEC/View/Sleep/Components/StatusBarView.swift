//
//  StatusBarShape.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 11/21/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct StatusBarView: View {
    let color: Color
    let completeness: Float
    var startPoint: UnitPoint = .leading
    var endPoint: UnitPoint = .trailing
    var cornerRadius: CGFloat = Constants.Metrics.cornerRadiusTight

    var gradient: Gradient {
        let u = CGFloat(min(100, max(0, completeness)) / 100)
        return Gradient(stops: [.init(color: color, location: 0),
                                .init(color: color, location: u),
                                .init(color: .appMono62, location: u),
                                .init(color: .appMono62, location: 1)])
    }

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint))
    }
}

struct StatusBarShape_Previews: PreviewProvider {
    static var previews: some View {
        StatusBarView(color: .appBlue, completeness: 75)
            .frame(maxHeight: 30)
            .padding()
            .background(Color.appMono25)
            .previewLayout(.sizeThatFits)

        StatusBarView(color: .appBlue, completeness: 75, startPoint: .bottom, endPoint: .top)
            .frame(width: 30, height: 128)
            .padding()
            .background(Color.appMono25)
            .previewLayout(.sizeThatFits)
    }
}
