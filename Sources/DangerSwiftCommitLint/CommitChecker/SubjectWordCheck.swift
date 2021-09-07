import Foundation

struct SubjectWordCheck: CommitChecker {
    static var warningMessage = "Please use more than one word in commit message."

    private let subject: String

    init(message: CommitMessage) {
        subject = message.subject
    }

    var fail: Bool {
        subject.split(separator: " ").count < 2
    }
}
