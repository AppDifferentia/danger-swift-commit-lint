import Foundation

public protocol CommitLint {
    static var linterMessage: String { get }

    var fail: Bool { get }

    init(_ commitMessage: GitCommitMessage)

    static func fail(_ commitMessage: GitCommitMessage) -> Bool
}

public extension CommitLint {
    static func fail(_ commitMessage: GitCommitMessage) -> Bool {
        Self(commitMessage).fail
    }
}
