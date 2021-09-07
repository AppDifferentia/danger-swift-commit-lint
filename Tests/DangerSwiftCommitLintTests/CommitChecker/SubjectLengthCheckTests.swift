@testable import DangerSwiftCommitLint
import XCTest

final class SubjectLengthCheckTests: XCTestCase {
    func testSuccess() {
        let commitMessage = CommitMessage(subject: "Valid title", bodyLinesOfText: [], sha: "Test SHA")
        let testSubject = SubjectLengthCheck(message: commitMessage)
        XCTAssertFalse(testSubject.fail)
        XCTAssertFalse(SubjectLengthCheck.fail(message: commitMessage))
    }

    func testFailure() {
        let commitMessage = CommitMessage(
            subject: "This is a long git commit subject for testing purpose.",
            bodyLinesOfText: [],
            sha: "Test SHA"
        )
        let testSubject = SubjectLengthCheck(message: commitMessage)
        XCTAssertTrue(testSubject.fail)
        XCTAssertTrue(SubjectLengthCheck.fail(message: commitMessage))
    }

    func testSuccessWithGitHubMergeCommit() {
        let commitMessage = CommitMessage(
            subject: "Merge pull request #123 from AppDifferentia/test-branching",
            bodyLinesOfText: [],
            sha: "Test SHA"
        )
        let testSubject = SubjectLengthCheck(message: commitMessage)
        XCTAssertFalse(testSubject.fail)
        XCTAssertFalse(SubjectLengthCheck.fail(message: commitMessage))
    }

    func testSuccessWithGitMergeCommit() {
        let commitMessage = CommitMessage(
            subject: "Merge branch 'master' into AppDifferentia/test-branching",
            bodyLinesOfText: [],
            sha: "Test SHA"
        )
        let testSubject = SubjectLengthCheck(message: commitMessage)
        XCTAssertFalse(testSubject.fail)
        XCTAssertFalse(SubjectLengthCheck.fail(message: commitMessage))
    }
}
