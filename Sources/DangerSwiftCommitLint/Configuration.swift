import Foundation

public extension DangerSwiftCommitLint {
    /// All commit checkers provided by `DangerSwiftCommitLint`
    enum CommitCheckerType: CaseIterable, Hashable {
        /// Commit subject and body are separated by an empty line (`CommitChecker/BodyEmptyLineCheck`)
        case bodyEmptyLine
        /// Commit subject begins with a capital letter (`CommitChecker/SubjectCapCheck`)
        case subjectCapitalLetter
        /// Commit subject is no longer than 50 characters (`CommitChecker/SubjectLengthCheck`)
        case subjectLength
        /// Commit subject does not end in a period (`CommitChecker/SubjectPeriodCheck`)
        case subjectPeriod
        /// Commit subject is more than one word (`CommitChecker/SubjectWordCheck`)
        case subjectWord
    }

    /// Checker selection
    enum CommitCheckerSelection {
        /// Select all checkers
        case all
        /// Select a set of checkers
        case selected(Set<CommitCheckerType>)
    }

    struct Configuration {
        let limit: Int

        private let disabled: CommitCheckerSelection
        private let warn: CommitCheckerSelection
        private let fail: CommitCheckerSelection
        private let customCheckers: [CommitLint.Type]

        /// Initialize the configuration.
        /// - Parameters:
        ///   - disabled: The selected checks to skip.
        ///   - warn: The selected checks to warn on.
        ///   - fail: The selected checks to fail on.
        ///   - limit: The number of commits to check.
        ///   - customCheckers: An array of custom checkers.
        public init(
            disabled: CommitCheckerSelection = .selected([]),
            warn: CommitCheckerSelection = .selected([]),
            fail: CommitCheckerSelection = .all,
            limit: Int = 0,
            customCheckers: [CommitLint.Type] = []
        ) {
            self.disabled = disabled
            self.warn = warn
            self.fail = fail
            self.limit = limit
            self.customCheckers = customCheckers
        }
    }
}

extension DangerSwiftCommitLint.Configuration {
    static var defaultCheckers: [CommitLint.Type] {
        DangerSwiftCommitLint.CommitCheckerType.allCases.map(\.type)
    }

    var allCheckers: [CommitLint.Type] {
        Self.defaultCheckers + customCheckers
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

private extension DangerSwiftCommitLint.CommitCheckerType {
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
