@testable import DangerSwiftCommitLint
import XCTest

final class SubjectWordCheckTests: XCTestCase {
    func testSuccess() {
        let commitMessage = CommitMessage(subject: "Test title more than one word", bodyLinesOfText: [], sha: "Test SHA")
        let testSubject = SubjectWordCheck(message: commitMessage)
        XCTAssertFalse(testSubject.fail)
        XCTAssertFalse(SubjectWordCheck.fail(message: commitMessage))
    }

    func testFailure() {
        let commitMessage = CommitMessage(subject: "Failure", bodyLinesOfText: [], sha: "Test SHA")
        let testSubject = SubjectWordCheck(message: commitMessage)
        XCTAssertTrue(testSubject.fail)
        XCTAssertTrue(SubjectWordCheck.fail(message: commitMessage))
    }
}
