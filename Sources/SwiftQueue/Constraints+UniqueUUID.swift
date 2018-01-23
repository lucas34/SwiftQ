//
// Created by Lucas Nelaupe on 29/10/2017.
//

import Foundation

/// Exception thrown when you try to schedule a job with a same ID as one currently scheduled
public class TaskAlreadyExist: ConstraintError {}

internal class UniqueUUIDConstraint: JobConstraint {

    func willSchedule(queue: SwiftQueue, operation: SwiftQueueJob) throws {
        if operation.info.override {
            for op in queue.operations where op.name == operation.info.uuid {
                // Cancel previous job
                queue.cancelOperations(uuid: operation.info.uuid)
            }
        } else {
            for op in queue.operations where op.name == operation.info.uuid {
                // Cancel new job
                throw TaskAlreadyExist()
            }
        }
    }

    func willRun(operation: SwiftQueueJob) throws {
        // Nothing to check
    }

    func run(operation: SwiftQueueJob) -> Bool {
        // Nothing to check
        return true
    }
}
