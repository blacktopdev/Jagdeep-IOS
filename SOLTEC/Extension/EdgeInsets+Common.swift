//
//  EdgeInsets+Common.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/13/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

extension EdgeInsets {
    static func union(insets: [EdgeInsets]) -> EdgeInsets {
        insets.reduce(EdgeInsets()) { (result, insets) in
            EdgeInsets(top: max(result.top, insets.top),
                       leading: max(result.leading, insets.leading),
                       bottom: max(result.bottom, insets.bottom),
                       trailing: max(result.trailing, insets.trailing))
        }
    }
}
