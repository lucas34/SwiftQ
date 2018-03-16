//
// Created by Lucas Nelaupe on 29/10/2017.
//

import Foundation

internal final class DelayConstraint: JobConstraint {

    func willSchedule(queue: SqOperationQueue, operation: SqOperation) throws {
        // Nothing to do
    }

    func willRun(operation: SqOperation) throws {
        // Nothing to do
    }

    func run(operation: SqOperation) -> Bool {
        if let delay = operation.info.delay {
            if Date().timeIntervalSince(operation.info.createTime) < delay {
                runInBackgroundAfter(delay, callback: { [weak operation] in
                    // If the operation in already deInit, it may have been canceled
                    // It's safe to ignore the nil check
                    // This is mostly to prevent job retention when cancelling operation with delay
                    operation?.run()
                })
                return false
            }
        }
        return true
    }
}
