@testable import DangerSwiftCommitLint
import XCTest

final class SubjectLengthCheckTests: XCTestCase {
    func testSuccess() {
        let commitMessage = GitCommitMessage(subject: "Valid title", bodyLinesOfText: [], sha: "Test SHA")
        let testSubject = SubjectLength(commitMessage)
        XCTAssertFalse(testSubject.fail)
        XCTAssertFalse(SubjectLength.fail(commitMessage))
    }

    func testFailure() {
        let commitMessage = GitCommitMessage(
            subject: "This is a long git commit subject for testing purpose.",
            bodyLinesOfText: [],
            sha: "Test SHA"
        )
        let testSubject = SubjectLength(commitMessage)
        XCTAssertTrue(testSubject.fail)
        XCTAssertTrue(SubjectLength.fail(commitMessage))
    }

    func testSuccessWithGitHubMergeCommit() {
        let commitMessage = GitCommitMessage(
            subject: "Merge pull request #123 from AppDifferentia/test-branching",
            bodyLinesOfText: [],
            sha: "Test SHA"
        )
        let testSubject = SubjectLength(commitMessage)
        XCTAssertFalse(testSubject.fail)
        XCTAssertFalse(SubjectLength.fail(commitMessage))
    }

    func testSuccessWithGitMergeCommit() {
        let commitMessage = GitCommitMessage(
            subject: "Merge branch 'master' into AppDifferentia/test-branching",
            bodyLinesOfText: [],
            sha: "Test SHA"
        )
        let testSubject = SubjectLength(commitMessage)
        XCTAssertFalse(testSubject.fail)
        XCTAssertFalse(SubjectLength.fail(commitMessage))
    }
}
