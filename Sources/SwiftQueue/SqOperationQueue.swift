//
// Created by Lucas Nelaupe on 23/1/18.
//

import Foundation

internal final class SqOperationQueue: OperationQueue {

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
            $0.info.createTime < $1.info.createTime
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
        if job.info.isPersisted, let sp = persister, let data = job.toJSONString() {
            sp.put(queueName: queueName, taskId: job.info.uuid, data: data)
        }
        job.completionBlock = { [weak self] in
            self?.completed(job)
        }
        super.addOperation(ope)
    }

    func cancelOperations(tag: String) {
        for case let operation as SwiftQueueJob in operations where operation.info.tags.contains(tag) {
            operation.cancel()
        }
    }

    func cancelOperations(uuid: String) {
        for case let operation as SwiftQueueJob in operations where operation.info.uuid == uuid {
            operation.cancel()
        }
    }

    private func completed(_ job: SwiftQueueJob) {
        // Remove this operation from serialization
        if job.info.isPersisted, let sp = persister {
            sp.remove(queueName: queueName, taskId: job.info.uuid)
        }

        job.remove()
    }

    func createHandler(type: String, params: [String: Any]?) -> Job? {
        return SqOperationQueue.createHandler(creators: creators, type: type, params: params)
    }

    static func createHandler(creators: [JobCreator], type: String, params: [String: Any]?) -> Job? {
        for creator in creators {
            if let job = creator.create(type: type, params: params) {
                return job
            }
        }
        assertionFailure("No job creator associate to job type \(type)")
        return nil
    }
}
