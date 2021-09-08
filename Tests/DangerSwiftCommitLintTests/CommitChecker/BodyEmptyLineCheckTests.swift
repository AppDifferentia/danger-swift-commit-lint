import Danger
@testable import DangerSwiftCommitLint
import XCTest

final class BodyEmptyLineCheckTests: XCTestCase {
    private let commitSubjectAndBody = GitCommitMessage(subject: "Title Test", bodyLinesOfText: ["", "Body Test"], sha: "Test SHA")
    private let commitSubjectOnly = GitCommitMessage(subject: "Title Test", bodyLinesOfText: [], sha: "Test SHA")
    private let commitNoNewline = GitCommitMessage(subject: "Title Test", bodyLinesOfText: ["Body Test"], sha: "Test SHA")

    func testSuccessCommitSubjectAndBody() {
        let testSubject = BodyEmptyLine(commitSubjectAndBody)
        XCTAssertFalse(testSubject.fail)
        XCTAssertFalse(BodyEmptyLine.fail(commitSubjectAndBody))
    }

    func testSuccessSubjectOnly() {
        let testSubject = BodyEmptyLine(commitSubjectOnly)
        XCTAssertFalse(testSubject.fail)
        XCTAssertFalse(BodyEmptyLine.fail(commitSubjectOnly))
    }

    func testFailureNoNewlineOnly() {
        let testSubject = BodyEmptyLine(commitNoNewline)
        XCTAssertTrue(testSubject.fail)
        XCTAssertTrue(BodyEmptyLine.fail(commitNoNewline))
    }
}
