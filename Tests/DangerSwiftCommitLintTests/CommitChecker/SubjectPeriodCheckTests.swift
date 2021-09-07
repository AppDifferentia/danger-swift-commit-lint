@testable import DangerSwiftCommitLint
import XCTest

final class SubjectPeriodCheckTests: XCTestCase {
    func testSuccess() {
        let commitMessage = CommitMessage(subject: "Test title without period at the end", bodyLinesOfText: [], sha: "Test SHA")
        let testSubject = SubjectPeriodCheck(message: commitMessage)
        XCTAssertFalse(testSubject.fail)
        XCTAssertFalse(SubjectPeriodCheck.fail(message: commitMessage))
    }

    func testFailure() {
        let commitMessage = CommitMessage(subject: "Test title with period at the end.", bodyLinesOfText: [], sha: "Test SHA")
        let testSubject = SubjectPeriodCheck(message: commitMessage)
        XCTAssertTrue(testSubject.fail)
        XCTAssertTrue(SubjectPeriodCheck.fail(message: commitMessage))
    }
}
