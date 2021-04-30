//
//  SleepDataTypeViewView.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 10/29/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import SwiftUI

struct SleepDataTypeViewView: View {
    @ObservedObject var preferences: SleepLabPreferences

    var body: some View {
        Form {
            Section(header: Text("Staging")) {
                Picker(selection: $preferences.staging.displayMode, label: Text("Which"), content: {
                    Text("Hidden").tag(StageFilter.StagingMode.hidden)
                    Text("Raw").tag(StageFilter.StagingMode.raw)
                    Text("Filtered").tag(StageFilter.StagingMode.filtered)
                    Text("Final").tag(StageFilter.StagingMode.final)
                })
                .pickerStyle(SegmentedPickerStyle())

                Stepper("Smoothing: \(preferences.staging.filterWidth)",
                        onIncrement: { incrementStagingSmoothing(offset: 2) },
                        onDecrement: { incrementStagingSmoothing(offset: -2) })
                Picker(selection: $preferences.staging.filterMode, label: Text("Which"), content: {
                    Text("Classic").tag(StageFilter.FilterMode.classic)
                    Text("Hamming").tag(StageFilter.FilterMode.hamming)
                    Text("Hann").tag(StageFilter.FilterMode.hann)
                })
                .pickerStyle(SegmentedPickerStyle())
            }
            Section(header: Text("Motion")) {
                Toggle("Visible", isOn: $preferences.motion.enabled)
                Toggle("Raw", isOn: $preferences.motion.rawMode)
                Toggle("Affects final staging", isOn: $preferences.staging.motionAffectsStaging)
            }
            Section(header: Text("Normal")) {
                switch preferences.normal.filterMode {
                case .lowpass:
                    HStack {
                        Text("Alpha " + String(format: "%.2f", preferences.normal.filterAlpha))
                        Slider(value: $preferences.normal.filterAlpha, in: 0...1)
                    }
                default:
                    Stepper("Smoothing: \(preferences.normal.filterWidth)",
                            onIncrement: { incrementSmoothing(offset: 2) },
                            onDecrement: { incrementSmoothing(offset: -2) })
                }

                Picker(selection: $preferences.normal.filterMode, label: Text("Which"), content: {
                    Text("None").tag(SignalFilter.Mode.none)
                    Text("Classic").tag(SignalFilter.Mode.classic)
                    Text("Lowpass").tag(SignalFilter.Mode.lowpass)
                    Text("Hann").tag(SignalFilter.Mode.hann)
                })
                .pickerStyle(SegmentedPickerStyle())

                VStack {
                    Toggle("Normalized", isOn: $preferences.normal.isNormalized)
                    Toggle("Range override", isOn: $preferences.normal.isOverridingRange)

                    HStack {
                        Text("Min")
                        TextField("Min", value: $preferences.normal.overrideMin, formatter: NumberFormatter())
                        Text("Max")
                        TextField("Max", value: $preferences.normal.overrideMax, formatter: NumberFormatter())
                    }
                    VStack {
                        Toggle("WRLev", isOn: $preferences.normal.showWakeRemLevel)
                            .disabled(!preferences.normal.isNormalized)
                        Toggle("WLev", isOn: $preferences.normal.showWakeLevel)
                            .disabled(!preferences.normal.isNormalized)
                        Toggle("REMlev", isOn: $preferences.normal.showRemLevel)
                            .disabled(!preferences.normal.isNormalized)
                    }
                }

                HStack(spacing: 20) {
                    Button("Clear") {
                        preferences.reset()
                        preferences.normal.filterWidth = 1
                        LabSettings.preferredNormalSmoothing = 1
                    }
                    Text("Selected: \(preferences.normal.selectedTypes.count)")
                }.frame(maxWidth: .infinity).padding().background(Color(UIColor.red.withAlphaComponent(0.2)))
            }
        }
    }

    private func incrementSmoothing(offset: Int) {
        preferences.normal.filterWidth = max(1, preferences.normal.filterWidth + offset)

        LabSettings.preferredNormalSmoothing = preferences.normal.filterWidth
    }

    private func incrementStagingSmoothing(offset: Int) {
        preferences.staging.filterWidth = max(3, preferences.staging.filterWidth + offset)

        LabSettings.preferredStagingSmoothing = preferences.staging.filterWidth
    }
}

struct SleepDataTypeViewView_Previews: PreviewProvider {
    static var previews: some View {
        SleepDataTypeViewView(preferences: SleepLabPreferences())
            .colorScheme(.dark)
            .previewDevice("iPhone 8")
    }
}
