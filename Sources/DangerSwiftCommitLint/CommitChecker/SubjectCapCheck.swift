import Foundation

struct SubjectCapCheck: CommitChecker, Hashable {
    static let checkerMessage = "Please start commit message subject with capital letter."

    private let firstCharacter: Character?

    init(_ commitMessage: CommitMessage) {
        firstCharacter = commitMessage.subject.first
    }

    var fail: Bool {
        firstCharacter?.isLowercase ?? false
    }
}
