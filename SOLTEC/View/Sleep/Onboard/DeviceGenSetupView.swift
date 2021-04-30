//
//  DeviceSetupView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/10/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct DeviceGenSetupView: View {
    @StateObject private var coordinator: FormCoordinator<DeviceGenFormInteractor>

    @State private var cantGetUnder = false

    private let cancelBag = CancelBag()

    init(formModel: DeviceGenFormModel? = nil) {
        let model = formModel ?? DeviceGenFormModel()
        let coordinator = FormCoordinator(model: model, interactor: DeviceGenFormInteractor())
        _coordinator = StateObject(wrappedValue: coordinator)

        coordinator.$status.dropFirst().sink { status in
            if status == .validated || status == .success {
                withAnimation(.easeInOut) {
                    coordinator.model.page = coordinator.model.page.next
                }
            }
        }
        .store(in: cancelBag)
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    switch coordinator.model.page {
                    case .introduction:
                        introductionView
                            .transition(.slideAndFade())
                    case .plug:
                        plugView
                            .transition(.slideAndFade())
                    case .scanning:
                        scanningView
                            .onAppear { coordinator.submitForm(commit: true) }
                            .transition(.slideAndFade())
                    case .scanningResults:
                        scanningResultView
                            .transition(.slideAndFade())
                    case .complete:
                        completeView
                            .transition(.slideAndFade())
                    }

                    Button(action: {
                        coordinator.submitForm(commit: false)
                    }) {
                        ActivityButton(Text(coordinator.model.page == .complete ? "Complete Setup" : "Continue"),
                                       isWorking: coordinator.status == .working)
                            .formBottomActionButton()
                    }
                }
                .padding(EdgeInsets(top: 40, leading: Constants.Metrics.padding,
                                    bottom: Constants.Metrics.padding, trailing: Constants.Metrics.padding))
                .frame(minHeight: geometry.size.height)
            }
        }
        .fullscreenTheme()
        .navigationBarTitle("Z•GEN Setup", displayMode: .inline)
    }

    private var introductionView: some View {
        VStack {
            switch cantGetUnder {
            case true:
                underBedView
            case false:
                besideBedView
            }
        }
    }

    private var underBedView: some View {
        FormSectionView(image: Image("device-gen-bed-beside"),
                        title: "Put Z•GEN beside your bed",
                        text: "We recommend putting the Z•GEN as close to the foot of your bed as it can be. This will give you the best effects of the generator as it works through the night to keep you in deep sleep.") {
            Button(action: {
                withAnimation { cantGetUnder.toggle() }
            }) {
                Text("I have room under my bed")
                    .formScreenText(weight: .semibold)
                    .padding(Constants.Metrics.padding)
            }
        }
        .transition(AnyTransition.move(edge: .bottom)
                        .combined(with: .opacity).animation(.easeInOut))
    }

    private var besideBedView: some View {
        VStack(alignment: .leading, spacing: 56) {
            Image("device-gen-bed-under")
            FormSectionView(title: "Put Z•GEN under your bed",
                            text: "We recommend putting the Z•GEN as close to the foot of your bed as it can be. This will give you the best effects of the generator as it works through the night to keep you in deep sleep.") {
                Button(action: {
                    withAnimation { cantGetUnder.toggle() }
                }) {
                    Text("Can't get under your bed?")
                        .formScreenText(weight: .semibold)
                        .padding(Constants.Metrics.padding)
                }
            }
        }
        .transition(AnyTransition.move(edge: .bottom)
                        .combined(with: .opacity).animation(.easeInOut))
    }

    private var plugView: some View {
        FormSectionView(image: Image("device-gen-cable"),
                        title: "Plug in the Z•GEN",
                        text: "The Z•GEN will power on automatically when it’s plugged in to the wall and plugged into the device. No switches or buttons needed to operate. \n\nA sound will play when it’s connected.") { }
    }

    private var scanningView: some View {
        FormSectionView(image: Image("device-gen-large"),
                        title: "Connection Mode",
                        text: "Hold tight, we’re scanning the area for your device in the room. Ensure your device is plugged in.") { }
    }

    private var scanningResultView: some View {
        FormSectionView(image: Image("device-gen-large"),
                        title: "Device (not?) Found",
                        text: "Result-specific text here") { }
    }

    private var completeView: some View {
        VStack(alignment: .leading, spacing: 56) {
            Image("device-gen-bed-under")
            FormSectionView(title: "Running The Z•GEN",
                            text: "We recommend putting the Z•GEN as close to the foot of your bed as it can be. This will give you the best effects of the generator as it works through the night to keep you in deep sleep.") { }
        }
    }
}

struct DeviceGenSetupView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceGenSetupView()
            .previewDevice("iPhone 11")
    }
}
