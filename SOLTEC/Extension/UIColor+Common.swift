//
//  UIColor+Common.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 10/19/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import UIKit

extension UIColor {

    public convenience init(hexValue: UInt, alpha: CGFloat = 1.0) {
        let (red, green, blue) = UIColor.rgbFrom(hexValue: hexValue)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    public convenience init(mixingHexColor hex1: UInt, intoHexColor hex2: UInt,
                            atAlpha alpha: CGFloat, finalAlpha: CGFloat = 1.0) {
        let (r1, g1, b1) = UIColor.rgbFrom(hexValue: hex1)
        let (r2, g2, b2) = UIColor.rgbFrom(hexValue: hex2)

        let invertAlpha = 1 - alpha
        let red = r2 * invertAlpha + r1 * alpha
        let green = g2 * invertAlpha + g1 * alpha
        let blue = b2 * invertAlpha + b1 * alpha
        self.init(red: red, green: green, blue: blue, alpha: finalAlpha)
    }

    public convenience init(mixingColor color1: UIColor, intoColor color2: UIColor,
                            atAlpha alpha: CGFloat, finalAlpha: CGFloat = 1.0) {
        let (r1, g1, b1) = UIColor.rgbFrom(color: color1)
        let (r2, g2, b2) = UIColor.rgbFrom(color: color2)

        let invertAlpha = 1 - alpha
        let red = r2 * invertAlpha + r1 * alpha
        let green = g2 * invertAlpha + g1 * alpha
        let blue = b2 * invertAlpha + b1 * alpha
        self.init(red: red, green: green, blue: blue, alpha: finalAlpha)
    }

    public class func rgbFrom(hexValue: UInt) -> (CGFloat, CGFloat, CGFloat) {
        let red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hexValue & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(hexValue & 0xFF) / 255.0
        return (red, green, blue)
    }

    public class func rgbFrom(color: UIColor) -> (CGFloat, CGFloat, CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0

        if color.getRed(&red, green: &green, blue: &blue, alpha: nil) {
            return (red, green, blue)
        }

        return (0, 0, 0)
    }

    #if APP_LAB
    var hexColor: UInt32 {
        self.colorARGBCode()
    }
    #endif
}
