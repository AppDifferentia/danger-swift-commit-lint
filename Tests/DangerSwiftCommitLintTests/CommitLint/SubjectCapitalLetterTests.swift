@testable import DangerSwiftCommitLint
import XCTest

final class SubjectCapitalLetterTests: XCTestCase {
    func testSuccess() {
        let commitMessage = GitCommitMessage(subject: "Subject", bodyLinesOfText: [], sha: "Test SHA")
        let testSubject = SubjectCapitalLetter(commitMessage)
        XCTAssertFalse(testSubject.fail)
        XCTAssertFalse(SubjectCapitalLetter.fail(commitMessage))
    }

    func testFailure() {
        let commitMessage = GitCommitMessage(subject: "subject", bodyLinesOfText: [], sha: "Test SHA")
        let testSubject = SubjectCapitalLetter(commitMessage)
        XCTAssertTrue(testSubject.fail)
        XCTAssertTrue(SubjectCapitalLetter.fail(commitMessage))
    }

    func testSuccessWithNonLetterCharacters() {
        let commitMessage = GitCommitMessage(subject: "[TEST-123] Subject", bodyLinesOfText: [], sha: "Test SHA")
        let testSubject = SubjectCapitalLetter(commitMessage)
        XCTAssertFalse(testSubject.fail)
        XCTAssertFalse(SubjectCapitalLetter.fail(commitMessage))
    }

    /// Git generally disallows empty commit message, so subject should at least contain non empty text. This test case is only capturing a unlikely edge case.
    func testEdgeCase() {
        let commitMessage = GitCommitMessage(subject: "", bodyLinesOfText: [], sha: "Test SHA")
        let testSubject = SubjectCapitalLetter(commitMessage)
        XCTAssertFalse(testSubject.fail)
        XCTAssertFalse(SubjectCapitalLetter.fail(commitMessage))
    }
}
