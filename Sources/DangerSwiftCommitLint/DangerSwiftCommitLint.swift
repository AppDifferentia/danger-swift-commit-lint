import Danger
import Foundation

public final class DangerSwiftCommitLint {
    private enum Constants {
        static let disableAllChecksMessage = "All checks were disabled, nothing to do."
    }

    private let danger: DangerDSL
    private var configuration: Configuration!

    /// Initialize an instance of the linter
    /// - Parameters:
    ///   - danger: An instance of `Danger.DangerDSL`.
    ///   - configuration: Linter configuration.
    init(danger: DangerDSL = Danger(), configuration: Configuration) {
        self.danger = danger
        self.configuration = configuration
    }

    /// Lints the PR commits.
    public func check() {
        if configuration.enabledCheckers.isEmpty {
            danger.warn(Constants.disableAllChecksMessage)
        } else {
            checkMessages()
        }
    }
}

extension DangerSwiftCommitLint {
    var commitMessages: [GitCommitMessage] {
        let messages = danger.git.commits.map { GitCommitMessage($0) }
        guard configuration.limit > 0 else {
            return messages
        }

        return Array(messages.suffix(configuration.limit))
    }

    func checkMessages() {
        // Checkers that warn the danger job.
        configuration.warningCheckers.checkCommitMessages(commitMessages, checkerResultHanler: warning(_:shas:))

        // Checkers that fail the danger job.
        configuration.failingCheckers.checkCommitMessages(commitMessages, checkerResultHanler: failing(_:shas:))
    }

    func warning(_ message: String, shas: [String]) {
        let warningMessage = ([message] + shas).joined(separator: "\n")
        danger.warn(warningMessage)
    }

    func failing(_ message: String, shas: [String]) {
        let failingMessage = ([message] + shas).joined(separator: "\n")
        danger.warn(failingMessage)
    }
}

extension Array where Element == CommitChecker.Type {
    func checkCommitMessages(_ commitMessages: [GitCommitMessage], checkerResultHanler: (String, [String]) -> Void) {
        forEach { checker in
            let shas = commitMessages.compactMap { checker.fail($0) ? $0.sha : nil }
            if shas.isEmpty == false {
                checkerResultHanler(checker.checkerMessage, shas)
            }
        }
    }
}
