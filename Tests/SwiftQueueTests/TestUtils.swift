//
// Created by Lucas Nelaupe on 11/8/17.
// Copyright (c) 2017 Lucas Nelaupe. All rights reserved.
//

import XCTest
import Dispatch
@testable import SwiftQueue

class TestJob: Job {
    public let semaphore = DispatchSemaphore(value: 0)

    public var result: Error?

    public var onRunJobCalled = 0
    public var onRetryCalled = 0
    public var onCompleteCalled = 0
    public var onCancelCalled = 0

    public var retryConstraint = RetryConstraint.retry

    public var params: Any?

    func onRun(callback: JobResult) throws {
        onRunJobCalled += 1
        callback.onDone(error: result) // Auto complete
    }

    func onRetry(error: Error) -> RetryConstraint {
        onRetryCalled += 1
        return retryConstraint
    }

    func onRemove(error: Error?) {
        if error == nil {
            onCompleteCalled += 1
            semaphore.signal()
        } else {
            onCancelCalled += 1
            semaphore.signal()
        }
    }

    func await(_ seconds: TimeInterval = TimeInterval(5)) {
        let delta = DispatchTime.now() + Double(Int64(seconds) * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        semaphore.wait(timeout: delta)
    }
}

class TestCreator: JobCreator {
    private let job: [String: Job]

    public init(_ job: [String: Job]) {
        self.job = job
    }

    func create(type: String, params: Any?) -> Job? {
        if let value = job[type] as? TestJob {
            value.params = params
            return value
        } else {
            return job[type]
        }
    }
}

class PersisterTracker: UserDefaultsPersister {
    var restoreQueueName = ""

    var putQueueName: [String] = [String]()
    var putTaskId: [String] = [String]()
    var putData: [String] = [String]()

    var removeQueueName: [String] = [String]()
    var removeJobId: [String] = [String]()

    override func restore(queueName: String) -> [String] {
        restoreQueueName = queueName
        return super.restore(queueName: queueName)
    }

    override func put(queueName: String, taskId: String, data: String) {
        putQueueName.append(queueName)
        putTaskId.append(taskId)
        putData.append(data)
        super.put(queueName: queueName, taskId: taskId, data: data)
    }

    override func remove(queueName: String, taskId: String) {
        removeQueueName.append(queueName)
        removeJobId.append(taskId)
        super.remove(queueName: queueName, taskId: taskId)
    }
}

class JobError: Error {

}
