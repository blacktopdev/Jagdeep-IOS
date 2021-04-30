//
//  Theme.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 11/13/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

extension View {

    func fullscreenTheme(darkness: FullScreenTheme.Darkness = .normal) -> some View {
        modifier(FullScreenTheme(darkness: darkness))
    }

    func heavyCardTheme() -> some View {
        modifier(HeavyCardTheme())
    }

    func heavierCardTheme() -> some View {
        modifier(HeavierCardTheme())
    }

    func looseCardTheme() -> some View {
        modifier(LooseCardTheme())
    }

    func regularCardTheme(looser: Bool = false, radius: CGFloat = Constants.Metrics.cornerRadius) -> some View {
        modifier(RegularCardTheme(looser: looser, radius: radius))
    }

    func compactCardTheme(darker: Bool = false, padding: CGFloat = Constants.Metrics.padding) -> some View {
        modifier(CompactCardTheme(darker: darker, padding: padding))
    }

    func dottedOutlineCardTheme(darker: Bool = false, padding: CGFloat = Constants.Metrics.padding) -> some View {
        modifier(DottedOutlineCardTheme(darker: darker, padding: padding))
    }

    func tightCardTheme() -> some View {
        modifier(TightCardTheme())
    }

    func formTextField(hasError: Bool = false) -> some View {
        self.frame(height: 36)
            .padding([.leading, .trailing], Constants.Metrics.padding)
            .padding([.top, .bottom], Constants.Metrics.lightPadding)
            .foregroundColor(hasError ? Color.appMagentaDark : Color.appMono25)
            .background(Color.appMonoF8)
            .border(Color.appMagentaDark, width: hasError ? 3 : 0)
            .cornerRadius(Constants.Metrics.cornerRadiusHard)
    }

    func warningCard() -> some View {
        self.padding([.leading, .trailing], Constants.Metrics.padding)
            .padding([.top, .bottom], 20)
            .background(Color.appMagentaDark)
            .cornerRadius(Constants.Metrics.cornerRadiusTight)
    }

    // used by: section headers in scrolling lists
    func headerCardTheme() -> some View {
        font(.system(size: UIFontMetrics.default.scaledValue(for: 22.0),
                     weight: .bold, design: .default))
            .padding(.top, 40)
//            .foregroundColor(.appMonoF8)
    }

    func southEast(gradient: Gradient) -> some View {
        return modifier(LinearGradientModifier(gradient: gradient,
                                               startPoint: .topLeading,
                                               endPoint: .bottomTrailing))
    }

    // used by: day calender arrows
    func smallSymbolFont() -> some View {
        font(.system(size: UIFontMetrics.default.scaledValue(for: 11.0),
                     weight: .regular, design: .default))
    }

    // used by: explanatory text bodies
    func conciseBodyFont() -> some View {
        font(.system(size: UIFontMetrics.default.scaledValue(for: 14.0),
                     weight: .regular, design: .default))
    }

    // used by metric compact card title
    func calloutFont() -> some View {
        font(.system(size: UIFontMetrics.default.scaledValue(for: 16.0),
                     weight: .regular, design: .default))
    }

    // used for labeling graphs
    func footnoteFont() -> some View {
        font(.system(size: UIFontMetrics.default.scaledValue(for: 15.0),
                     weight: .bold, design: .default))
    }

    // Used by report headlines
    func subHeadlineFont() -> some View {
        font(.system(size: UIFontMetrics.default.scaledValue(for: 19.0),
                     weight: .bold, design: .default))
    }

    // used by: large sleep score metric title, metric compact card value, section header
    func headlineFont(weight: Font.Weight = .bold) -> some View {
        font(.system(size: UIFontMetrics.default.scaledValue(for: 22.0),
                     weight: weight, design: .default))
    }

    // used by: large sleep score, large question mark
    func largeTitleFont() -> some View {
        font(.system(size: UIFontMetrics.default.scaledValue(for: 65.0),
                     weight: .bold, design: .default))
    }

    // used by: large sleep score metric title, metric compact card value, section header
    func rowTitleFont(weight: Font.Weight = .semibold) -> some View {
        font(.system(size: UIFontMetrics.default.scaledValue(for: 17.0),
                     weight: weight, design: .default))
    }

    func formScreenTitle() -> some View {
        self.standardFont(size: 28, weight: .bold)
    }

    func formScreenText(weight: Font.Weight = .regular) -> some View {
        self.standardFont(size: 15, weight: weight)
    }

    // used by: special case axis label sizes, etc
    func standardFont(size: CGFloat, weight: Font.Weight) -> some View {
        font(.system(size: UIFontMetrics.default.scaledValue(for: size),
                     weight: weight, design: .default))
    }

    // Used by the day calendar / status disks view
    func axisLabelFont(isSelected: Bool = false, isDisabled: Bool = false, size: CGFloat = 11) -> some View {
        return (isSelected ? font(.system(size: UIFontMetrics.default.scaledValue(for: size),
                                          weight: .bold, design: .default)) :
                             font(.system(size: UIFontMetrics.default.scaledValue(for: size),
                                          weight: .regular, design: .default)))
            .foregroundColor(isDisabled ? Color.appMonoA3.opacity(0.5) :
                                (isSelected ? .appMonoD8 : Color.appMonoD8.opacity(0.76)))
    }

    func standardButton() -> some View {
        self.frame(maxWidth: .infinity)
            .frame(height: 55)
            .standardFont(size: 17, weight: .bold)
            .background(Color.appLavenderDark)
            .cornerRadius(Constants.Metrics.cornerRadius)
    }

    func highlightButton() -> some View {
        self.frame(maxWidth: .infinity)
            .frame(height: 55)
            .standardFont(size: 17, weight: .bold)
            .background(Color.appLavender)
            .cornerRadius(Constants.Metrics.cornerRadius)
    }

