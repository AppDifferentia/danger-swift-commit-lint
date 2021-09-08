# Commit Lint For Danger-Swift

[![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE)

A [`danger-swift`](https://github.com/danger/swift) plugin to check each commit messages on the branch. This project is inspired by [`danger-commit-lint`](https://github.com/jonallured/danger-commit_lint) and its commit linting rules are ported too.

## Installation

Add `DangerSwiftCommitLint` to your `Package.file`
```Swift
.package(url: "https://github.com/AppDifferentia/danger-swift-commit-lint", from: "0.0.1")
```

## Usage

Simply add the following lines to your `Dangerfile.swift`

```Swift
import Danger

let danger = Danger()

//...

let commitLint = DangerSwiftCommitLint(danger: danger)
commitLint.check()
```

That will check each commit in the PR to ensure the following is true:

- Commit subject begins with a capital letter ([`SubjectCapitalLetter.swift`](Sources/DangerSwiftCommitLint/CommitLint/SubjectCapitalLetter.swift))
- Commit subject is more than one word ([`SubjectWord.swift`](Sources/DangerSwiftCommitLint/CommitLint/SubjectWord.swift))
- Commit subject is no longer than 50 characters ([`SubjectLength.swift`](Sources/DangerSwiftCommitLint/CommitLint/SubjectLength.swift))
- Commit subject does not end in a period ([`SubjectPeriod.swift`](Sources/DangerSwiftCommitLint/CommitLint/SubjectPeriod.swift))
- Commit subject and body are separated by an empty line ([`BodyEmptyLine.swift`](Sources/DangerSwiftCommitLint/CommitLint/BodyEmptyLine.swift))

By default, Commit Lint fails, but you can configure this behavior.

E.g.

```Swift
import Danger

let danger = Danger()

//...

let configuration = DangerSwiftCommitLint.Configuration(warn: .all)
let commitLint = DangerSwiftCommitLint(danger: danger, configuration: configuration)
commitLint.check()
```

## Configuration

The commit lint can be configured with following 5 parameters.

- `disabled`: can be `.all` or `.selected([ ... ])`, see [`Configuration.swift`](Sources/DangerSwiftCommitLint/Configuration.swift)
- `warn`: can be `.all` or `.selected([ ... ])`, see [`Configuration.swift`](Sources/DangerSwiftCommitLint/Configuration.swift)
- `fail`: can be `.all` or `.selected([ ... ])`, see [`Configuration.swift`](Sources/DangerSwiftCommitLint/Configuration.swift)
- `limit`: limits the number commits to lint. E.g. `limit: 1` will limit the commit to the oldest commit on the branch
- `custom`: allow caller to pass an array of custom linter that conforms to [`CommitLint`](Sources/DangerSwiftCommitLint/CommitLint/CommitLint.swift) protocol

E.g.

```Swift
struct Configuration {

    init(
        disabled: CommitLintSelection = .selected([]),
        warn: CommitLintSelection = .selected([]),
        fail: CommitLintSelection = .all,
        limit: Int = 0,
        custom: [CommitLint.Type] = []
    ) {
        // ...
    }

}
```
