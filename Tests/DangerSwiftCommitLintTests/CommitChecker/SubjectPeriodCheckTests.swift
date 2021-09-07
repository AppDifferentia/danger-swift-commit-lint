@testable import DangerSwiftCommitLint
import XCTest

final class SubjectPeriodCheckTests: XCTestCase {
    func testSuccess() {
        let commitMessage = GitCommitMessage(subject: "Test title without period at the end", bodyLinesOfText: [], sha: "Test SHA")
        let testSubject = SubjectPeriodCheck(commitMessage)
        XCTAssertFalse(testSubject.fail)
        XCTAssertFalse(SubjectPeriodCheck.fail(commitMessage))
    }

    func testFailure() {
        let commitMessage = GitCommitMessage(subject: "Test title with period at the end.", bodyLinesOfText: [], sha: "Test SHA")
        let testSubject = SubjectPeriodCheck(commitMessage)
        XCTAssertTrue(testSubject.fail)
        XCTAssertTrue(SubjectPeriodCheck.fail(commitMessage))
    }
}
