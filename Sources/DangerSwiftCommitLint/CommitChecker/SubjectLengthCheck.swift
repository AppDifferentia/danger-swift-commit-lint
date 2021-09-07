import Foundation

struct SubjectLengthCheck: CommitChecker, Hashable {
    private enum GeneratedSubjectPattern {
        static let git = #"^Merge branch '.+' into "#
        static let gitHub = #"^Merge pull request #\d+ from "#
    }

    static let checkerMessage = "Please limit commit message subject line to 50 characters."

    private let subject: String

    init(_ commitMessage: GitCommitMessage) {
        subject = commitMessage.subject
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
