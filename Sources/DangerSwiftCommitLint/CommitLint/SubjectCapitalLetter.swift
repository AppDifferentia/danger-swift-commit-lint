import Foundation

struct SubjectCapitalLetter: CommitLint, Hashable {
    static let linterMessage = "Please start commit message subject with capital letter."

    private let firstCharacter: Character?

    init(_ commitMessage: GitCommitMessage) {
        firstCharacter = commitMessage.subject.first
    }

    var fail: Bool {
        firstCharacter?.isLowercase ?? false
    }
}
