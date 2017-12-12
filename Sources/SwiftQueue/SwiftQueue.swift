//
// Created by Lucas Nelaupe on 10/08/2017.
// Copyright (c) 2017 lucas34. All rights reserved.
//

import Foundation

/// Protocol to create instance of your job
public protocol JobCreator {

    /// method called when a job has be to instantiate
    /// Type as specified in JobBuilder.init(type) and params as JobBuilder.with(params)
    func create(type: String, params: [String: Any]?) -> Job?

}

/// Method to implement to have a custom persister
public protocol JobPersister {

    /// Return an array of QueueName persisted
    func restore() -> [String]

    /// Restore all job in a single queue
    func restore(queueName: String) -> [String]

    /// Add a single job to a single queue with custom params
    func put(queueName: String, taskId: String, data: String)

    /// Remove a single job for a single queue
    func remove(queueName: String, taskId: String)

}

internal final class SwiftQueue: OperationQueue {

    private let creators: [JobCreator]
    private let persister: JobPersister?

    private let queueName: String

    init(queueName: String, creators: [JobCreator], persister: JobPersister? = nil, isPaused: Bool = false) {
        self.creators = creators
        self.persister = persister
        self.queueName = queueName

        super.init()

        self.isSuspended = isPaused
        self.name = queueName
        self.maxConcurrentOperationCount = 1

        loadSerializedTasks(name: queueName)
    }

    private func loadSerializedTasks(name: String) {
        persister?.restore(queueName: name).flatMap { string -> SwiftQueueJob? in
            SwiftQueueJob(json: string, creator: creators)
        }.sorted {
            $0.createTime < $1.createTime
        }.forEach(addOperation)
    }

    override func addOperation(_ ope: Operation) {
        guard let job = ope as? SwiftQueueJob else {
            // Not a job Task I don't care
            super.addOperation(ope)
            return
        }

        do {
            try job.willScheduleJob(queue: self)
        } catch let error {
            job.abort(error: error)
            return
        }

        // Serialize this operation
        if job.isPersisted, let sp = persister, let data = job.toJSONString() {
            sp.put(queueName: queueName, taskId: job.uuid, data: data)
        }
        job.completionBlock = { [weak self] in
            self?.completed(job)
        }
        super.addOperation(ope)
    }

    func cancelOperations(tag: String) {
        operations.flatMap { operation -> SwiftQueueJob? in
            operation as? SwiftQueueJob
        }.filter {
            $0.tags.contains(tag)
        }.forEach {
            $0.cancel()
        }
    }

    private func completed(_ job: SwiftQueueJob) {
        // Remove this operation from serialization
        if job.isPersisted, let sp = persister {
            sp.remove(queueName: queueName, taskId: job.uuid)
        }

        job.completed()
    }

    func createHandler(type: String, params: [String: Any]?) -> Job? {
        return SwiftQueue.createHandler(creators: creators, type: type, params: params)
    }

    static func createHandler(creators: [JobCreator], type: String, params: [String: Any]?) -> Job? {
        return creators.flatMap {
            $0.create(type: type, params: params)
        }.first
    }
}
