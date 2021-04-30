//
//  ObservableFolder.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 10/20/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import Foundation

class ObservableFolder: ObservableObject {

    @Published var files: [URL] = []

    private let fileDescriptor: CInt
    private let source: DispatchSourceProtocol

    private(set) var url: URL
    private(set) var allowableExtensions: [String]?

    deinit {
        self.source.cancel()
    }

    init(url: URL, allowableExtensions: [String]? = nil) {
        self.url = url
        self.allowableExtensions = allowableExtensions

        ObservableFolder.verifyExists(url: url)

        fileDescriptor = open(url.path, O_EVTONLY)
        source = DispatchSource.makeFileSystemObjectSource(fileDescriptor: self.fileDescriptor,
                                                           eventMask: .all,
                                                           queue: DispatchQueue.global())
        source.setEventHandler { [weak self] in
            self?.updateFiles()
        }
        source.setCancelHandler { [weak self] in guard let self = self else { return }
            close(self.fileDescriptor)
        }
        source.resume()

        updateFiles()
    }

    @discardableResult
    static func verifyExists(url: URL) -> Bool {
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url,
                                                        withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Failed to create observable folder")
                return false
            }
        }

        return true
    }

    func updateFiles() {
        let files = (try? FileManager.default.contentsOfDirectory(at: url,
                                                                  includingPropertiesForKeys: nil,
                                                                  options: .producesRelativePathURLs)) ?? []
        DispatchQueue.main.async {
            self.files = files
                .filter { self.shouldDisplay(file: $0) }
                .sorted(by: { (a, b) -> Bool in
                return a.lastPathComponent < b.lastPathComponent
            })
        }
    }

    func shouldDisplay(file: URL) -> Bool {
        guard !(file.lastPathComponent.prefix(1) == ".") else { return false }
        guard let allowable = allowableExtensions else {
            return true
        }
        return allowable.contains(file.pathExtension)
    }

    enum LoaderResult: Equatable {
        case none
        case success
        case failure(String)
    }

    func loadFile(fromBaseUrl baseUrl: URL, path: String) -> LoaderResult {
        let remoteUrl = baseUrl.appendingPathComponent(path)
        let localUrl = url.appendingPathComponent(path)

        do {
            let contents = try String(contentsOf: remoteUrl)
            ObservableFolder.verifyExists(url: localUrl.deletingLastPathComponent())

            do {
                try contents.write(to: localUrl, atomically: true, encoding: .utf8)
                return .success
            } catch {
                return .failure(error.localizedDescription)
            }
        } catch {
            return .failure(error.localizedDescription)
        }
    }
}
