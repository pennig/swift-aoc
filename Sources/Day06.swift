import Foundation

struct Day06: AdventDay {
    var data: Data

    func part1() throws -> Any {
        let races = zip(data.strings()[0].numbers, data.strings()[1].numbers)
            .map { intercepts(Double($0.0), -Double($0.1+1)) }
        let validTimes = races.map { Int(floor($0.1) - ceil($0.0) + 1) }
        return validTimes.reduce(1, *)
    }

    func part2() throws -> Any {
        let strings = data.strings().map({ $0.replacingOccurrences(of: " ", with: "") })
        let race = (Double(strings[0].numbers[0]), -Double(strings[1].numbers[0]+1))
        let validTimes = intercepts(race.0, race.1)
        return Int(floor(validTimes.1) - ceil(validTimes.0) + 1)
    }

    func intercepts(_ b: Double, _ c: Double) -> (Double, Double) {
        // a = -1
        let r = sqrt(b*b + 4*c)
        return ( (-b + r) / -2, (-b - r) / -2 )
    }
}
