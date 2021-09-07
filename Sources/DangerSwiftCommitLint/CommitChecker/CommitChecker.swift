import Foundation

protocol CommitChecker: Hashable {
    static var warningMessage: String { get }
    var fail: Bool { get }

    init(message: CommitMessage)

    static func fail(message: CommitMessage) -> Bool
}

extension CommitChecker {
    static func fail(message: CommitMessage) -> Bool {
        Self(message: message).fail
    }
}
