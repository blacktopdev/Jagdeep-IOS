//
//  SleepEventData.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 9/30/20.
//  Copyright © 2020 Round River Research Corporation. All rights reserved.
//

import Foundation

struct SleepMotion: DurationEvent, Codable {
    let started: Date
    let stopped: Date?

    let intensityMean: Float
    let intensityMax: Float
}

struct SleepSound: DurationEvent, Codable {
    let started: Date
    let stopped: Date?

    let intensityMean: Float
    let frequencyMax: Float
}

struct SleepDesaturation: DurationEvent, Codable {
    let started: Date
    let stopped: Date?

    let degreeMean: Float
    let degreeMax: Float
}

struct SleepArousal: DurationEvent, Codable {
    let started: Date
    let stopped: Date?

    let pulseLow: Float
    let pulseHigh: Float
}

struct SleepSlope: DurationEvent, Codable {
    let started: Date
    let stopped: Date?

    let levelFirst: Float
    let levelLast: Float
    let levelAverage: Float
}

struct SleepFlat: DurationEvent, Codable {
    let started: Date
    let stopped: Date?

    let levelFirst: Float
    let levelLast: Float
    let levelAverage: Float
}

struct SleepProtocol: DurationEvent, Codable {
    let started: Date
    let stopped: Date?

    /// An enumeration of interventions for event type `intervention`.
    enum SleepProtocol: SleepEnumerationType, Codable {
        case intervention
    }

    let protocolType: SleepProtocol
    let revision: String
    let parameters: Data
}

/// Only available with patch device.
struct SleepPosition: DurationEvent, Codable {
    let started: Date
    let stopped: Date?

    /// An enumeration of positions for event type `position`.
    enum Position: SleepEnumerationType, Codable {
        case unknown
        case up
        case back
        case left
        case right
        case front
    }

    let position: Position
}
