//
//  SleepStageGraphView.swift
//  SOLTEC•Lab
//
//  Created by Jiropole on 11/23/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct SleepStageGraphView: View {

//    class Preferences: ObservableObject {
//    }

    @Binding var loadedValues: SleepDataset

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SleepStageGraphView_Previews: PreviewProvider {
    static var previews: some View {
        return StatefulPreviewWrapper(SleepDataset()) { state in
            SleepStageGraphView(loadedValues: state)
        }
    }
}
