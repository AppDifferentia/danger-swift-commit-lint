import Foundation

infix operator =~: RegularExpressionPrecedence
precedencegroup RegularExpressionPrecedence {
    associativity: none
    higherThan: AdditionPrecedence
    lowerThan: MultiplicationPrecedence
}

func =~ (input: String, regexPattern: String) -> Bool {
    do {
        return try RegexHelper(regexPattern).match(input)
    } catch {
        return false
    }
}

private struct RegexHelper {
    private let regex: NSRegularExpression

    init(_ pattern: String) throws {
        regex = try NSRegularExpression(pattern: pattern, options: [])
    }

    func match(_ input: String) -> Bool {
        regex.matches(
            in: input,
            options: [],
            range: NSRange(location: 0, length: input.utf16.count)
        )
        .count > 0
    }
}
