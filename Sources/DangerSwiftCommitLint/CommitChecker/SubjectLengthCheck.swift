import Foundation

struct SubjectLengthCheck: CommitChecker {
    private enum GeneratedSubjectPattern {
        static let git = #"^Merge branch '.+' into "#
        static let gitHub = #"^Merge pull request #\d+ from "#
    }

    static let warningMessage = "Please limit commit message subject line to 50 characters."

    private let subject: String

    init(message: CommitMessage) {
        subject = message.subject
    }

    var fail: Bool {
        subject.count > 50 && isMergeCommit == false
    }
}

private extension SubjectLengthCheck {
    var isMergeCommit: Bool {
        subject =~ GeneratedSubjectPattern.git || subject =~ GeneratedSubjectPattern.gitHub
    }
}