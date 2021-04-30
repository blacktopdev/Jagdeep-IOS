//
//  WebView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 12/21/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let fileUrl: URL?
    let svgName: String?

    init(fileUrl: URL) {
        self.fileUrl = fileUrl
        self.svgName = nil
    }

    init(svgName: String) {
        self.fileUrl = nil
        self.svgName = svgName
    }

    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.backgroundColor = .clear
        view.isOpaque = false

        if let url = fileUrl {
            view.loadFileURL(url, allowingReadAccessTo: url)
        }
        else if let svgName = svgName,
                let templateUrl = Bundle.main.url(forResource: "wrapper-template", withExtension: "html", subdirectory: "WebAssets"),
                let templateString = try? String(contentsOf: templateUrl) {
            let baseUrl = templateUrl.deletingLastPathComponent()
            let svgUrl = baseUrl.appendingPathComponent(svgName)

            if let svgString = try? String(contentsOf: svgUrl) {
                let htmlString = String(format: templateString, svgString)

                view.loadHTMLString(htmlString, baseURL: nil)
            }
        }

        return view
    }

    func updateUIView(_ uiView: WKWebView, context: Context) { }

}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(svgName: "atom.svg")
//        WebView(svgUrl: Bundle.main.url(forResource: "atom", withExtension: "svg")!)
    }
}
