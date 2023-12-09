import Foundation
import Parsing
import RegexBuilder

struct Day02: AdventDay {
    var data: Data
    
    var games: [Int: Game] {
        Dictionary(uniqueKeysWithValues:
            try! data.substrings().map {
                var line = $0.utf8
                return try parser.parse(&line)
            }
        )
    }

    func part1() throws -> Any {
        games.reduce(0) { $0 + ($1.value.isImpossible ? 0 : $1.key) }
    }

    func part2() throws -> Any {
        games.values.map(\.power).reduce(0, +)
    }
}

struct Grab {
    var red = 0, green = 0, blue = 0
}
struct Game {
    let grabs: [Grab]

    var isImpossible: Bool {
        grabs.contains {
            $0.red > 12 || $0.green > 13 || $0.blue > 14
        }
    }

    var power: Int {
        var red = 0, green = 0, blue = 0
        for grab in grabs {
            red = max(red, grab.red)
            green = max(green, grab.green)
            blue = max(blue, grab.blue)
        }
        return red * green * blue
    }
}

let parser = Parse(input: Substring.UTF8View.self) {
    "Game ".utf8; Int.parser(); ": ".utf8
    Many {
        Many {
            Int.parser()
            " ".utf8
            OneOf {
                "red".utf8.map { \Grab.red }
                "green".utf8.map { \Grab.green }
                "blue".utf8.map { \Grab.blue }
            }
        } separator: {
            ", ".utf8
        }.map {
            $0.reduce(into: Grab()) { out, pair in
                out[keyPath: pair.1] += pair.0
            }
        }
    } separator: {
        "; ".utf8
    }.map(Game.init)
}
