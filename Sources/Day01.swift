import Foundation

struct Day01: AdventDay {
    var data: Data

    func part1() -> Any {
        data.substrings().map(\.utf8).map { view in
            let first = view.first(where: { (48...57) ~= $0 })! - 48
            let second = view.reversed().first(where: { (48...57) ~= $0 })! - 48
            return Int(first * 10 + second)
        }.reduce(0, +)
    }

    func part2() -> Any {
        let utf8s = data.substrings().map(\.utf8)
        return utf8s.map(calibration).reduce(0, +)
    }

    private func calibration(_ line: Substring.UTF8View) -> Int {
        var firstNumber = 0
        var lastNumber = 0

        for i in line.indices {
            if let number = line.numberAtIndex(i) {
                firstNumber = number
                break
            }
        }
        for i in line.indices.reversed() {
            if let number = line.numberAtIndex(i) {
                lastNumber = number
                break
            }
        }

        return firstNumber * 10 + lastNumber
    }
}

extension Substring.UTF8View {
    func numberAtIndex(_ i: Substring.UTF8View.Index) -> Int? {
        if self[i] == UInt8(ascii: "1") { return 1 }
        if self[i] == UInt8(ascii: "2") { return 2 }
        if self[i] == UInt8(ascii: "3") { return 3 }
        if self[i] == UInt8(ascii: "4") { return 4 }
        if self[i] == UInt8(ascii: "5") { return 5 }
        if self[i] == UInt8(ascii: "6") { return 6 }
        if self[i] == UInt8(ascii: "7") { return 7 }
        if self[i] == UInt8(ascii: "8") { return 8 }
        if self[i] == UInt8(ascii: "9") { return 9 }
        if self[i...].starts(with: "one".utf8) { return 1 }
        if self[i...].starts(with: "two".utf8) { return 2 }
        if self[i...].starts(with: "three".utf8) { return 3 }
        if self[i...].starts(with: "four".utf8) { return 4 }
        if self[i...].starts(with: "five".utf8) { return 5 }
        if self[i...].starts(with: "six".utf8) { return 6 }
        if self[i...].starts(with: "seven".utf8) { return 7 }
        if self[i...].starts(with: "eight".utf8) { return 8 }
        if self[i...].starts(with: "nine".utf8) { return 9 }
        return nil
    }
}
