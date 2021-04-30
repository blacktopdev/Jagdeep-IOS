//
//  SleepNormalLoaderView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 10/20/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct SleepNormalLoaderView: View {

    @Binding var selectedFile: URL?

    @ObservedObject var folder: ObservableFolder

    @State private var selectedFilename: String = ""

    @State private var loaderResult = ObservableFolder.LoaderResult.none

//    var selectedFullFilename: String {
//        return URL(string: selectedFilename)?.appendingPathExtension("csv").absoluteString ?? ""
//    }

    static var cacheFolderName: String {
        return String(describing: self)
    }

    static var cacheUrl: URL! {
        return LabSettings.preferredDocumentsURL?.appendingPathComponent(cacheFolderName, isDirectory: true)
    }

    init(selectedFile: Binding<URL?>) {
        self._selectedFile = selectedFile
        folder = ObservableFolder(url: SleepNormalLoaderView.cacheUrl)
    }

    var body: some View {
        UITextField.appearance().clearButtonMode = .whileEditing
        return VStack(spacing: 0) {
            Form {
                HStack(alignment: VerticalAlignment.top) {
                    Text("Dataset").padding([.top, .trailing], 6)//.foregroundColor(Color(.label))
                    VStack(alignment: HorizontalAlignment.leading) {
                        TextField("Enter dataset name", text: $selectedFilename,
                                  onEditingChanged: { isEditing in if isEditing { loaderResult = .none } },
                                  onCommit: { loadFile() })
                        .autocapitalization(.none)
                        .textContentType(.URL)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                        if !selectedFilename.isEmpty && loaderResult == .none {
                            Button("Load dataset \"\(selectedFilename)\"") {
                                loadFile()
                            }
                            .font(.headline)
                            .padding()
                        }

                        switch loaderResult {
                        case .none:
                            EmptyView()
                        case .success:
                            Text("Successfully loaded dataset").foregroundColor(.green)
                        case .failure(let message):
                            Text(message).foregroundColor(.red)
                        }
                    }
                }
            }

            // List files
            let files = folder.files.map { IdentifiableURL(url: $0) }

            List(files) { file in
                SleepFileSelectionRow(url: file.url,
                                      isSelected: file.url.lastPathComponent == selectedFile?.lastPathComponent) {
                    selectedFile = file.url
                    LabSettings.selectedSleepNormalsPath = "\(SleepNormalLoaderView.cacheFolderName)/\(file.url.lastPathComponent)"
                }
            }

        }
        .background(Color(.systemBackground))
    }

    private func loadFile() {
        loaderResult = DataFileImporter.downloadDataset(dataSetName: selectedFilename,
                                                        localFolder: folder)
        if loaderResult == .success {
            selectedFile = folder.url.appendingPathComponent(selectedFilename)
            selectedFilename = ""
        }
    }
}

struct SleepFileSelectionRow: View {
    var url: URL
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(url.deletingPathExtension().lastPathComponent)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

struct SleepNormalLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        return StatefulPreviewWrapper(nil) {
            SleepNormalLoaderView(selectedFile: $0)
                .colorScheme(.dark)
        }
    }
}
