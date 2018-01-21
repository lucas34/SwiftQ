//
// Created by Lucas Nelaupe on 11/8/17.
// Copyright (c) 2017 Lucas Nelaupe. All rights reserved.
//

import XCTest
@testable import SwiftQueue

class ConstraintTests: XCTestCase {

    func testPeriodicJob() {
        let job = TestJob()
        let type = UUID().uuidString

        let creator = TestCreator([type: job])

        let manager = SwiftQueueManager(creators: [creator])
        JobBuilder(type: type)
                .periodic(limit: .limited(5))
                .schedule(manager: manager)

        job.await()

        XCTAssertEqual(job.onRunJobCalled, 5)
        XCTAssertEqual(job.onCompleteCalled, 1)
        XCTAssertEqual(job.onRetryCalled, 0)
        XCTAssertEqual(job.onCancelCalled, 0)
    }

    func testRetryFailJobWithRetryConstraint() {
        let job = TestJob()
        let type = UUID().uuidString

        let creator = TestCreator([type: job])

        job.result = JobError()
        job.retryConstraint = .retry(delay: 0)

        let manager = SwiftQueueManager(creators: [creator])
        JobBuilder(type: type)
                .retry(limit: .limited(2))
                .schedule(manager: manager)

        job.await()

        XCTAssertEqual(job.onRunJobCalled, 3)
        XCTAssertEqual(job.onCompleteCalled, 0)
        XCTAssertEqual(job.onRetryCalled, 2)
        XCTAssertEqual(job.onCancelCalled, 1)
    }

    func testRetryFailJobWithRetryDelayConstraint() {
        let job = TestJob()
        let type = UUID().uuidString

        let creator = TestCreator([type: job])

        job.result = JobError()
        job.retryConstraint = .retry(delay: Double.leastNonzeroMagnitude)

        let manager = SwiftQueueManager(creators: [creator])
        JobBuilder(type: type)
                .retry(limit: .limited(2))
                .schedule(manager: manager)

        job.await()

        XCTAssertEqual(job.onRunJobCalled, 3)
        XCTAssertEqual(job.onCompleteCalled, 0)
        XCTAssertEqual(job.onRetryCalled, 2)
        XCTAssertEqual(job.onCancelCalled, 1)
    }

    func testRetryFailJobWithCancelConstraint() {
        let job = TestJob()
        let type = UUID().uuidString

        let creator = TestCreator([type: job])

        job.result = JobError()
        job.retryConstraint = .cancel

        let manager = SwiftQueueManager(creators: [creator])
        JobBuilder(type: type)
                .retry(limit: .limited(2))
                .schedule(manager: manager)

        job.await()

        XCTAssertEqual(job.onRunJobCalled, 1)
        XCTAssertEqual(job.onCompleteCalled, 0)
        XCTAssertEqual(job.onRetryCalled, 1)
        XCTAssertEqual(job.onCancelCalled, 1)
    }

    func testRetryFailJobWithExponentialConstraint() {
        let job = TestJob()
        let type = UUID().uuidString

        let creator = TestCreator([type: job])

        job.result = JobError()
        job.retryConstraint = .exponential(initial: 0)

        let manager = SwiftQueueManager(creators: [creator])
        JobBuilder(type: type)
                .retry(limit: .limited(2))
                .schedule(manager: manager)

        job.await()

        XCTAssertEqual(job.onRunJobCalled, 3)
        XCTAssertEqual(job.onCompleteCalled, 0)
        XCTAssertEqual(job.onRetryCalled, 2)
        XCTAssertEqual(job.onCancelCalled, 1)
    }

    func testRepeatableJobWithExponentialBackoffRetry() {
        let job = TestJob()
        let type = UUID().uuidString

        let creator = TestCreator([type: job])

        job.result = JobError()
        job.retryConstraint = RetryConstraint.exponential(initial: Double.leastNonzeroMagnitude)

        let manager = SwiftQueueManager(creators: [creator])
        JobBuilder(type: type)
                .retry(limit: .limited(1))
                .periodic()
                .schedule(manager: manager)

        job.await()

        XCTAssertEqual(job.onRunJobCalled, 2)
        XCTAssertEqual(job.onCompleteCalled, 0)
        XCTAssertEqual(job.onRetryCalled, 1)
        XCTAssertEqual(job.onCancelCalled, 1)
    }

    func testRepeatableJobWithDelay() {
        let job = TestJob()
        let type = UUID().uuidString

        let creator = TestCreator([type: job])

        let manager = SwiftQueueManager(creators: [creator])
        JobBuilder(type: type)
                .periodic(limit: .limited(2), interval: Double.leastNonzeroMagnitude)
                .schedule(manager: manager)

        job.await()

        XCTAssertEqual(job.onRunJobCalled, 2)
        XCTAssertEqual(job.onCompleteCalled, 1)
        XCTAssertEqual(job.onRetryCalled, 0)
        XCTAssertEqual(job.onCancelCalled, 0)
    }

    func testCancelRunningOperation() {
        let job = TestJob(10)
        let type = UUID().uuidString

        let creator = TestCreator([type: job])

        let manager = SwiftQueueManager(creators: [creator])
        JobBuilder(type: type)
                .schedule(manager: manager)

        runInBackgroundAfter(Double.leastNonzeroMagnitude) {
            manager.cancelAllOperations()
        }

        job.await()

        XCTAssertEqual(job.onRunJobCalled, 1)
        XCTAssertEqual(job.onCompleteCalled, 0)
        XCTAssertEqual(job.onRetryCalled, 0)
        XCTAssertEqual(job.onCancelCalled, 1)
    }

    func testCancelRunningOperationByTag() {
        let job = TestJob(10)
        let type = UUID().uuidString

        let tag = UUID().uuidString

        let creator = TestCreator([type: job])

        let manager = SwiftQueueManager(creators: [creator])
        JobBuilder(type: type)
                .addTag(tag: tag)
                .schedule(manager: manager)

        runInBackgroundAfter(Double.leastNonzeroMagnitude) {
            manager.cancelOperations(tag: tag)
        }

        job.await()

        XCTAssertEqual(job.onRunJobCalled, 1)
        XCTAssertEqual(job.onCompleteCalled, 0)
        XCTAssertEqual(job.onRetryCalled, 0)
        XCTAssertEqual(job.onCancelCalled, 1)
    }
}
