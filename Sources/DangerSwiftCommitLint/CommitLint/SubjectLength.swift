import Foundation

struct SubjectLength: CommitLint, Hashable {
    private enum GeneratedSubjectPattern {
        static let git = #"^Merge branch '.+' into "#
        static let gitHub = #"^Merge pull request #\d+ from "#
    }

    static let linterMessage = "Please limit commit message subject line to 50 characters."

    private let subject: String

    init(_ commitMessage: GitCommitMessage) {
        subject = commitMessage.subject
    }

    var fail: Bool {
        subject.count > 50 && isMergeCommit == false
    }
}

private extension SubjectLength {
    var isMergeCommit: Bool {
        subject =~ GeneratedSubjectPattern.git || subject =~ GeneratedSubjectPattern.gitHub
    }
}
