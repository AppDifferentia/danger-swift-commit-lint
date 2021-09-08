import Danger
@testable import DangerSwiftCommitLint
import XCTest

final class DangerSwiftCommitLintTests: XCTestCase {
    typealias Configuration = DangerSwiftCommitLint.Configuration

    func testGitCommitWithNoIssues() {
        let git = CommitParser.parseGit(with: gitJSON)
        let mockDanger = MockDangerDSL(git: git)
        let configuration = Configuration(warn: .all)
        let testSubject = DangerSwiftCommitLint(danger: mockDanger, configuration: configuration)
        testSubject.check()
        XCTAssertTrue(mockDanger.warningMessages.isEmpty)
        XCTAssertTrue(mockDanger.failingMessages.isEmpty)
    }

    func testDisableAllChecks() {
        let git = CommitParser.parseGit(with: gitJSON)
        let mockDanger = MockDangerDSL(git: git)
        let configuration = Configuration(disabled: .all)
        let testSubject = DangerSwiftCommitLint(danger: mockDanger, configuration: configuration)
        testSubject.check()
        XCTAssertEqual(mockDanger.warningMessages, ["All checks were disabled, nothing to do."])
        XCTAssertTrue(mockDanger.failingMessages.isEmpty)
    }

    func testDisableAllHasHighestPrecedence() {
        let git = CommitParser.parseGit(with: gitIssuesOnLastTwoCommitsJSON)
        let mockDanger = MockDangerDSL(git: git)
        let configuration = Configuration(disabled: .all, warn: .all, fail: .all)
        let testSubject = DangerSwiftCommitLint(danger: mockDanger, configuration: configuration)
        testSubject.check()
        XCTAssertEqual(mockDanger.warningMessages, ["All checks were disabled, nothing to do."])
        XCTAssertTrue(mockDanger.failingMessages.isEmpty)
    }

    func testWarnAllIssues() {
        let git = CommitParser.parseGit(with: gitIssuesOnLastTwoCommitsJSON)
        let mockDanger = MockDangerDSL(git: git)
        let configuration = Configuration(warn: .all)
        let testSubject = DangerSwiftCommitLint(danger: mockDanger, configuration: configuration)
        testSubject.check()
        XCTAssertEqual(
            mockDanger.warningMessages,
            [
                "Please separate commit message subject from body with newline.\ntestshacommit3",
                "Please start commit message subject with capital letter.\ntestshacommit3",
                "Please start commit message subject with capital letter.\ntestshacommit3",
                "Please remove period from end of commit message subject line.\ntestshacommit3",
                "Please use more than one word in commit message.\ntestshacommit4",
            ]
        )
        XCTAssertTrue(mockDanger.failingMessages.isEmpty)
    }

    func testFailAllIssues() {
        let git = CommitParser.parseGit(with: gitIssuesOnLastTwoCommitsJSON)
        let mockDanger = MockDangerDSL(git: git)
        let configuration = Configuration(fail: .all)
        let testSubject = DangerSwiftCommitLint(danger: mockDanger, configuration: configuration)
        testSubject.check()
        XCTAssertTrue(mockDanger.warningMessages.isEmpty)
        XCTAssertEqual(
            mockDanger.failingMessages,
            [
                "Please separate commit message subject from body with newline.\ntestshacommit3",
                "Please start commit message subject with capital letter.\ntestshacommit3",
                "Please start commit message subject with capital letter.\ntestshacommit3",
                "Please remove period from end of commit message subject line.\ntestshacommit3",
                "Please use more than one word in commit message.\ntestshacommit4",
            ]
        )
    }

    func testLimitingTheCheckToTwoCommits() {
        let git = CommitParser.parseGit(with: gitIssuesOnLastTwoCommitsJSON)
        let mockDanger = MockDangerDSL(git: git)
        let configuration = Configuration(warn: .all, limit: 2)
        let testSubject = DangerSwiftCommitLint(danger: mockDanger, configuration: configuration)
        testSubject.check()
        XCTAssertTrue(mockDanger.warningMessages.isEmpty)
        XCTAssertTrue(mockDanger.failingMessages.isEmpty)
    }

    func testMixedConfiguration() {
        let git = CommitParser.parseGit(with: gitIssuesOnLastTwoCommitsJSON)
        let mockDanger = MockDangerDSL(git: git)
        let configuration = Configuration(
            disabled: .selected(Set<DangerSwiftCommitLint.CommitCheckerType>([.bodyEmptyLine])),
            warn: .selected(Set<DangerSwiftCommitLint.CommitCheckerType>([.subjectPeriod, .subjectWord])),
            fail: .all
        )
        let testSubject = DangerSwiftCommitLint(danger: mockDanger, configuration: configuration)
        testSubject.check()
        XCTAssertEqual(
            mockDanger.warningMessages,
            [
                "Please remove period from end of commit message subject line.\ntestshacommit3",
                "Please use more than one word in commit message.\ntestshacommit4",
            ]
        )
        XCTAssertEqual(
            mockDanger.failingMessages,
            [
                "Please start commit message subject with capital letter.\ntestshacommit3",
                "Please start commit message subject with capital letter.\ntestshacommit3",
            ]
        )
    }

    func testCustomChecker() {
        let git = CommitParser.parseGit(with: gitJSON)
        let mockDanger = MockDangerDSL(git: git)
        let configuration = Configuration(warn: .all, customCheckers: [MockChecker.self])
        let testSubject = DangerSwiftCommitLint(danger: mockDanger, configuration: configuration)
        testSubject.check()
        XCTAssertEqual(mockDanger.warningMessages, ["\(MockChecker.linterMessage)\ntestshacommit3\ntestshacommit2\ntestshacommit1"])
        XCTAssertTrue(mockDanger.failingMessages.isEmpty)
    }
}

private class MockChecker: CommitLint {
    static let linterMessage: String = "Mock Checker Message."

    required init(_: GitCommitMessage) {
        // Intentionally left empty.
    }

    var fail: Bool = true
}

private class MockDangerDSL: DangerDSLProviding {
    var warningMessages: [String] = []
    var failingMessages: [String] = []

    let git: Git

    init(git: Git) {
        self.git = git
    }

    func warn(_ message: String) {
        warningMessages.append(message)
    }

    func fail(_ message: String) {
        failingMessages.append(message)
    }
}
