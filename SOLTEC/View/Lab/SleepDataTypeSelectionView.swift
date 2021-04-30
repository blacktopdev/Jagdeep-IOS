//
//  DataTypeSelectionView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 10/19/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct SleepDataTypeSelectionView: View {
    @ObservedObject var preferences: SleepLabPreferences

    var body: some View {
        List {
            HStack(spacing: 20) {
                Text("Selected: " + preferences.normal.selectedTypes
                        .map { $0.rawValue }.joined(separator: ", "))
                    .font(.caption)
            }

            ForEach(SleepSignalType.allCases, id: \.self) { type in
                DataTypeSelectionRow(type: type, isSelected: preferences.normal.selectedTypes.contains(type)) {
                    if preferences.normal.selectedTypes.contains(type) {
                        preferences.normal.selectedTypes.remove(type)
                    } else {
                        preferences.normal.selectedTypes.insert(type)
                    }
                }

            }
        }
    }
}

struct DataTypeSelectionRow: View {
    var type: SleepSignalType
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Color(type.color)
                    .frame(width: 20, height: 20, alignment: .center)
                Text(self.type.rawValue)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

struct DataTypeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SleepDataTypeSelectionView(preferences: SleepLabPreferences())
            .colorScheme(.dark)
    }
}
