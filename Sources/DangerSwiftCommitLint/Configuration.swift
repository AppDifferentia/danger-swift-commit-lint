import Foundation

public extension DangerSwiftCommitLint {
    struct Configuration {
        /// All commit checkers provided by `DangerSwiftCommitLint`
        public enum CommitCheckerType: CaseIterable, Hashable {
            /// Commit subject and body are separated by an empty line (`CommitChecker/BodyEmptyLineCheck`)
            case bodyEmptyLine
            /// Commit subject begins with a capital letter (`CommitChecker/SubjectCapCheck`)
            case subjectCapCheck
            /// Commit subject is no longer than 50 characters (`CommitChecker/SubjectLengthCheck`)
            case subjectLengthCheck
            /// Commit subject does not end in a period (`CommitChecker/SubjectPeriodCheck`)
            case subjectPeriodCheck
            /// Commit subject is more than one word (`CommitChecker/SubjectWordCheck`)
            case subjectWordCheck
        }

        /// Checker selection
        public enum CommitCheckerSelection {
            /// Select all checkers
            case all
            /// Select a set of checkers
            case selected(Set<CommitCheckerType>)
        }

        private let disabled: CommitCheckerSelection
        private let warn: CommitCheckerSelection
        private let fail: CommitCheckerSelection
        let limit: Int
        private let customCheckers: [CommitChecker.Type]

        /// Initialize the configuraiton.
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
            customCheckers: [CommitChecker.Type] = []
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
    static var defaultCheckers: [CommitChecker.Type] {
        CommitCheckerType.allCases.map(\.type)
    }

    var allCheckers: [CommitChecker.Type] {
        Self.defaultCheckers + customCheckers
    }

    var disabledCheckers: [CommitChecker.Type] {
        switch disabled {
        case .all:
            return allCheckers
        case let .selected(disabled):
            return disabled.map(\.type)
        }
    }

    var enabledCheckers: [CommitChecker.Type] {
        allCheckers.filter { checker in
            disabledCheckers.contains { $0 == checker } == false
        }
    }

    var warningCheckers: [CommitChecker.Type] {
        switch warn {
        case .all:
            return allCheckers
        case let .selected(warningCheckers):
            return enabledCheckers.filter { type in
                warningCheckers.map(\.type).contains { $0 == type }
            }
        }
    }

    var failingCheckers: [CommitChecker.Type] {
        enabledCheckers.filter { type in
            warningCheckers.contains { $0 == type } == false
        }
    }
}

private extension DangerSwiftCommitLint.Configuration.CommitCheckerType {
    var type: CommitChecker.Type {
        switch self {
        case .bodyEmptyLine: return BodyEmptyLineCheck.self
        case .subjectCapCheck: return SubjectCapCheck.self
        case .subjectLengthCheck: return SubjectCapCheck.self
        case .subjectPeriodCheck: return SubjectPeriodCheck.self
        case .subjectWordCheck: return SubjectWordCheck.self
        }
    }
}
