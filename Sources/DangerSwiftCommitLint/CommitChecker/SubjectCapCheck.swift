import Foundation

struct SubjectCapCheck: CommitChecker {
    static let warningMessage = "Please start commit message subject with capital letter."

    private let firstCharacter: Character?

    init(message: CommitMessage) {
        firstCharacter = message.subject.first
    }

    var fail: Bool {
        firstCharacter?.isLowercase ?? false
    }
}
