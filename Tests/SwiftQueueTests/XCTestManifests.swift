#if !canImport(ObjectiveC)
import XCTest

extension BasicConstraintTest {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__BasicConstraintTest = [
        ("testContraintThrowExceptionShouldCancelOperation", testContraintThrowExceptionShouldCancelOperation),
        ("testJobShouldBeCancelIfThrowExceptionInConstraintOnWillRun", testJobShouldBeCancelIfThrowExceptionInConstraintOnWillRun),
        ("testOperationRunWhenConstraintTrigger", testOperationRunWhenConstraintTrigger),
    ]
}

extension ConstraintTestCharging {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ConstraintTestCharging = [
        ("testChargingConstraintShouldRunNow", testChargingConstraintShouldRunNow),
    ]
}

extension ConstraintTestDeadline {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ConstraintTestDeadline = [
        ("testDeadlineAfterSchedule", testDeadlineAfterSchedule),
        ("testDeadlineWhenDeserialize", testDeadlineWhenDeserialize),
        ("testDeadlineWhenRun", testDeadlineWhenRun),
        ("testDeadlineWhenSchedule", testDeadlineWhenSchedule),
    ]
}

extension ConstraintTestDelay {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ConstraintTestDelay = [
        ("testDelay", testDelay),
    ]
}

extension ConstraintTestNetwork {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ConstraintTestNetwork = [
        ("testNetworkConstraint", testNetworkConstraint),
        ("testNetworkConstraintWifi", testNetworkConstraintWifi),
    ]
}

extension ConstraintTestRepeat {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ConstraintTestRepeat = [
        ("testPeriodicJob", testPeriodicJob),
        ("testPeriodicJobUnlimited", testPeriodicJobUnlimited),
        ("testRepeatableJobWithDelay", testRepeatableJobWithDelay),
        ("testRepeatSerialisation", testRepeatSerialisation),
    ]
}

extension ConstraintTestRetry {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ConstraintTestRetry = [
        ("testRepeatableJobWithExponentialBackoffRetry", testRepeatableJobWithExponentialBackoffRetry),
        ("testRetryFailJobWithCancelConstraint", testRetryFailJobWithCancelConstraint),
        ("testRetryFailJobWithExponentialConstraint", testRetryFailJobWithExponentialConstraint),
        ("testRetryFailJobWithExponentialMaxDelayConstraint", testRetryFailJobWithExponentialMaxDelayConstraint),
        ("testRetryFailJobWithRetryConstraint", testRetryFailJobWithRetryConstraint),
        ("testRetryFailJobWithRetryDelayConstraint", testRetryFailJobWithRetryDelayConstraint),
        ("testRetryUnlimitedShouldRetryManyTimes", testRetryUnlimitedShouldRetryManyTimes),
    ]
}

extension ConstraintTestTag {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ConstraintTestTag = [
        ("testCancelRunningOperationByTag", testCancelRunningOperationByTag),
    ]
}

extension ConstraintTestTimeout {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ConstraintTestTimeout = [
        ("testRunTimeoutConstraint", testRunTimeoutConstraint),
    ]
}

extension ConstraintTestUniqueUUID {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ConstraintTestUniqueUUID = [
        ("testUniqueIdConstraintShouldCancelTheFirst", testUniqueIdConstraintShouldCancelTheFirst),
        ("testUniqueIdConstraintShouldCancelTheSecond", testUniqueIdConstraintShouldCancelTheSecond),
    ]
}

extension CustomConstraintTest {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__CustomConstraintTest = [
        ("testCustomConstraint", testCustomConstraint),
    ]
}

extension LoggerTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__LoggerTests = [
        ("testLoggerLevel", testLoggerLevel),
        ("testRunSuccessJobLogger", testRunSuccessJobLogger),
    ]
}

