import Foundation

struct SubjectPeriodCheck: CommitChecker {
    static var warningMessage = "Please remove period from end of commit message subject line."

    private let subject: String

    init(message: CommitMessage) {
        subject = message.subject
    }

    var fail: Bool {
        subject.last == "."
    }
}
