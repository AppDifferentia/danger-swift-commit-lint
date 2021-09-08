import Foundation

struct SubjectPeriod: CommitLint, Hashable {
    static var linterMessage = "Please remove period from end of commit message subject line."

    private let subject: String

    init(_ commitMessage: GitCommitMessage) {
        subject = commitMessage.subject
    }

    var fail: Bool {
        subject.last == "."
    }
}