extension PersisterTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__PersisterTests = [
        ("testCancelAllShouldRemoveFromPersister", testCancelAllShouldRemoveFromPersister),
        ("testCancelWithTagShouldRemoveFromPersister", testCancelWithTagShouldRemoveFromPersister),
        ("testCompleteFailTaskRemoveFromSerializer", testCompleteFailTaskRemoveFromSerializer),
        ("testCompleteJobRemoveFromSerializer", testCompleteJobRemoveFromSerializer),
        ("testCustomSerializer", testCustomSerializer),
        ("testLoadSerializedSortedJobShouldRunSuccess", testLoadSerializedSortedJobShouldRunSuccess),
        ("testNonPersistedJobShouldNotBePersisted", testNonPersistedJobShouldNotBePersisted),
        ("testRemoveAllJob", testRemoveAllJob),
    ]
}

extension SqOperationTest {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__SqOperationTest = [
        ("testQualityOfService", testQualityOfService),
        ("testQueuePriority", testQueuePriority),
    ]
}

extension StartStopTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__StartStopTests = [
        ("testSchedulePeriodicJobThenStart", testSchedulePeriodicJobThenStart),
        ("testScheduleWhenQueueStop", testScheduleWhenQueueStop),
    ]
}

extension SwiftQueueBuilderTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__SwiftQueueBuilderTests = [
        ("testBuilderAddTag", testBuilderAddTag),
        ("testBuilderDeadlineCodable", testBuilderDeadlineCodable),
        ("testBuilderDelay", testBuilderDelay),
        ("testBuilderGroup", testBuilderGroup),
        ("testBuilderInternetCellular", testBuilderInternetCellular),
        ("testBuilderInternetWifi", testBuilderInternetWifi),
        ("testBuilderJobType", testBuilderJobType),
        ("testBuilderPeriodicUnlimited", testBuilderPeriodicUnlimited),
        ("testBuilderRequireCharging", testBuilderRequireCharging),
        ("testBuilderRetryLimited", testBuilderRetryLimited),
        ("testBuilderRetryUnlimited", testBuilderRetryUnlimited),
        ("testBuilderSingleInstance", testBuilderSingleInstance),
        ("testBuilderSingleInstanceOverride", testBuilderSingleInstanceOverride),
        ("testBuilderWithFreeArgs", testBuilderWithFreeArgs),
        ("testCopyBuilder", testCopyBuilder),
    ]
}

extension SwiftQueueManagerTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__SwiftQueueManagerTests = [
        ("testAddOperationNotJobTask", testAddOperationNotJobTask),
        ("testCancelAll", testCancelAll),
        ("testCancelRunningOperation", testCancelRunningOperation),
        ("testCancelWithTag", testCancelWithTag),
        ("testCancelWithUUID", testCancelWithUUID),
        ("testGetAll", testGetAll),
        ("testGetOperation", testGetOperation),
        ("testJobListener", testJobListener),
        ("testLimitEquatable", testLimitEquatable),
        ("testRunSuccessJob", testRunSuccessJob),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(BasicConstraintTest.__allTests__BasicConstraintTest),
        testCase(ConstraintTestCharging.__allTests__ConstraintTestCharging),
        testCase(ConstraintTestDeadline.__allTests__ConstraintTestDeadline),
        testCase(ConstraintTestDelay.__allTests__ConstraintTestDelay),
        testCase(ConstraintTestNetwork.__allTests__ConstraintTestNetwork),
        testCase(ConstraintTestRepeat.__allTests__ConstraintTestRepeat),
        testCase(ConstraintTestRetry.__allTests__ConstraintTestRetry),
        testCase(ConstraintTestTag.__allTests__ConstraintTestTag),
        testCase(ConstraintTestTimeout.__allTests__ConstraintTestTimeout),
        testCase(ConstraintTestUniqueUUID.__allTests__ConstraintTestUniqueUUID),
        testCase(CustomConstraintTest.__allTests__CustomConstraintTest),
        testCase(LoggerTests.__allTests__LoggerTests),
        testCase(PersisterTests.__allTests__PersisterTests),
        testCase(SqOperationTest.__allTests__SqOperationTest),
        testCase(StartStopTests.__allTests__StartStopTests),
        testCase(SwiftQueueBuilderTests.__allTests__SwiftQueueBuilderTests),
        testCase(SwiftQueueManagerTests.__allTests__SwiftQueueManagerTests),
    ]
}
#endif
