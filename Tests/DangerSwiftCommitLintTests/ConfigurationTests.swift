@testable import DangerSwiftCommitLint
import XCTest

final class DangerSwiftCommitLintConfigurationTests: XCTestCase {
    private typealias Configuration = DangerSwiftCommitLint.Configuration

    func testDefaultConfiguration() {
        let testSubject = Configuration()
        XCTAssertTrue(testSubject.disabledCheckers.isEmpty)
        XCTAssertTrue(testSubject.warningCheckers.isEmpty)
        XCTAssertTrue(testSubject.enabledCheckers.isEqual(to: testSubject.failingCheckers))
        XCTAssertTrue(testSubject.failingCheckers.isEqual(to: testSubject.allCheckers))
        XCTAssertEqual(testSubject.limit, 0)
    }

    func testDisableAllChecks() {
        let testSubject = Configuration(disabled: .all)
        XCTAssertTrue(testSubject.enabledCheckers.isEmpty)
        XCTAssertTrue(testSubject.allCheckers.isEqual(to: testSubject.disabledCheckers))
        XCTAssertTrue(testSubject.warningCheckers.isEmpty)
        XCTAssertTrue(testSubject.failingCheckers.isEmpty)
    }

    func testDisableAllChecksWithCustomChecker() {
        let testSubject = Configuration(disabled: .all, customCheckers: [MockChecker.self])
        XCTAssertTrue(testSubject.enabledCheckers.isEmpty)
        XCTAssertEqual(testSubject.allCheckers.count, Configuration.defaultCheckers.count + 1)
        XCTAssertTrue(testSubject.allCheckers.isEqual(to: testSubject.disabledCheckers))
        XCTAssertTrue(testSubject.disabledCheckers.contains { $0 == MockChecker.self })
        XCTAssertTrue(testSubject.warningCheckers.isEmpty)
        XCTAssertTrue(testSubject.failingCheckers.isEmpty)
    }

    func testWarnAllChecks() {
        let testSubject = Configuration(warn: .all)
        XCTAssertTrue(testSubject.enabledCheckers.isEqual(to: testSubject.allCheckers))
        XCTAssertTrue(testSubject.enabledCheckers.isEqual(to: testSubject.warningCheckers))
        XCTAssertTrue(testSubject.disabledCheckers.isEmpty)
        XCTAssertTrue(testSubject.failingCheckers.isEmpty)
    }

    func testWarnAllChecksWithCustomChecker() {
        let testSubject = Configuration(warn: .all, customCheckers: [MockChecker.self])
        XCTAssertEqual(testSubject.allCheckers.count, Configuration.defaultCheckers.count + 1)
        XCTAssertTrue(testSubject.enabledCheckers.isEqual(to: testSubject.allCheckers))
        XCTAssertTrue(testSubject.enabledCheckers.isEqual(to: testSubject.warningCheckers))
        XCTAssertTrue(testSubject.warningCheckers.contains { $0 == MockChecker.self })
        XCTAssertTrue(testSubject.disabledCheckers.isEmpty)
        XCTAssertTrue(testSubject.failingCheckers.isEmpty)
    }
}

private struct MockChecker: CommitLint {
    var fail: Bool { false }

    static var linterMessage = "Test message"

    init(_: GitCommitMessage) {
        // Intentionally left empty
    }
}

private extension Array where Element == CommitLint.Type {
    func isEqual(to other: [Element]) -> Bool {
        String(describing: self) == String(describing: other)
    }
}
