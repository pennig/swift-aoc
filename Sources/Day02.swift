import Foundation
import Parsing

struct Day02: AdventDay {
    var data: Data

    init(data: Data) {
        self.data = data
    }

    var games: [Int: Game] {
        Dictionary(uniqueKeysWithValues:
            try! data.substrings().map {
                var line = $0.utf8
                return try part1Parser.parse(&line)
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

enum Color: String, CaseIterable {
    case red
    case green
    case blue
}
struct Grab {
    var red = 0
    var green = 0
    var blue = 0
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

let part1Parser = Parse(input: Substring.UTF8View.self) {
    "Game ".utf8; Int.parser(); ": ".utf8
    Many {
        Many {
            Int.parser()
            " ".utf8
            OneOf {
                for c in Color.allCases {
                    c.rawValue.utf8.map { c }
                }
            }
        } separator: {
            ", ".utf8
        }.map {
            $0.reduce(into: Grab()) { out, pair in
                switch pair.1 {
                case .red:
                    out.red += pair.0
                case .green:
                    out.green += pair.0
                case .blue:
                    out.blue += pair.0
                }
            }
        }
    } separator: {
        "; ".utf8
    }.map(Game.init)
}
