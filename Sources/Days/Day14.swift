import Foundation
import Parsing

struct Day14: AdventDay {
    var data: Data

    func part1() throws -> Any {
        var cells = try data.parseLines(parser())
        // north
        for i in (0..<cells[0].count) {
            shiftRocks(&cells[column: i])
        }
        return loadOnPlatform(cells)
    }

    func part2() throws -> Any {
        // I observed that pretty early on, the load values looped (after an initial ramp-up)
        // So let's calculate the ramp-up, then the loop cadence, and then modulo into the looped states to grab the billionth one.
        var cells = try data.parseLines(parser())

        var seen = Set([cells])
        var ramp = 0
        while true {
            ramp += 1
            cycle()
            if seen.contains(cells) {
                break
            }
            seen.insert(cells)
        }

        var returnTo = [cells]
        var loop = 0
        while true {
            loop += 1
            cycle()
            if returnTo[0] == cells {
                break
            } else {
                returnTo.append(cells)
            }
        }

        return loadOnPlatform(returnTo[(1_000_000_000-ramp) % loop])

        func cycle() {
            let range = (0..<cells[0].count)
            // north
            for i in range {
                var c = cells[column: i]
                shiftRocks(&c)
                cells[column: i] = c
            }
            // west
            for i in range {
                shiftRocks(&cells[i])
            }
            // south
            for i in range {
                var c = cells[column: i]
                shiftRocksReverse(&c)
                cells[column: i] = c
            }
            // east
            for i in range {
                shiftRocksReverse(&cells[i])
            }
        }
    }

    func loadOnPlatform(_ cells: [[Cell]]) -> Int {
        cells.columns().reduce(0) { out, col in
            out + (0..<col.count).reduce(0) {
                if col[$1] == .round {
                    $0 + (col.count - $1)
                } else {
                    $0
                }
            }
        }
    }

    func shiftRocks(_ arr: inout Array<Cell>) {
        var rocks = 0
        var insertionIndex = 0
        for i in (0..<arr.count) {
            switch arr[i] {
            case .none: continue
            case.round: rocks += 1
            case .cube:
                for r in (insertionIndex..<insertionIndex+rocks) { arr[r] = .round }
                for n in (insertionIndex+rocks..<i) { arr[n] = .none }
                insertionIndex = i+1
                rocks = 0
            }
        }
        for r in (insertionIndex..<insertionIndex+rocks) { arr[r] = .round }
        for n in (insertionIndex+rocks..<arr.count) { arr[n] = .none }
    }

    func shiftRocksReverse(_ arr: inout Array<Cell>) {
        var rocks = 0, insertionIndex = 0
        for i in (0..<arr.count) {
            switch arr[i] {
            case .none: continue
            case.round: rocks += 1
            case .cube:
                let nones = i - insertionIndex - rocks
                for n in (insertionIndex..<insertionIndex+nones) { arr[n] = .none }
                for r in (insertionIndex+nones..<i) { arr[r] = .round }
                insertionIndex = i+1
                rocks = 0
            }
        }
        let nones = arr.count - insertionIndex - rocks
        for n in (insertionIndex..<insertionIndex+nones) { arr[n] = .none }
        for r in (insertionIndex+nones..<arr.count) { arr[r] = .round }
    }

    enum Cell {
        case round
        case none
        case cube
    }

    func parser() -> any Parser<Substring.UTF8View, [Cell]> {
        Parse(input: Substring.UTF8View.self) {
            Many {
                OneOf {
                    "O".utf8.map { Cell.round }
                    "#".utf8.map { Cell.cube }
                    ".".utf8.map { Cell.none }
                }
            }
        }
    }
}

extension Array{
    func columns<T>() -> [[T]] where Element == Array<T> {
        guard let count = first?.count else { return [] }
        return (0..<count).map { self[column: $0] }
    }

    subscript<T>(column c: Int) -> [T] where Element == Array<T> {
        get {
            map { $0[c] }
        }
        set {
            precondition(newValue.count == count)
            for i in self.indices {
                self[i][c] = newValue[i]
            }
        }
    }
}
