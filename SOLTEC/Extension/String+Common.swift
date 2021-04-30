//
//  String+Common.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/15/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
