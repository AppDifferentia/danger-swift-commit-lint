import Danger
@testable import DangerSwiftCommitLint
import XCTest

final class CommitMessageTests: XCTestCase {
    func testInitializeWithDangerGitHubCommit() {
        let commit = CommitParser.parseCommitJSON(with: commitMessageJSON)
        let expectedCommitMessage = commit.commit.message.components(separatedBy: .newlines)
        let testSubject = CommitMessage(commit)
        XCTAssertEqual(testSubject.sha, commit.sha)
        XCTAssertEqual(
            [
                [testSubject.subject],
                testSubject.bodyLinesOfText,
            ]
            .flatMap { $0 },
            expectedCommitMessage
        )
    }
}
