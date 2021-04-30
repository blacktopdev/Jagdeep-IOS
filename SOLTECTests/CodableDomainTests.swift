//
//  CodableDomainTests.swift
//  SOLTECTests
//
//  Created by Jiropole on 2/15/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import XCTest
import Combine
@testable import SOLTEC_Z

class CodableDomainTests: XCTestCase {

    var repo: CoreDataRepository!
    var cancelBag = CancelBag()

    override func setUpWithError() throws {
        repo = CoreDataRepository(modelName: "Soltec", isMemoryOnly: true)
    }

    override func tearDownWithError() throws {
    }

    private func decodeAndStore<M: Mappable>(type: M.Type) throws where M.StorableType: CoreDataRepository.StorableType,
                                                                        M.ConnectorType == CoreDataRepository.ConnectorType,
                                                                        M.DomainType: DomainObject {
        let domain = try MockDataRepository.loadDomain(M.DomainType.self)

        let exp = XCTestExpectation(description: "\(#function)-\(M.DomainType.entityName)")
        repo.update(items: [M(domain: domain, storableIdentifier: nil)])
            .sink(receiveCompletion: { (completion) in
                print(completion)
            }, receiveValue: { (items) in
                print("verifying \(String(describing: type))")
                XCTAssertEqual(items.map { $0.domain }, [domain])
                exp.fulfill()
            })
            .store(in: cancelBag)
        wait(for: [exp], timeout: 5)
    }

    // MARK: Leaves

    func testDecodeMappableStageMetric() throws {
        try decodeAndStore(type: MappableSleepStageMetric.self)
    }

    func testDecodeMappableSleepStageResult() throws {
        try decodeAndStore(type: MappableSleepStageResult.self)
    }

    func testDecodeMappableSleepAggregateMetric() throws {
        try decodeAndStore(type: MappableSleepAggregateMetric.self)
    }

    func testDecodeMappableSleepScore() throws {
        try decodeAndStore(type: MappableSleepScore.self)
    }

    func testDecodeMappableSleepEventMetric() throws {
        try decodeAndStore(type: MappableSleepEventMetric.self)
    }

    func testDecodeMappableSleepStageMean() throws {
        try decodeAndStore(type: MappableSleepStageMean.self)
    }

    func testDecodeMappableSleepSignal() throws {
        try decodeAndStore(type: MappableSleepSignal.self)
    }

    func testDecodeMappableSleepArousal() throws {
        try decodeAndStore(type: MappableSleepArousal.self)
    }

    func testDecodeMappableSleepDesaturation() throws {
        try decodeAndStore(type: MappableSleepDesaturation.self)
    }

    func testDecodeMappableSleepMotion() throws {
        try decodeAndStore(type: MappableSleepMotion.self)
    }

    func testDecodeMappableSleepProtocol() throws {
        try decodeAndStore(type: MappableSleepProtocol.self)
    }

    func testDecodeMappableSleepSound() throws {
        try decodeAndStore(type: MappableSleepSound.self)
    }

    func testDecodeMappableSleepDevice() throws {
        try decodeAndStore(type: MappableSleepDevice.self)
    }

    func testDecodeMappableSleepSystem() throws {
        try decodeAndStore(type: MappableSleepSystem.self)
    }

    // MARK: Branches

    func testDecodeMappableSleepStream() throws {
        try decodeAndStore(type: MappableSleepStream.self)
    }

    func testDecodeMappableSleepEpoch() throws {
        try decodeAndStore(type: MappableSleepEpoch.self)
    }

    func testDecodeMappableSleepStageAggregate() throws {
        try decodeAndStore(type: MappableSleepStageAggregate.self)
    }

    func testDecodeMappableSleepSessionAggregate() throws {
        try decodeAndStore(type: MappableSleepSessionAggregate.self)
    }

    func testDecodeMappableSleepSessionMetric() throws {
        try decodeAndStore(type: MappableSleepSessionMetric.self)
    }

    func testDecodeMappableSleepTrend() throws {
        try decodeAndStore(type: MappableSleepTrend.self)
    }

    func testDecodeMappableSleepSession() throws {
        try decodeAndStore(type: MappableSleepSession.self)
    }

    func testDecodeMappableUser() throws {
//        try decodeAndStore(type: MappableUser.self)
        typealias Map = MappableUser
        let domain = try MockDataRepository.loadDomain(Map.DomainType.self)

        let exp = XCTestExpectation(description: "\(#function)-\(Map.DomainType.entityName)")
        repo.update(items: [Map(domain: domain)])
            .sink(receiveCompletion: { (completion) in
                print(completion)
            }, receiveValue: { (items) in
                print("verifying \(String(describing: Map.self))")
                // we skip validating PII and sessions, as User does not proactive load sessions
                XCTAssertEqual(items.first!.domain.uuid, domain.uuid)
                XCTAssertEqual(items.first!.domain.system, domain.system)
                XCTAssertEqual(items.first!.domain.trend, domain.trend)
                exp.fulfill()
            })
            .store(in: cancelBag)
        wait(for: [exp], timeout: 5)

    }
}
