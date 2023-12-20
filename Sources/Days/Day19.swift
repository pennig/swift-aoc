import Foundation
import Parsing

struct Day19: AdventDay {
    var data: Data

    func part1() throws -> Any {
        let work = try data.parse(parser())
        return work.ratingOfPassingParts()
    }

    func part2() throws -> Any {
        let work = try data.parse(parser())
        return work.combinationsOfRatings()
    }

    struct Part {
        let x, m, a, s: Int
        var rating: Int { x + m + a + s }

        static let parser = Parse(input: Substring.UTF8View.self) {
            "{".utf8
            Skip { PrefixThrough("=".utf8) }
            Int.parser()
            Skip { PrefixThrough("=".utf8) }
            Int.parser()
            Skip { PrefixThrough("=".utf8) }
            Int.parser()
            Skip { PrefixThrough("=".utf8) }
            Int.parser()
            "}".utf8
        }.map(Part.init)
    }

    struct PartRanges {
        var x, m, a, s: IndexSet
        var count: Int {
            x.count * m.count * a.count * s.count
        }

        init() {
            x = IndexSet(integersIn: (1...4000))
            m = x; a = x; s = x
        }

        subscript(attr: KeyPath<Part, Int>) -> IndexSet {
            get {
                switch attr {
                case \.x: x; case \.m: m; case \.a: a; case \.s: s
                default: fatalError("nope")
                }
            }
            set {
                switch attr {
                case \.x: x = newValue; case \.m: m = newValue; case \.a: a = newValue; case \.s: s = newValue
                default: fatalError("nope")
                }
            }
        }
    }

    struct Rule {
        let attr: KeyPath<Part, Int>
        let isGreaterThan: Bool
        let value: Int
        let goto: String

        func pass(_ part: Part) -> Bool {
            isGreaterThan ? part[keyPath: attr] > value : part[keyPath: attr] < value
        }

        static let parser = Parse(input: Substring.UTF8View.self) {
            OneOf {
                "x".utf8.map { \Part.x }
                "m".utf8.map { \Part.m }
                "a".utf8.map { \Part.a }
                "s".utf8.map { \Part.s }
            }
            OneOf {
                "<".utf8.map { false }
                ">".utf8.map { true }
            }
            Int.parser()
            ":".utf8
            UTF8.letters
        }.map(Rule.init)
    }

    struct Workflow {
        let rules: [Rule]
        let fallback: String

        func perform(_ part: Part) -> String {
            rules.first(where: { $0.pass(part) })?.goto ?? fallback
        }

        static let parser = Parse(input: Substring.UTF8View.self) {
            "{".utf8
            Many {
                Rule.parser
            }
            separator: { ",".utf8 }
            ",".utf8
            UTF8.letters
            "}".utf8
        }.map(Workflow.init)
    }

    struct Work {
        let workflows: [String: Workflow]
        let parts: [Part]

        func check(_ part: Part) -> Bool {
            var w = "in"
            while let workflow = workflows[w] {
                w = workflow.perform(part)
            }
            if w == "A" { return true }
            if w == "R" { return false }
            fatalError("got buried alive under a mountain of parts")
        }

        func ratingOfPassingParts() -> Int {
            parts.filter(check).map(\.rating).reduce(0, +)
        }

        func combinationsOfRatings() -> Int {
            return combinationsOfRatings("in", PartRanges())
        }

        func combinationsOfRatings(_ w: String, _ ranges: PartRanges) -> Int {
            guard let workflow = workflows[w] else { return 0 }
            var total = 0
            var ranges = ranges
            for r in workflow.rules {
                let range = IndexSet(integersIn: r.isGreaterThan ? (r.value+1...4000) : (1...r.value-1))
                var filteredRanges = ranges
                filteredRanges[r.attr].formIntersection(range)
                ranges[r.attr].subtract(range)

                if r.goto == "R" { continue }
                if r.goto == "A" {
                    total += filteredRanges.count
                } else {
                    total += combinationsOfRatings(r.goto, filteredRanges)
                }
            }

            if workflow.fallback == "R" {
                return total
            } else if workflow.fallback == "A" {
                return total + ranges.count
            } else {
                return total + combinationsOfRatings(workflow.fallback, ranges)
            }
        }
    }

    func parser() -> any Parser<Substring.UTF8View, Work> {
        Parse(input: Substring.UTF8View.self) {
            Many {
                UTF8.letters
                Workflow.parser
            } separator: {
                "\n".utf8
            }.map { Dictionary(uniqueKeysWithValues: $0) }
            "\n\n".utf8
            Many {
                Part.parser
            } separator: {
                "\n".utf8
            }
        }.map(Work.init)
    }
}

extension UTF8 {
    static let letters = Parse(input: Substring.UTF8View.self) {
        Prefix { (65...90).contains($0) || (97...122).contains($0) }.map(.string)
    }
}
