import Danger
import Foundation

struct CommitMessage: Hashable {
    /// First line of the commit message
    let subject: String
    /// Rest of the commit message
    let bodyLinesOfText: [String]
    // Commit SHA value
    let sha: String

    init(
        subject: String,
        bodyLinesOfText: [String],
        sha: String
    ) {
        self.subject = subject
        self.bodyLinesOfText = bodyLinesOfText
        self.sha = sha
    }

    init(_ commit: GitHub.Commit) {
        let commitMessageLines = commit.commit.message.components(separatedBy: .newlines)
        subject = commitMessageLines.first ?? ""
        bodyLinesOfText = Array(commitMessageLines.dropFirst())
        sha = commit.sha
    }
}
