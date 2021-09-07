import Foundation

struct SubjectPeriodCheck: CommitChecker, Hashable {
    static var checkerMessage = "Please remove period from end of commit message subject line."

    private let subject: String

    init(_ commitMessage: CommitMessage) {
        subject = commitMessage.subject
    }

    var fail: Bool {
        subject.last == "."
    }
}
