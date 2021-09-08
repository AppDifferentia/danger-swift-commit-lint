import Foundation

public extension DangerSwiftCommitLint {
    /// All commit checkers provided by `DangerSwiftCommitLint`
    enum CommitLintType: CaseIterable, Hashable {
        /// Commit subject and body are separated by an empty line (`CommitLint/BodyEmptyLineCheck`)
        case bodyEmptyLine
        /// Commit subject begins with a capital letter (`CommitLint/SubjectCapCheck`)
        case subjectCapitalLetter
        /// Commit subject is no longer than 50 characters (`CommitLint/SubjectLengthCheck`)
        case subjectLength
        /// Commit subject does not end in a period (`CommitLint/SubjectPeriodCheck`)
        case subjectPeriod
        /// Commit subject is more than one word (`CommitLint/SubjectWordCheck`)
        case subjectWord
    }

    /// Checker selection
    enum CommitLintSelection {
        /// Select all checkers
        case all
        /// Select a set of checkers
        case selected(Set<CommitLintType>)
    }

    /// Configuration for `DangerSwiftCommitLint`
    struct Configuration {
        let limit: Int

        private let disabled: CommitLintSelection
        private let warn: CommitLintSelection
        private let fail: CommitLintSelection
        private let custom: [CommitLint.Type]

        /// Initialize the configuration.
        /// - Parameters:
        ///   - disabled: The selected commit lint to skip.
        ///   - warn: The selected commit lint to warn on.
        ///   - fail: The selected commit lint to fail on.
        ///   - limit: The number of commits to check.
        ///   - customCheckers: An array of custom checkers. This array will be added to all checkers.
        public init(
            disabled: CommitLintSelection = .selected([]),
            warn: CommitLintSelection = .selected([]),
            fail: CommitLintSelection = .all,
            limit: Int = 0,
            custom: [CommitLint.Type] = []
        ) {
            self.disabled = disabled
            self.warn = warn
            self.fail = fail
            self.limit = limit
            self.custom = custom
        }
    }
}

extension DangerSwiftCommitLint.Configuration {
    static var defaultCheckers: [CommitLint.Type] {
        DangerSwiftCommitLint.CommitLintType.allCases.map(\.type)
    }

    var allCheckers: [CommitLint.Type] {
        Self.defaultCheckers + custom
    }

    var disabledCheckers: [CommitLint.Type] {
        switch disabled {
        case .all:
            return allCheckers
        case let .selected(disabled):
            return disabled.map(\.type)
        }
    }

    var enabledCheckers: [CommitLint.Type] {
        allCheckers.filter { checker in
            disabledCheckers.contains { $0 == checker } == false
        }
    }

    var warningCheckers: [CommitLint.Type] {
        switch warn {
        case .all:
            return allCheckers
        case let .selected(warningCheckers):
            return enabledCheckers.filter { type in
                warningCheckers.map(\.type).contains { $0 == type }
            }
        }
    }

    var failingCheckers: [CommitLint.Type] {
        enabledCheckers.filter { type in
            warningCheckers.contains { $0 == type } == false
        }
    }
}

private extension DangerSwiftCommitLint.CommitLintType {
    var type: CommitLint.Type {
        switch self {
        case .bodyEmptyLine: return BodyEmptyLine.self
        case .subjectCapitalLetter: return SubjectCapitalLetter.self
        case .subjectLength: return SubjectCapitalLetter.self
        case .subjectPeriod: return SubjectPeriod.self
        case .subjectWord: return SubjectWord.self
        }
    }
}
