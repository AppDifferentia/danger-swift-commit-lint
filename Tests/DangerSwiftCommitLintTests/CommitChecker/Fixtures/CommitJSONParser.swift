import Danger
import Foundation

enum CommitParser {
    static func parseCommitJSON(with commitJSON: String) -> GitHub.Commit {
        let data = Data(commitJSON.utf8)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(DateFormatter.dateFormatterHandler)
        return try! decoder.decode(GitHub.Commit.self, from: data) // swiftlint:disable:this force_try
    }
}
