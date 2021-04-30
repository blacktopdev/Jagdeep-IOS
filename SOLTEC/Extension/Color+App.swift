//
//  UIColor+App.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 11/13/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

extension Color {

    // MARK: - Grayscale

    static var appMono10 = Color("SOLTEC_Mono01-10")
    static var appMono19 = Color("SOLTEC_Mono02-19")

    static var appMono25 = Color("SOLTEC_Mono03-25")
    static var appMono2C = Color("SOLTEC_Mono04-2C")
    static var appMono62 = Color("SOLTEC_Mono05-62")
    static var appMono8E = Color("SOLTEC_Mono06-8E")
    static var appMonoA3 = Color("SOLTEC_Mono07-A3")
    static var appMonoC8 = Color("SOLTEC_Mono08-C8")

    static var appMonoD8 = Color("SOLTEC_Mono09-D8")
    static var appMonoF8 = Color("SOLTEC_Mono10-F8")

    // MARK: - Accent Colors

    static var appBlue = Color("SOLTEC_Acc_Blue")
    static var appLightBlue = Color("SOLTEC_Acc_Lt_Blue")
    static var appGreen = Color("SOLTEC_Acc_Green")
    static var appMagenta = Color("SOLTEC_Acc_Magenta")
    static var appMagentaDark = Color("SOLTEC_Acc_Magenta_Dk")
    static var appOchre = Color("SOLTEC_Acc_Ochre")
    static var appLightOchre = Color("SOLTEC_Acc_Lt_Ochre")
    static var appLavender = Color("SOLTEC_Acc_Lavender")
    static var appLavenderDark = Color("SOLTEC_Acc_Lavender_Dk")

    static var morningGradient = Gradient(stops: [.init(color: Color(UIColor(hexValue: 0xEEA275)), location: 0),
                                                  .init(color: Color(UIColor(hexValue: 0xD1596D)), location: 1)])

    static var eveningGradient = Gradient(stops: [.init(color: Color(UIColor(hexValue: 0x4893B4)), location: 0),
                                                  .init(color: Color(UIColor(hexValue: 0x6B6294)), location: 1)])

    static let scoreBandColorsAlt: [Color] = [.appMagenta, .appOchre, .appGreen]
    static let scoreBandColors: [Color] = [.appMagenta, .appOchre, .appBlue, .appGreen, .appLavender]

    /// Retrieve banded color corresponding to the given score, in the range [0, 100]
    static func color(forScore score: Float) -> Color {
        let band = max(0,
                       min(Float(scoreBandColors.count - 1),
                           floor(score / 100 * Float(scoreBandColors.count))))
        return scoreBandColors[Int(band)]
    }

    static func score(forIndex index: Float, range: Range<Float>) -> Float {
        return (index - range.lowerBound) / (range.upperBound - range.lowerBound) * 100
    }

    static func color(forIndex index: Float, range: Range<Float>, isReversed: Bool = false) -> Color {
        let rawScore = score(forIndex: index, range: range)
        return color(forScore: isReversed ? 100 - rawScore : rawScore)
    }
}
