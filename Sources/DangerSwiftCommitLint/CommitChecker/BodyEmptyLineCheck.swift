import Foundation

struct BodyEmptyLineCheck: CommitChecker {
    static var warningMessage = "Please separate commit message subject from body with newline."

    private let bodyLinesOfText: [String]

    init(message: CommitMessage) {
        bodyLinesOfText = message.bodyLinesOfText
    }

    var fail: Bool {
        bodyLinesOfText.isEmpty ? false : bodyLinesOfText.first?.isEmpty == false
    }
}
