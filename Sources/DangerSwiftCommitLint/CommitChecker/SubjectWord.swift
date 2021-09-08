import Foundation

struct SubjectWord: CommitLint, Hashable {
    static var linterMessage = "Please use more than one word in commit message."

    private let subject: String

    init(_ commitMessage: GitCommitMessage) {
        subject = commitMessage.subject
    }

    var fail: Bool {
        subject.split(separator: " ").count < 2
    }
}
