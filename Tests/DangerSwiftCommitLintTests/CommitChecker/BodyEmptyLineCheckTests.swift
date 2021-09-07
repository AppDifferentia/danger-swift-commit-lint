import Danger
@testable import DangerSwiftCommitLint
import XCTest

final class BodyEmptyLineCheckTests: XCTestCase {
    private let commitSubjectAndBody = CommitMessage(subject: "Title Test", bodyLinesOfText: ["", "Body Test"], sha: "Test SHA")
    private let commitSubjectOnly = CommitMessage(subject: "Title Test", bodyLinesOfText: [], sha: "Test SHA")
    private let commitNoNewline = CommitMessage(subject: "Title Test", bodyLinesOfText: ["Body Test"], sha: "Test SHA")

    func testSuccessCommitSubjectAndBody() {
        let testSubject = BodyEmptyLineCheck(message: commitSubjectAndBody)
        XCTAssertFalse(testSubject.fail)
        XCTAssertFalse(BodyEmptyLineCheck.fail(message: commitSubjectAndBody))
    }

    func testSuccessSubjectOnly() {
        let testSubject = BodyEmptyLineCheck(message: commitSubjectOnly)
        XCTAssertFalse(testSubject.fail)
        XCTAssertFalse(BodyEmptyLineCheck.fail(message: commitSubjectOnly))
    }

    func testFailureNoNewlineOnly() {
        let testSubject = BodyEmptyLineCheck(message: commitNoNewline)
        XCTAssertTrue(testSubject.fail)
        XCTAssertTrue(BodyEmptyLineCheck.fail(message: commitNoNewline))
    }
}
