import Foundation
import Parsing

extension Data {
    func parseLines<Output>(_ parser: any Parser<Substring.UTF8View, Output>) throws -> [Output] {
        try substrings().map {
            var line = $0.utf8
            return try parser.parse(&line)
        }
    }
    
    func parse<Output>(_ parser: any Parser<Substring.UTF8View, Output>) throws -> Output {
        var utf8 = utf8view()
        return try parser.parse(&utf8)
    }
}
