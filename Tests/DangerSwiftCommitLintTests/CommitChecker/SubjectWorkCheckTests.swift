@testable import DangerSwiftCommitLint
import XCTest

final class SubjectWordCheckTests: XCTestCase {
    func testSuccess() {
        let commitMessage = GitCommitMessage(subject: "Test title more than one word", bodyLinesOfText: [], sha: "Test SHA")
        let testSubject = SubjectWordCheck(commitMessage)
        XCTAssertFalse(testSubject.fail)
        XCTAssertFalse(SubjectWordCheck.fail(commitMessage))
    }

    func testFailure() {
        let commitMessage = GitCommitMessage(subject: "Failure", bodyLinesOfText: [], sha: "Test SHA")
        let testSubject = SubjectWordCheck(commitMessage)
        XCTAssertTrue(testSubject.fail)
        XCTAssertTrue(SubjectWordCheck.fail(commitMessage))
    }
}
