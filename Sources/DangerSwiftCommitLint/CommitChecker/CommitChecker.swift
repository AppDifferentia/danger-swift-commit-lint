import Foundation

public protocol CommitChecker {
    static var checkerMessage: String { get }

    var fail: Bool { get }

    init(_ commitMessage: CommitMessage)

    static func fail(_ commitMessage: CommitMessage) -> Bool
}

public extension CommitChecker {
    static func fail(_ commitMessage: CommitMessage) -> Bool {
        Self(commitMessage).fail
    }
}
