@testable import DangerSwiftCommitLint
import XCTest

final class SubjectCapCheckTests: XCTestCase {
    func testSuccess() {
        let commitMessage = CommitMessage(subject: "Subject", bodyLinesOfText: [], sha: "Test SHA")
        let testSubject = SubjectCapCheck(message: commitMessage)
        XCTAssertFalse(testSubject.fail)
        XCTAssertFalse(SubjectCapCheck.fail(message: commitMessage))
    }

    func testFailure() {
        let commitMessage = CommitMessage(subject: "subject", bodyLinesOfText: [], sha: "Test SHA")
        let testSubject = SubjectCapCheck(message: commitMessage)
        XCTAssertTrue(testSubject.fail)
        XCTAssertTrue(SubjectCapCheck.fail(message: commitMessage))
    }

    func testSuccessWithNonLetterCharacters() {
        let commitMessage = CommitMessage(subject: "[TEST-123] Subject", bodyLinesOfText: [], sha: "Test SHA")
        let testSubject = SubjectCapCheck(message: commitMessage)
        XCTAssertFalse(testSubject.fail)
        XCTAssertFalse(SubjectCapCheck.fail(message: commitMessage))
    }

    /// Git generally disallows empty commit message, so subject should at least contain non empty text. This test case is only capturing a unlikely edge case.
    func testEdgeCase() {
        let commitMessage = CommitMessage(subject: "", bodyLinesOfText: [], sha: "Test SHA")
        let testSubject = SubjectCapCheck(message: commitMessage)
        XCTAssertFalse(testSubject.fail)
        XCTAssertFalse(SubjectCapCheck.fail(message: commitMessage))
    }
}
