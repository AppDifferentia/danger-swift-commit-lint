@testable import DangerSwiftCommitLint
import XCTest

final class SubjectPeriodTests: XCTestCase {
    func testSuccess() {
        let commitMessage = GitCommitMessage(subject: "Test title without period at the end", bodyLinesOfText: [], sha: "Test SHA")
        let testSubject = SubjectPeriod(commitMessage)
        XCTAssertFalse(testSubject.fail)
        XCTAssertFalse(SubjectPeriod.fail(commitMessage))
    }

    func testFailure() {
        let commitMessage = GitCommitMessage(subject: "Test title with period at the end.", bodyLinesOfText: [], sha: "Test SHA")
        let testSubject = SubjectPeriod(commitMessage)
        XCTAssertTrue(testSubject.fail)
        XCTAssertTrue(SubjectPeriod.fail(commitMessage))
    }
}
