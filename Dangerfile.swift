import Danger
import DangerSwiftCommitLint
import Foundation

let danger = Danger()

if danger.git.createdFiles.count + danger.git.modifiedFiles.count - danger.git.deletedFiles.count > 300 {
    warn("Big PR, try to keep changes smaller if you can")
}

let swiftFilesWithCopyright = danger.git.createdFiles.filter {
    $0.fileType == .swift && danger.utils.readFile($0).contains("//  Created by")
}

if swiftFilesWithCopyright.isEmpty == false {
    let files = swiftFilesWithCopyright.joined(separator: ", ")
    warn("In DangerSwiftCommitLint we don't include copyright headers, found them in: \(files)")
}

let filesToLint = (danger.git.modifiedFiles + danger.git.createdFiles)
    .filter { URL(fileURLWithPath: $0).pathExtension == "swift" }

SwiftLint.lint(.files(filesToLint), inline: true)

let configuration = DangerSwiftCommitLint.Configuration(warn: .all)
let commitLint = DangerSwiftCommitLint(danger: danger, configuration: configuration)
commitLint.check()

// Only run GitHub related checks when GitHub dsl is available. This allows `danger-swift local` to work.
guard let github = danger.github else {
    warn("Unable to parse GitHub DSL response, the GitHub related checks will be skipped. (i.e. running `danger-swift local`).")
    exit(0)
}

// These checks only happen on a PR
let foundWIPMessageInTitle = github.pullRequest.title.contains("Work In Progress")
    || github.pullRequest.title.contains("WIP")
let foundWIPLabel = github.issue.labels.contains {
    $0.name.contains("Work In Progress")
}

if foundWIPMessageInTitle || foundWIPLabel {
    warn("PR is classed as Work in Progress")
}
