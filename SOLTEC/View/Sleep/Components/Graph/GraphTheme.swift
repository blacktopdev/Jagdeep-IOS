//
//  Theme.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/17/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

enum GraphFillStyle {
    case none
    case color(Color)
    case linearGradient(LinearGradient)
    case radialGradient(RadialGradient)
    case angularGradient(AngularGradient)
}

extension Shape {
    func applying(fill style: GraphFillStyle) -> some View {
        Group {
            switch style {
            case .none:
                self.fill(Color.clear)
            case .color(let color):
                self.fill(color)
            case .linearGradient(let gradient):
                self.fill(gradient)
            case .radialGradient(let gradient):
                self.fill(gradient)
            case .angularGradient(let gradient):
                self.fill(gradient)
            }
        }
    }
}

extension View {
    func applying(fill style: GraphFillStyle) -> some View {
        Group {
            switch style {
            case .none:
                self.overlay(Color.clear).mask(self)
            case .color(let color):
                self.foregroundColor(color)
            case .linearGradient(let gradient):
                self.overlay(gradient).mask(self)
            case .radialGradient(let gradient):
                self.overlay(gradient).mask(self)
            case .angularGradient(let gradient):
                self.overlay(gradient).mask(self)
            }
        }
    }
}

//struct GraphLayer<Content: View>: View {
//    let content: Content
//
//    init(seriesView: GraphDataSeriesView, @ViewBuilder content: (GraphDataSeriesView) -> Content) {
//        self.content = content(seriesView)
//    }
//
//    var body: some View {
//        content
//    }
//}
