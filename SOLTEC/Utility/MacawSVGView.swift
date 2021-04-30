//
//  MacawSVGView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/21/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI
import Macaw

struct MacawSVGView: UIViewRepresentable {

    let filename: String
    
    func makeUIView(context: Context) -> SVGView {
        let view = SVGView()
        view.backgroundColor = UIColor.red.withAlphaComponent(0.1)
        view.contentMode = .scaleAspectFill

        view.fileName = filename
        return view
    }

    func updateUIView(_ uiView: SVGView, context: Context) { }
}

struct MacawSVGView_Previews: PreviewProvider {
    static var previews: some View {
        MacawSVGView(filename: "atom")
            .fullscreenTheme()
    }
}
