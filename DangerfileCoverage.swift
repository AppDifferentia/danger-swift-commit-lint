import Danger
import DangerSwiftCoverage
import Foundation

let danger = Danger()

if FileManager.default.fileExists(atPath: ".build/debug/codecov") {
    Coverage.spmCoverage(minimumCoverage: 60)
} else {
    warn("Cannot find SPM code coverage report, please run `swift test --enable-code-coverage` before danger.")
}
