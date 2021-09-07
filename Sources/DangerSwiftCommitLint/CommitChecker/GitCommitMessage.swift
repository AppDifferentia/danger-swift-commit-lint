import Danger
import Foundation

/// An abstraction of Git commit message for `DangerSwiftCommitLint`.
public struct GitCommitMessage: Hashable {
    /// First line of the commit message
    public let subject: String
    /// Rest of the commit message
    public let bodyLinesOfText: [String]
    // Commit SHA value
    public let sha: String?

    init(
        subject: String,
        bodyLinesOfText: [String],
        sha: String
    ) {
        self.subject = subject
        self.bodyLinesOfText = bodyLinesOfText
        self.sha = sha
    }

    /// Initialize `GitCommitMessage` with `Danger.Git.Commit.message`
    /// - Parameter gitCommit: An instance of `Danger.Git.Commit`
    public init(_ gitCommit: Git.Commit) {
        let commitMessageLines = gitCommit.message.components(separatedBy: .newlines)
        subject = commitMessageLines.first ?? ""
        bodyLinesOfText = Array(commitMessageLines.dropFirst())
        sha = gitCommit.sha
    }
}
