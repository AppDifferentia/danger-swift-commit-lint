import Danger
import Foundation

/// A protocol for dependency inject `DangerDSL`.
/// - `DangerSwiftCommitLint` only require these interfaces.
public protocol DangerDSLProviding {
    var git: Git { get }

    func warn(_ message: String)
    func fail(_ message: String)
}

extension DangerDSL: DangerDSLProviding {}

/// A Danger-Swift plugin to lint each commit in the PR. See `Configuration` for linter configuration.
public final class DangerSwiftCommitLint {
    private enum Constants {
        static let disableAllChecksMessage = "All checks were disabled, nothing to do."
    }

    private let danger: DangerDSLProviding
    private var configuration: Configuration!

    /// Initialize an instance of the linter
    /// - Parameters:
    ///   - danger: An instance of `Danger.DangerDSL`.
    ///   - configuration: Linter configuration.
    public init(danger: DangerDSLProviding = Danger(), configuration: Configuration = .init()) {
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

private extension DangerSwiftCommitLint {
    var commitMessages: [GitCommitMessage] {
        let messages = danger.git.commits.map { GitCommitMessage($0) }
        guard configuration.limit > 0 else {
            return messages
        }

        return Array(messages.suffix(configuration.limit))
    }

    func checkMessages() {
        // Checkers that warn the danger job.
        configuration.warningCheckers.checkCommitMessages(commitMessages, checkerResultHandler: warning(_:shas:))

        // Checkers that fail the danger job.
        configuration.failingCheckers.checkCommitMessages(commitMessages, checkerResultHandler: failing(_:shas:))
    }

    func warning(_ message: String, shas: [String]) {
        let warningMessage = ([message] + shas).joined(separator: "\n")
        danger.warn(warningMessage)
    }

    func failing(_ message: String, shas: [String]) {
        let failingMessage = ([message] + shas).joined(separator: "\n")
        danger.fail(failingMessage)
    }
}

private extension Array where Element == CommitLint.Type {
    func checkCommitMessages(_ commitMessages: [GitCommitMessage], checkerResultHandler: (String, [String]) -> Void) {
        forEach { checker in
            let shas = commitMessages.compactMap { checker.fail($0) ? $0.sha : nil }
            if shas.isEmpty == false {
                checkerResultHandler(checker.linterMessage, shas)
            }
        }
    }
}
