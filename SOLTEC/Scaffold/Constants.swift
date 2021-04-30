//
//  Constants.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 10/8/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct Constants {

    static let sciChartLicenseKey = "oZ5yPRsGoc4ebV9cQRs7jjA2TTIUeGNFKLkvI5nCInQPQNgCszYNjIB7CHq3TJdwHWQ9HfajFukeRXd7uf4RnfpiXLmVNDmFRaRwRurqnBV4Jt9lQRPTfpVi7gO4WV36w6hLqriplHjaZ5vTihleozdtw6BxphETUqXUq0pGmz0FT81wfvaxGSh1Ijwi58bnwn6uR3hlXKKrOpu+84QKVWULmuTyRljsWQZz4fhrz3BHOEKevddQNwwOZ0CkGGhLqC9XNHITtuRxeOh/EU83O8m8TfSbHi7LKAQ6VnJ1D0JI0lz9OjzRGE3czNfWk+wqxmCX7M3aisQt4aSdW7WtHo1wiKUIwXRwcFcsekP1aC+bCw7t24sWm7BoO+hwG6awfbAQ2uZ/gkBZLkIVkHtCNk/BLP4SWZ3zWDFAmud82PlFK59wg8ycKjx10ocPSH8mqauhdMw91AQSd6snXlQPTLCHUmH9oTQtcRIdX8v8IJHVHiew/xoxApzzGGdl2kO/KPMKdw30uTDUN/kh6LVxaFRjYAOBsKg5k7i2kYsSfTaBIqaqUvmjQPRP9b7kSYsI/6L7qFkEhp6e/JZtCevPGlPeza6a5aJgCoYDKAg5OOBuUBKFkgmKIJU="

    static let epochInterval: TimeInterval = 30
    static let cgEpochInterval: CGFloat = 30
    static let epochsPerHour: CGFloat = 3600 / cgEpochInterval

    struct Metrics {
        static let lightPadding: CGFloat = 6
        static let rowPadding: CGFloat = 10
        static let halfPadding: CGFloat = 8
        static let padding: CGFloat = 16
        static let heavyPadding: CGFloat = 26

        static let graphSpacing = CGSize(width: padding, height: padding)
        static let axisSpacing = CGSize(width: padding, height: rowPadding)

        static let cornerRadius: CGFloat = 8
        static let cornerRadiusLoose: CGFloat = 10
        static let cornerRadiusTight: CGFloat = 6
        static let cornerRadiusHard: CGFloat = 4

//        static let graphAnimationCurve = TimingCurve(c1: CGPoint(x: 0.21, y: 0.0),
//                                                     c2: CGPoint(x: 0.25, y: 1.19), duration: 0.47125)
        #if !APP_LAB
        static let graphAnimationCurve = TimingCurve(c1: CGPoint(x: 0.39, y: 1.2),
                                                     c2: CGPoint(x: 0.8, y: 1.0), duration: 0.42)
        static let graphAnimationStagger: CGFloat = 0.67
        #endif
    }

    struct Fonts {
        static func standardFont(size: CGFloat, weight: Font.Weight = .regular,
                                 design: Font.Design = .default) -> Font {
            return Font.system(size: UIFontMetrics.default.scaledValue(for: size),
                               weight: weight, design: design)
        }
    }

    // MARK: - Date Formatters

    static func dateRange(with endDate: Date,
                          subtracting component: Calendar.Component,
                          value: Int) -> ClosedRange<Date> {
        guard let startDate = Calendar.current.date(byAdding: component,
                                                    value: -value,
                                                    to: endDate) else { return endDate...endDate }
        return startDate...endDate
    }

    struct DateFormatters {
        static var longDate: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            return formatter
        }()

        static var medium: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter
        }()

        static var year: DateFormatter = {
            let formatter = DateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("yyyy")
            return formatter
        }()

        static var monthShort: DateFormatter {
            let formatter = DateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("MMM")
            return formatter
        }

        static var monthAndDay: DateFormatter {
            let formatter = DateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("MMMM d")
            return formatter
        }

        static var monthDayYear: DateFormatter {
            let formatter = DateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("MMMM d YYYY")
            return formatter
        }

        static var dayInMonth: DateFormatter {
            let formatter = DateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("d")
            return formatter
        }

        static var dayName: DateFormatter {
            let formatter = DateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("cccc")
            return formatter
        }

        static var dayNameShort: DateFormatter {
            let formatter = DateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("ccccc")
            return formatter
        }

        static var timeOfDay: DateFormatter {
            let formatter = DateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("h")
            return formatter
        }

        static func dateRange(with endDate: Date,
                              subtracting component: Calendar.Component,
                              value: Int) -> String {
            let dateRange = Constants.dateRange(with: endDate, subtracting: component, value: value)

            let startComps = Calendar.current.dateComponents([.month, .day, .year],
                                                             from: dateRange.lowerBound)
            let endComps = Calendar.current.dateComponents([.month, .day, .year], from:
                                                            dateRange.upperBound)

            if endComps.year != startComps.year {
                return "\(monthDayYear.string(from: dateRange.lowerBound)) - \(monthDayYear.string(from: dateRange.upperBound))"
            }
            else if endComps.month != startComps.month {
                return "\(monthAndDay.string(from: dateRange.lowerBound)) - \(monthAndDay.string(from: dateRange.upperBound))"
            }
            return "\(monthAndDay.string(from: dateRange.lowerBound)) - \(dayInMonth.string(from: dateRange.upperBound))"
        }

        static var ordinal: NumberFormatter {
            let formatter = NumberFormatter()
            formatter.numberStyle = .ordinal
            return formatter
        }
//
//        static func ordinalMonth(with date: Date) -> String {
//            let comps = Calendar.current.dateComponents([.day], from: date)
//
//        }
    }
}
