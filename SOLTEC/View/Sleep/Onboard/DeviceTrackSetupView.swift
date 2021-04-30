//
//  DeviceSetupView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 1/10/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct DeviceTrackSetupView: View {
    @StateObject private var coordinator: FormCoordinator<DeviceTrackFormInteractor>

    private let cancelBag = CancelBag()

    init(formModel: DeviceTrackFormModel? = nil) {
        let model = formModel ?? DeviceTrackFormModel()
        let coordinator = FormCoordinator(model: model, interactor: DeviceTrackFormInteractor())
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
                    case .chargingIndicator:
                        chargeIndicatorView
                            .transition(.slideAndFade())
                    case .bluetooth:
                        bluetoothView
                            .transition(.slideAndFade())
                    case .scanning:
                        scanningView
                            .transition(.slideAndFade())
                    case .scanningResults:
                        scanningResultView
                            .transition(.slideAndFade())
                    case .batteryIndicator:
                        batteryIndicatorView
                            .transition(.slideAndFade())
                    case .complete:
                        tapTwiceView
                            .transition(.slideAndFade())
                    }

                    Button(action: {
                        coordinator.submitForm()
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
        .navigationBarTitle("Z•TRACK Setup", displayMode: .inline)
    }

    private var introductionView: some View {
        VStack(alignment: .trailing, spacing: 56) {
            Image("device-track-cable")
            FormSectionView(title: "Charge your Z•TRACK",
                            text: "We recommend keeping your device on the charger during this setup process. Keep your device on the charger during the day to ensure you always have a full battery to last through the night.") { }
        }
    }

    private var chargeIndicatorView: some View {
        FormSectionView(image: Image("device-track-indicator"),
                        title: "Charging Indicator",
                        text: "When the blue light on the side of the device is flashing slowly, it means the device is charging.\n\nThe blue light on the device will stop flashing and stay on when the device is fully charged.") { }
    }

    private var bluetoothView: some View {
        VStack(spacing: Constants.Metrics.padding) {
            if coordinator.status == .error, let error = coordinator.fieldErrors.first?.error {
                WarningCardView(title: error.title, text: error.text)
            }
            FormSectionView(image: coordinator.status == .error ? nil : Image("device-track-bluetooth"),
                            title: "Bluetooth Access",
                            text: "We need to scan for your new device through Bluetooth, ensure this is on in your settings. We’ll need your permission to scan the room around you to find the Z•TRACK device.") { }
        }
    }

    private var scanningView: some View {
        FormSectionView(image: Image("device-track-bluetooth"),
                        title: "Searching for Device",
                        text: "Hold tight, we’re scanning the area for your device in the room. Ensure your device is charging and nearby.") { }
    }

    private var scanningResultView: some View {
        FormSectionView(image: Image("device-track"),
                        title: "Device (not?) Found",
                        text: "Result-specific text here") { }
    }

    private var batteryIndicatorView: some View {
        FormSectionView(image: Image("device-track-low"),
                        title: "Low Battery Indicator",
                        text: "Make sure the device is charged before going to sleep, otherwise the Z•TRACK won’t be able to track your entire nights sleep.\n\nThe blue light on the device will flash slowly when the battery is low.") { }
    }

    private var tapTwiceView: some View {
        FormSectionView(image: Image("device-track-twice"),
                        title: "Tap Twice to Sleep",
                        text: "Put the device in your wrist when it’s bed time and tap twice to start tracking your sleep. When you wake up in the morning simply put the Z•TRACK back on to its charger.") { }
    }
}

struct DeviceTrackSetupView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceTrackSetupView()
            .previewDevice("iPhone 12 Pro")
    }
}
