//
// Created by Lucas Nelaupe on 13/12/17.
//

import Foundation
import XCTest
@testable import SwiftQueue

class ConstraintDeadlineTests: XCTestCase {

    func testDeadlineWhenSchedule() {
        let job = TestJob()
        let type = UUID().uuidString

        let creator = TestCreator([type: job])

        let manager = SwiftQueueManager(creators: [creator])
        JobBuilder(type: type)
                .deadline(date: Date(timeIntervalSinceNow: TimeInterval(-10)))
                .schedule(manager: manager)

        job.await()

        XCTAssertEqual(job.onRunJobCalled, 0)
        XCTAssertEqual(job.onCompleteCalled, 0)
        XCTAssertEqual(job.onRetryCalled, 0)
        XCTAssertEqual(job.onCancelCalled, 1)
    }

    func testDeadlineWhenRun() {
        let job1 = TestJob()
        let type1 = UUID().uuidString

        let job2 = TestJob()
        let type2 = UUID().uuidString

        let creator = TestCreator([type1: job1, type2: job2])

        let manager = SwiftQueueManager(creators: [creator])
        JobBuilder(type: type1)
                .delay(time: 0.1)
                .retry(max: 5)
                .schedule(manager: manager)

        JobBuilder(type: type2)
                .deadline(date: Date()) // After 1 second should fail
                .retry(max: 5)
                .schedule(manager: manager)

        manager.waitUntilAllOperationsAreFinished()
        job1.await()

        XCTAssertEqual(job1.onRunJobCalled, 1)
        XCTAssertEqual(job1.onCompleteCalled, 1)
        XCTAssertEqual(job1.onRetryCalled, 0)
        XCTAssertEqual(job1.onCancelCalled, 0)

        job2.await()

        XCTAssertEqual(job2.onRunJobCalled, 0)
        XCTAssertEqual(job2.onCompleteCalled, 0)
        XCTAssertEqual(job2.onRetryCalled, 0)
        XCTAssertEqual(job2.onCancelCalled, 1)
    }

    func testDeadlineWhenDeserialize() {
        let group = UUID().uuidString

        let job = TestJob()
        let type = UUID().uuidString

        let creator = TestCreator([type: job])

        let jobUUID = UUID().uuidString

        let json = JobBuilder(type: type)
                .group(name: group)
                .deadline(date: Date())
                .build(job: job)
                .toJSONString()!

        let persister = PersisterTracker(key: UUID().uuidString)
        persister.put(queueName: group, taskId: jobUUID, data: json)

        _ = SwiftQueueManager(creators: [creator], persister: persister)

        XCTAssertEqual(group, persister.restoreQueueName)

        job.await()

        XCTAssertEqual(job.onRunJobCalled, 0)
        XCTAssertEqual(job.onCompleteCalled, 0)
        XCTAssertEqual(job.onRetryCalled, 0)
        XCTAssertEqual(job.onCancelCalled, 1)
    }

    func testDeadlineAfterSchedule() {
        let job1 = TestJob()
        let type1 = UUID().uuidString

        let creator = TestCreator([type1: job1])

        let manager = SwiftQueueManager(creators: [creator])
        JobBuilder(type: type1)
                .delay(time: 60)
                .deadline(date: Date(timeIntervalSinceNow: TimeInterval(0.1)))
                .retry(max: 5)
                .schedule(manager: manager)

        manager.waitUntilAllOperationsAreFinished()
        job1.await()

        XCTAssertEqual(job1.onRunJobCalled, 0)
        XCTAssertEqual(job1.onCompleteCalled, 0)
        XCTAssertEqual(job1.onRetryCalled, 0)
        XCTAssertEqual(job1.onCancelCalled, 1)
    }

}
