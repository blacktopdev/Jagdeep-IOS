//
//  SleepSignalType+Color.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/24/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import UIKit

extension SleepSignalType {
    var color: UIColor {
        switch self {
        case .veryLowPower:
            return UIColor(hexValue: 0xBF9000)
        case .lowPower:
            return UIColor(hexValue: 0xC55A11)
        case .highPower:
            return UIColor(hexValue: 0x00B050)
        case .veryLowPeak:
            return UIColor(hexValue: 0xBF9000)
        case .lowPeak:
            return UIColor(hexValue: 0xC55A11)
        case .highPeak:
            return UIColor(hexValue: 0x00B050)
        case .veryLowMean:
            return UIColor(hexValue: 0xFFF2CC)
        case .lowMean:
            return UIColor(hexValue: 0xFBE5D6)
        case .highMean:
            return UIColor(hexValue: 0xC5E0B4)
        case .totalPower:
            return UIColor(hexValue: 0xFF0000)
        case .highRatio:
            return UIColor(hexValue: 0x01B0F0)
        case .lowRatio:
            return UIColor(hexValue: 0x2F5597)
        case .veryLowRatio:
            return UIColor(hexValue: 0xB870EE)
        case .newBandRatio:
            return UIColor(hexValue: 0x7030A0)
        case .pulseMean:
            return UIColor(hexValue: 0xFFFF02)
        case .pulseDeviation:
            return UIColor(hexValue: 0x92D050)
        case .o2Deviation:
            return UIColor(hexValue: 0xFFD966)
        case .breathMean:
            return UIColor(hexValue: 0x7F7F7F)
        case .breathDeviation:
            return UIColor(hexValue: 0xD9D9D9)
        case .minuteVent:
            return UIColor(hexValue: 0xBFBFBF)
        }
    }
}
