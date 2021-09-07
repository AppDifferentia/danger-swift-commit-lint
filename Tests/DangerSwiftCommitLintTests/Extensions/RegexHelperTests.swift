@testable import DangerSwiftCommitLint
import XCTest

final class RegexHelperTests: XCTestCase {
    private let pattern = #"((?:KEY|JIRA)-[0-9]+)"#
    private let invalidPattern = #"((?\:KEY|JIRA)-[0-9]+)"#

    func testSuccessfullyMatch() {
        XCTAssertTrue("Test Subject [KEY-123]" =~ pattern)
        XCTAssertTrue("[JIRA-321] Test Subject" =~ pattern)
    }

    func testFailedToMatch() {
        XCTAssertFalse("Test Subject" =~ pattern)
        XCTAssertFalse("Test Subject [TEST-123]" =~ pattern)
    }

    func testInvalidPattern() {
        XCTAssertFalse("Test Subject [KEY-123]" =~ invalidPattern)
        XCTAssertFalse("[JIRA-321] Test Subject" =~ invalidPattern)
    }
}
