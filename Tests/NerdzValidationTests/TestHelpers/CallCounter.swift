//
//  CallCounter.swift
//  NerdzValidationTests
//
//  A thread-safe call counter for verifying how many times a closure runs.
//

import Foundation

/// Records how many times something was invoked.
///
/// Marked `@unchecked Sendable` so it can be captured by the `@Sendable` closures that
/// `ByClosureValidationRule` requires. The safety invariant holds: all mutation is guarded by
/// the internal lock.
final class CallCounter: @unchecked Sendable {

    private let lock = NSLock()
    private var storedCount = 0

    /// The number of recorded invocations.
    var count: Int {
        lock.lock()
        defer { lock.unlock() }
        return storedCount
    }

    /// Records a single invocation.
    func increment() {
        lock.lock()
        storedCount += 1
        lock.unlock()
    }
}
