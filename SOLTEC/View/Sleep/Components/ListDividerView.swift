//
//  ListDividerView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/5/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct ListDividerView: View {

    var color: Color = Color.appMono25
    
    var body: some View {
        Rectangle()
            .fill(Color.appMono25)
            .frame(maxWidth: .infinity)
            .frame(height: 1)
    }
}

struct ListDividerView_Previews: PreviewProvider {
    static var previews: some View {
        ListDividerView()
    }
}
