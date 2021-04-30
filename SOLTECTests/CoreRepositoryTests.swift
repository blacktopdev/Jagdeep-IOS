//
//  CoreRepositoryTests.swift
//  SOLTECTests
//
//  Created by Jiropole on 2/14/21.
//  Copyright © 2021 Round River Research Corporation. All rights reserved.
//

import XCTest
import Combine
@testable import SOLTEC_Z

/**
 To date, includes basic tests surrounding a single, flat entity, chosen at random.
 This tests only the basic design of Repository/Storable/Mappable/Domain.
 */
class CoreRepositoryTests: XCTestCase {

    var repo: CoreDataRepository!
    var cancelBag = CancelBag()

    let ssm1 = SleepStageMetric(wake: 100, rem: 200, light: 300, delta: 400)
    let ssm2 = SleepStageMetric(wake: 400, rem: 300, light: 200, delta: 100)

    override func setUpWithError() throws {
        repo = CoreDataRepository(modelName: "Soltec", isMemoryOnly: true)
    }

    override func tearDownWithError() throws {
    }

    func testCreateStageMetric() throws {
        let exp = XCTestExpectation(description: #function)
        repo.update(items: [MappableSleepStageMetric(domain: ssm1)])
            .sink(receiveCompletion: { (completion) in
                print(completion)
            }, receiveValue: { (items) in
                XCTAssertEqual(items.map { $0.domain }, [self.ssm1])
                XCTAssertNotNil(items.first!.storableIdentifier)
                exp.fulfill()
            })
            .store(in: cancelBag)
        wait(for: [exp], timeout: 1)
    }

    func testFetchStageMetric() throws {
        try testCreateStageMetric()

        let exp = XCTestExpectation(description: #function)
        repo.list(type: MappableSleepStageMetric.self, query: CoreDataQuery(predicate: nil))
            .sink(receiveCompletion: { (completion) in
                print(completion)
            }, receiveValue: { (items) in
                XCTAssertEqual(items.map { $0.domain }, [self.ssm1])
                exp.fulfill()
            })
            .store(in: cancelBag)
        wait(for: [exp], timeout: 1)
    }

    func testUpdateStageMetric() throws {
        let exp = XCTestExpectation(description: #function)
        repo.update(items: [MappableSleepStageMetric(domain: ssm1)])
            .flatMap { items -> AnyPublisher<[MappableSleepStageMetric], Error> in
                XCTAssertEqual(items.map { $0.domain }, [self.ssm1])
                return self.repo.update(items: items.map { $0.updating(domain: self.ssm2) })
            }
            .sink(receiveCompletion: { (completion) in
                print(completion)
            }, receiveValue: { (items) in
                XCTAssertEqual(items.map { $0.domain }, [self.ssm2])
                exp.fulfill()
            })
            .store(in: cancelBag)
        wait(for: [exp], timeout: 1)
    }

    // more...

    func testPerformance() throws {
        // This is an example of a performance test case.
        measure {
//            do {
//                try testSleepStageMetric()
//            } catch {
//                print(error)
//            }
        }
    }

}
