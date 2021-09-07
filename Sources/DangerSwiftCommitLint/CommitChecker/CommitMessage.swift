import Danger
import Foundation

/// An abstraction of GitHub commit message.
public struct CommitMessage: Hashable {
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

    /// Initialize CommitMessage with `Danger.GitHub.Commit.CommitData.message`.
    /// - Parameter commit: An instance of `GitHub.Commit`
    public init(_ commit: GitHub.Commit) {
        let commitMessageLines = commit.commit.message.components(separatedBy: .newlines)
        subject = commitMessageLines.first ?? ""
        bodyLinesOfText = Array(commitMessageLines.dropFirst())
        sha = commit.sha
    }

    /// Initialize `CommitMessage` with `Danger.Git.Commit.message`
    /// - Parameter gitCommit: An instance of `Danger.Git.Commit`
    public init(_ gitCommit: Git.Commit) {
        let commitMessageLines = gitCommit.message.components(separatedBy: .newlines)
        subject = commitMessageLines.first ?? ""
        bodyLinesOfText = Array(commitMessageLines.dropFirst())
        sha = gitCommit.sha
    }
}
