import Danger
import Foundation

enum CommitParser {
    static func parseGitCommit(with json: String) -> Git.Commit {
        decodeJSON(with: json, type: Git.Commit.self)
    }

    static func parseGit(with json: String) -> Git {
        decodeJSON(with: json, type: Git.self)
    }

    private static func decodeJSON<T: Decodable>(with jsonContent: String, type: T.Type) -> T {
        let data = Data(jsonContent.utf8)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(DateFormatter.dateFormatterHandler)
        return try! decoder.decode(type, from: data) // swiftlint:disable:this force_try
    }
}
