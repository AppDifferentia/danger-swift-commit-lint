@testable import DangerSwiftCommitLint
import XCTest

final class SubjectWordCheckTests: XCTestCase {
    func testSuccess() {
        let commitMessage = GitCommitMessage(subject: "Test title more than one word", bodyLinesOfText: [], sha: "Test SHA")
        let testSubject = SubjectWord(commitMessage)
        XCTAssertFalse(testSubject.fail)
        XCTAssertFalse(SubjectWord.fail(commitMessage))
    }

    func testFailure() {
        let commitMessage = GitCommitMessage(subject: "Failure", bodyLinesOfText: [], sha: "Test SHA")
        let testSubject = SubjectWord(commitMessage)
        XCTAssertTrue(testSubject.fail)
        XCTAssertTrue(SubjectWord.fail(commitMessage))
    }
}
