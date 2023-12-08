import Foundation
import Parsing

struct Day08: AdventDay {
    var data: Data

    func map() throws -> Map {
        let substrings = data.substrings()
        let graph = Graph(nodes: Dictionary(
            uniqueKeysWithValues: try substrings.dropFirst().map { var line = $0[...].utf8; return try parser().parse(&line) }
        ))
        return Map(directions: substrings[0], paths: graph)
    }

    func part1() throws -> Any {
        try map().stepsToTail()
    }

    func part2() throws -> Any {
        try map().spookyStepsToTail()
    }

    struct Map {
        let directions: Substring
        let paths: Graph

        /// The number of steps required to travel from head to tail.
        func stepsToTail() -> Int {
            return stepsFrom("AAA") { $0 == "ZZZ" }
        }

        /// The number of steps required to travel from head to tail as a spooky ghost.
        func spookyStepsToTail() -> Int {
            let locations = paths.nodes.keys.filter { $0.suffix(1) == "A" }
            let stepsForEachLocation = locations.map { stepsFrom($0, to: { $0.suffix(1) == "Z" }) }

            // It would seem (according to the internet, because how else would I have come to this conclusion independently)...
            // that the path along any given xxA → yyZ is the *same number of steps* as yyZ → yyZ. So... each of the xxA paths forms a loop.
            // This means that *eventually* the multiples of each path loop will line up. This is a least common multiple situation!
            // Behold, an LCM implementation I found and rewrote. Whatever...
            return stepsForEachLocation.reduce(1) {
                var x = 0
                var y = max($0, $1)
                var z = min($0, $1)

                while z != 0 {
                    x = y
                    y = z
                    z = x % y
                }
                return $0 * $1/y
            }
        }

        func stepsFrom(_ start: Substring, to isAtFinish: (Substring) -> Bool) -> Int {
            var count = 0
            var location: Substring = start
            var directions = self.directions.makeIterator().forever()

            let enoughStepsToKillYou = 1_000_000_000
            while let direction = directions.next(), count < enoughStepsToKillYou {
                count += 1
                if direction == "R" {
                    location = paths[location].right
                } else {
                    location = paths[location].left
                }
                if isAtFinish(location) {
                    return count
                }
            }
            fatalError("You walked too much and died. Christmas is ruined _and_ you're a ghost now.")
        }
    }

    struct Graph {
        struct Node {
            let left: Substring
            let right: Substring
        }
        let nodes: [Substring: Node]

        subscript(_ key: Substring) -> Node {
            guard let node = nodes[key] else {
                fatalError("You got lost in the desert. Christmas is ruined.")
            }
            return node
        }
    }

    func parser() -> any Parser<Substring.UTF8View, (Substring, Graph.Node)> {
        Parse(input: Substring.UTF8View.self) {
            Prefix(3).map(Substring.init)
            " = (".utf8
            Parse {
                Prefix(3).map(Substring.init)
                ", ".utf8
                Prefix(3).map(Substring.init)
                ")".utf8
            }.map(Graph.Node.init)
        }
    }
}
