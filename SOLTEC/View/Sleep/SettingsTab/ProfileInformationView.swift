//
//  ProfileInformationView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/3/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct ProfileInformationView: View {

    var body: some View {
        VStack(spacing: 0) {
            FormInfoRow(title: Text("First Name"), content: Text("Dan"))
            FormInfoRow(title: Text("Last Name"), content: Text("Cohen"))
            FormInfoRow(title: Text("Date of Birth"), content: Text("05/10/1975"))
            FormInfoRow(title: Text("Gender"), content: Text("Male"))
            FormInfoRow(title: Text("Height"), content: Text("5' 11\""))
            FormInfoRow(title: Text("Weight"), content: Text("155 lbs"))
            Spacer()

            ListDividerView()
            FormInfoRow(title: Text("Delete Account").foregroundColor(.red), content: EmptyView()) {
                print("Handle delete account request")
            }
        }
        .padding(EdgeInsets(top: 40, leading: 0, bottom: Constants.Metrics.padding, trailing: 0))
        .navigationBarTitle("Dan Cohen", displayMode: .inline)
    }
}

struct ProfileInformationView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInformationView()
            .fullscreenTheme(darkness: .darker)
    }
}
