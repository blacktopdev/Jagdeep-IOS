//
//  View+Common.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 10/27/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

enum ModalDisplayIdiom {
    case popover
    case sheet
}

extension View {

    func popoverSheet(idiom: ModalDisplayIdiom, isPresented: Binding<Bool>, sheetContent: AnyView, requiredIdiom: ModalDisplayIdiom? = nil) -> some View {
        Group {
            if let requiredIdiom = requiredIdiom, requiredIdiom != idiom {
                modifier(EmptyModifier())
            } else {
                modifier(PopoverSheet(idiom: idiom, isPresented: isPresented, sheetContent: sheetContent))
            }
        }
    }

    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    /// ```
    /// Text("Label")
    ///     .isHidden(true)
    /// ```
    ///
    /// Example for complete removal:
    /// ```
    /// Text("Label")
    ///     .isHidden(true, remove: true)
    /// ```
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}

struct PopoverSheet: ViewModifier {
    var idiom: ModalDisplayIdiom
    @Binding var isPresented: Bool
    var sheetContent: AnyView

    func body(content: Content) -> some View {
        VStack {
            if idiom == .popover {
                content
                    .popover(isPresented: self.$isPresented) {
                        self.sheetContent
                    }
            } else {
                content
                    .sheet(isPresented: self.$isPresented) {
                        self.sheetContent
                    }
            }
        }
    }
}
