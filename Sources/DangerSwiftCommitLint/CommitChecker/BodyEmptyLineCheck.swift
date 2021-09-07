import Foundation

struct BodyEmptyLineCheck: CommitChecker, Hashable {
    static var checkerMessage = "Please separate commit message subject from body with newline."

    private let bodyLinesOfText: [String]

    init(_ commitMessage: GitCommitMessage) {
        bodyLinesOfText = commitMessage.bodyLinesOfText
    }

    var fail: Bool {
        bodyLinesOfText.isEmpty ? false : bodyLinesOfText.first?.isEmpty == false
    }
}
