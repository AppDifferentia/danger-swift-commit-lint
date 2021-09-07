import Foundation

public protocol CommitChecker {
    static var checkerMessage: String { get }

    var fail: Bool { get }

    init(_ commitMessage: GitCommitMessage)

    static func fail(_ commitMessage: GitCommitMessage) -> Bool
}

public extension CommitChecker {
    static func fail(_ commitMessage: GitCommitMessage) -> Bool {
        Self(commitMessage).fail
    }
}
