// The MIT License (MIT)
//
// Copyright (c) 2019 Lucas Nelaupe
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

internal final class SqOperation: Operation {

    let handler: Job

    var info: JobInfo

    let constraints: [JobConstraint]

    var lastError: Error?

    let logger: SwiftQueueLogger

    let listener: JobListener?

    let dispatchQueue: DispatchQueue

    var nextRunSchedule: Date?

    /// Current number of repetition. Transient value
    internal var currentRepetition: Int = 0

    override var name: String? { get { return info.uuid } set { } }
    override var queuePriority: QueuePriority { get { return info.priority } set { } }
    override var qualityOfService: QualityOfService { get { return info.qualityOfService } set { } }

    private var jobIsExecuting: Bool = false
    override var isExecuting: Bool {
        get { return jobIsExecuting }
        set {
            willChangeValue(forKey: "isExecuting")
            jobIsExecuting = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }

    private var jobIsFinished: Bool = false
    override var isFinished: Bool {
        get { return jobIsFinished }
        set {
            willChangeValue(forKey: "isFinished")
            jobIsFinished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }

    internal init(job: Job, info: JobInfo, logger: SwiftQueueLogger, listener: JobListener?, dispatchQueue: DispatchQueue) {
        self.handler = job
        self.info = info
        self.logger = logger
        self.listener = listener
        self.dispatchQueue = dispatchQueue
        self.constraints = self.info.buildConstraints()

        super.init()
    }

    override func start() {
        super.start()
        logger.log(.verbose, jobId: name, message: "Job has been started by the system")
        isExecuting = true
        run()
    }

    override func cancel() {
        self.cancel(with: SwiftQueueError.canceled)
    }

    func cancel(with: Error) {
        logger.log(.verbose, jobId: name, message: "Job has been canceled")
        lastError = with
        onTerminate()
        super.cancel()
    }

    func onTerminate() {
        logger.log(.verbose, jobId: name, message: "Job will not run anymore")
        if isExecuting {
            isFinished = true
        }
    }

    // cancel before schedule and serialize
    internal func abort(error: Error) {
        logger.log(.verbose, jobId: name, message: "Job has not been scheduled due to \(error.localizedDescription)")
        lastError = error
        // Need to be called manually since the task is actually not in the queue. So cannot call cancel()
        handler.onRemove(result: .fail(error))
        listener?.onTerminated(job: info, result: .fail(error))
    }

    internal func run() {
        if isCancelled && !isFinished {
            isFinished = true
        }
        if isFinished {
            return
        }

        do {
            try self.willRunJob()
        } catch let error {
            logger.log(.warning, jobId: name, message: "Job cannot run due to \(error.localizedDescription)")
            // Will never run again
            cancel(with: error)
            return
        }

        guard self.checkIfJobCanRunNow() else {
            // Constraint fail.
            // Constraint will call run when it's ready
            logger.log(.verbose, jobId: name, message: "Job cannot run now. Execution is postponed")
            return
        }

        logger.log(.verbose, jobId: name, message: "Job is running")
        listener?.onBeforeRun(job: info)
        handler.onRun(callback: self)
    }

    internal func remove() {
        let result = lastError.map(JobCompletion.fail) ?? JobCompletion.success
        logger.log(.verbose, jobId: name, message: "Job is removed from the queue result=\(result)")
        handler.onRemove(result: result)
        listener?.onTerminated(job: info, result: result)
    }

}

extension SqOperation: JobResult {

    func done(_ result: JobCompletion) {
        guard !isFinished else { return }

        listener?.onAfterRun(job: info, result: result)

        switch result {
        case .success:
            completionSuccess()
        case .fail(let error):
            completionFail(error: error)
        }
    }

    private func completionFail(error: Error) {
        logger.log(.warning, jobId: name, message: "Job completed with error \(error.localizedDescription)")
        lastError = error

        if let constraint = info.retryConstraint {
            constraint.onCompletionFail(sqOperation: self, error: error)
        } else {
            onTerminate()
        }
    }

    private func completionSuccess() {
        logger.log(.verbose, jobId: name, message: "Job completed successfully")
        lastError = nil
        currentRepetition = 0

        if let constraint = info.repeatConstraint {
            constraint.completionSuccess(sqOperation: self)
        } else {
            onTerminate()
        }
    }

}

extension SqOperation {

    func willScheduleJob(queue: SqOperationQueue) throws {
        for constraint in self.constraints {
            try constraint.willSchedule(queue: queue, operation: self)
        }
    }

    func willRunJob() throws {
        for constraint in self.constraints {
            try constraint.willRun(operation: self)
        }
    }

    func checkIfJobCanRunNow() -> Bool {
        for constraint in self.constraints where constraint.run(operation: self) == false {
            return false
        }
        return true
    }

}
