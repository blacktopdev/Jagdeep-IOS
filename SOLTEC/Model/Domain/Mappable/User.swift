//
//  User.swift
//  SOLTEC•Z
//
//  Created by Jiropole on 2/8/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import Foundation

struct User: DomainObject {
    enum Gender: SleepEnumerationType, Codable {
        case male
        case female
        case nonConforming
        case undeclared
    }

    let uuid: String

    let system: SleepSystem
    let trend: SleepTrend?
    let devices: [SleepDevice]
    let sessions: [SleepSession]

    // PII, not to be stored off device except when exchanged with identity provider.
    let username: String?
    let firstName: String?
    let lastName: String?
    let email: String?
    let birthDate: Date?
    let gender: Gender?
    let heightCm: Float?
    let weightKg: Float?
}

extension User: SimpleMocking {
    static var mock = User(uuid: "mock", system: SleepSystem.mock, trend: SleepTrend.mock,
                           devices: (0..<2).map { _ in SleepDevice.mock }, sessions: [SleepSession.mock],
                           username: "timG", firstName: "Tim", lastName: "Grundland", email: "tgrunnie@hotmail.com",
                           birthDate: nil, gender: .male, heightCm: 150, weightKg: 180)

    static var empty = User(uuid: "empty", system: SleepSystem.empty,
                            trend: nil, devices: [], sessions: [], username: "empty",
                            firstName: nil, lastName: nil, email: nil, birthDate: nil, gender: nil, heightCm: nil, weightKg: nil)
}
