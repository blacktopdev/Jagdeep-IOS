//
//  ActivityButton.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/9/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct ActivityButton<Content: View>: View {
    let content: Content
    var isWorking = false

    init (_ content: Content, isWorking: Bool) {
        self.content = content
        self.isWorking = isWorking
    }

    var body: some View {
        HStack(spacing: Constants.Metrics.padding) {
            content
            if isWorking {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
        }
        .disabled(isWorking)
    }
}

struct ActivityButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ActivityButton(Text("Test this"), isWorking: false)
            ActivityButton(Text("Login"), isWorking: true)
        }
        .fullscreenTheme()
    }
}
