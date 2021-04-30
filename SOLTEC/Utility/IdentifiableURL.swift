//
//  IdentifiableURL.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 10/20/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import Foundation

struct IdentifiableURL: Identifiable {
    var id: String { return url.lastPathComponent }

    let url: URL
}