    func formBottomActionButton() -> some View {
        self.highlightButton()
            .padding(.top, Constants.Metrics.padding)
            .padding(.bottom, 46)
    }
}

private struct LinearGradientModifier: ViewModifier {

    let gradient: Gradient
    let startPoint: UnitPoint
    let endPoint: UnitPoint

    func body(content: Content) -> some View {
        ZStack {
            Rectangle().fill(LinearGradient(gradient: gradient,
                                            startPoint: startPoint,
                                            endPoint: endPoint))
            content
        }
    }
}

struct FullScreenTheme: ViewModifier {
    enum Darkness {
        case normal
        case darker
        case darkest
    }
    let darkness: Darkness

    func body(content: Content) -> some View {
        ZStack {
            switch darkness {
            case .normal:
                Color.appMono25
                    .edgesIgnoringSafeArea(.all)
            case .darker:
                Color.appMono19
                    .edgesIgnoringSafeArea(.all)
            case .darkest:
                Color.appMono10
                    .edgesIgnoringSafeArea(.all)
            }
            content
        }
        .foregroundColor(Color.appMonoF8)
    }
}

private struct HeavyCardTheme: ViewModifier {

    func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: 86,
                                leading: 38,
                                bottom: 56,
                                trailing: 38))
            .foregroundColor(Color.appMonoF8)
            .background(Color.appMono10)
            .cornerRadius(Constants.Metrics.cornerRadius)
    }
}

private struct HeavierCardTheme: ViewModifier {

    func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: 138,
                                leading: 38,
                                bottom: 64,
                                trailing: 38))
            .foregroundColor(Color.appMonoF8)
            .background(Color.appMono2C)
            .cornerRadius(Constants.Metrics.cornerRadius)
    }
}

private struct LooseCardTheme: ViewModifier {

    func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: 54,
                                leading: 38,
                                bottom: 54,
                                trailing: 38))
            .foregroundColor(Color.appMonoF8)
            .background(Color.appMono10)
            .cornerRadius(Constants.Metrics.cornerRadius)
    }
}

private struct RegularCardTheme: ViewModifier {

    var looser: Bool = false
    var radius: CGFloat = Constants.Metrics.cornerRadius

    func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: looser ? 36: 16,
                                leading: 16,
                                bottom: looser ? 64 : 36,
                                trailing: Constants.Metrics.padding))
            .foregroundColor(Color.appMonoF8)
            .background(Color.appMono2C)
            .cornerRadius(radius)
    }
}

private struct CompactCardTheme: ViewModifier {
    let darker: Bool
    var padding: CGFloat = Constants.Metrics.padding

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .foregroundColor(darker ? Color.appMonoD8 : Color.appMonoF8)
            .background(Color.appMono2C)
            .cornerRadius(Constants.Metrics.cornerRadiusLoose)
    }
}

private struct DottedOutlineCardTheme: ViewModifier {
    let darker: Bool
    var padding: CGFloat = Constants.Metrics.padding

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .foregroundColor(darker ? Color.appMonoD8 : Color.appMonoF8)
//            .background(Color.appMono2C)
//            .cornerRadius(Constants.Metrics.cornerRadiusLoose)
            .overlay(RoundedRectangle(cornerRadius: Constants.Metrics.cornerRadiusLoose)
                        .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8]))
                        .foregroundColor(.appMono8E))
    }
}

private struct TightCardTheme: ViewModifier {

    func body(content: Content) -> some View {
        content
            .fixedSize(horizontal: false, vertical: true)
            .padding(0)
            .foregroundColor(Color.appMonoF8)
            .background(Color.appMono2C)
            .cornerRadius(Constants.Metrics.cornerRadius)
    }
}

//private struct MildCardTheme: ViewModifier {
//
//    func body(content: Content) -> some View {
//        content
//            .padding(EdgeInsets(top: 20, leading: 0, bottom: Constants.Metrics.heavyPadding, trailing: 0))
//            .background(Color.appMono2C)
//            .cornerRadius(Constants.Metrics.cornerRadius)
//    }
//}

extension AnyTransition {
    static func slideAndFade(left: Bool = true) -> AnyTransition {
        let insertion = AnyTransition.move(edge: left ? .trailing : .leading)
            .combined(with: .opacity)
        let removal = AnyTransition.move(edge: left ? .leading : .trailing)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

// MARK: - Active modifiers

extension View {
    func placeHolder<T: View>(_ text: T, show: Bool, hasError: Bool) -> some View {
        self.modifier(PlaceHolderViewModifier(placeholder: text, show: show, hasError: hasError))
    }

    func clearButton(_ text: Binding<String>, isHidden: Bool = false) -> some View {
        self.modifier(ClearButtonViewModifier(text: text, isHidden: isHidden))
    }
}

struct PlaceHolderViewModifier<T: View>: ViewModifier {
    let placeholder: T
    let show: Bool
    let hasError: Bool

    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            // Assumes content has transparent background. allowsHitTesting(false) doesn't work over UIViews,
            // which is why the content is *above* the placeholder.
            if show {
                placeholder
                    .foregroundColor(hasError ? .appMagentaDark : .appMonoA3)
            }
            content
        }
    }
}

struct ClearButtonViewModifier: ViewModifier {
    @Binding var text: String
    var isHidden: Bool = false

    func body(content: Content) -> some View {
        HStack {
            content
            Spacer()
            // onTapGesture is better than a Button here when adding to a form
            Image(systemName: "multiply.circle.fill")
                .foregroundColor(.appMonoA3)
                .opacity(text == "" || isHidden ? 0 : 1)
                .onTapGesture { self.text = "" }
        }
    }
}
