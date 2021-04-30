//
//  DataTypePreferencesView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 10/20/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct SleepPreferencesView: View {

    @ObservedObject var preferences: SleepLabPreferences
    @Binding var selectedFile: URL?

//    let onDismiss: (() -> ())?
    @Binding var isPresented: Bool

    @State private var selectedSection = 0

    var body: some View {
        VStack(spacing: 0) {
            Picker(selection: $selectedSection, label: Text("Which"), content: {
                Text("Types").tag(0)
                Text("Views").tag(1)
                Text("Files").tag(2)
            })
            .pickerStyle(SegmentedPickerStyle())
            .background(Color(.systemGroupedBackground))

            switch selectedSection {
            case 0:
                SleepDataTypeSelectionView(preferences: preferences)
            case 1:
                SleepDataTypeViewView(preferences: preferences)
            default:
                SleepNormalLoaderView(selectedFile: $selectedFile)
            }

            Button(action: { isPresented = false }) {
                Text("Dismiss").padding().frame(maxWidth: .infinity)
            }.background(Color(.systemGroupedBackground))
        }
        .colorScheme(.dark)
    }
}

struct DataTypePreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        return StatefulPreviewWrapper((nil, true)) {
            SleepPreferencesView(preferences: SleepLabPreferences(), selectedFile: $0.0, isPresented: $0.1)
                .labTheme()
        }
    }
}
