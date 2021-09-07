import Foundation

struct SubjectWordCheck: CommitChecker, Hashable {
    static var checkerMessage = "Please use more than one word in commit message."

    private let subject: String

    init(_ commitMessage: GitCommitMessage) {
        subject = commitMessage.subject
    }

    var fail: Bool {
        subject.split(separator: " ").count < 2
    }
}
