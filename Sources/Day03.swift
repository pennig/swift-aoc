import Foundation

struct Day03: AdventDay {
    var data: Data

    func rows() -> [Row] {
        data.strings().map { line in
            Row(
                string: line,
                numberRanges: line.ranges(of: #/\d+/#),
                symbolRanges: line.matches(of: #/[^.0-9]/#).map { match in
                    let range = match.range
                    let char = match.output[range.lowerBound]
                    return (
                        adjacency: (line.index(before: range.lowerBound)..<line.index(after: range.upperBound)),
                        char: char
                    )
                }
            )
        }
    }

    func part1() throws -> Any {
        let rows = rows()
        var total = 0

        for index in rows.indices {
            let row = rows[index]

            // Filter out the number ranges in this line that *don't* overlap with any symbol ranges from:
            // - this line
            // - the previous line
            // - the next line
            let ranges = row.numberRanges.filter { n in
                if row.symbolRanges.contains(where: { $0.adjacency.overlaps(n) }) {
                    return true
                }
                let prev = rows.index(before: index)
                if rows.indices.contains(prev) && rows[prev].symbolRanges.contains(where: { $0.adjacency.overlaps(n) }) {
                    return true
                }
                let next = rows.index(after: index)
                if rows.indices.contains(next) && rows[next].symbolRanges.contains(where: { $0.adjacency.overlaps(n) }) {
                    return true
                }
                return false
            }

            // Convert the remaining number rranges to Integers and add 'em up.
            let numbers = ranges.compactMap({ Int(row.string[$0]) })
            total += numbers.reduce(0, +)
        }

        return total
    }

    func part2() throws -> Any {
        let rows = rows()
        var total = 0

        for index in rows.indices {
            let row = rows[index]

            // Grab the gear ("*") ranges, then assemble an array of the numbers that surround the gear
            let gears = row.symbolRanges.filter({ $0.char == "*" }).map(\.adjacency)

            let numbers = gears.reduce(into: [[Int]]()) { out, range in
                var numbers = row.numberRanges.filter({ $0.overlaps(range) }).compactMap({ Int(row.string[$0]) })
                guard numbers.count < 3 else { return }

                let prev = rows.index(before: index)
                if rows.indices.contains(prev) {
                    numbers.append(contentsOf: rows[prev].numberRanges.filter({ $0.overlaps(range) }).compactMap({ Int(rows[prev].string[$0]) }))
                }
                guard numbers.count < 3 else { return }

                let next = rows.index(after: index)
                if rows.indices.contains(next) {
                    numbers.append(contentsOf: rows[next].numberRanges.filter({ $0.overlaps(range) }).compactMap({ Int(rows[next].string[$0]) }))
                }

                if numbers.count == 2 {
                    out.append(numbers)
                }
            }

            if numbers.isEmpty { continue }
            total += numbers.reduce(0) { $0 + $1.reduce(1, *) }
        }

        return total
    }
}

struct Row {
    let string: String
    let numberRanges: [Range<String.Index>]
    let symbolRanges: [(adjacency: Range<String.Index>, char: Character)]
}
