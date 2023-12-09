import Algorithms
import Foundation

struct Day05: AdventDay {
    var data: Data

    func part1() throws -> Any {
        let mapping = Mapping(data: data)
        let seeds = Set(data.stringGroups()[0][0].split(separator: ": ")[1].split(separator: " ").compactMap({ Int($0) }))
        return seeds.map {
            mapping.locationForSeed($0)
        }.min() ?? 0
    }

    func part2() throws -> Any {
        let mapping = Mapping(data: data)
        let seeds = data.stringGroups()[0][0].split(separator: ": ")[1].split(separator: " ").compactMap({ Int($0) })

        var seedRanges = IndexSet()
        for range in seeds.chunks(ofCount: 2) {
            let lower = range.first!, upper = lower + range.last!
            seedRanges.insert(integersIn: (lower..<upper))
        }

        return mapping.locationsForSeeds(seedRanges).first ?? 0
    }
}

class Mapping {
    typealias Map = [Range<Int>: Int]

    // Name-to-name
    var categoryMaps: [Substring: Substring] = [:]
    // Name-to-map
    var rangeMaps: [Substring: Map] = [:]

    init(data: Data) {
        data.stringGroups().dropFirst().forEach(process)
    }

    private func process(_ input: [String]) {
        let header = input[0].matches(of: #/(?<from>\w+)-to-(?<to>\w+) map:/#)[0].output
        categoryMaps[header.from] = header.to

        rangeMaps[header.from] = input.dropFirst().reduce(into: Map()) { map, input in
            // to, from, length
            let ranges = input.split(separator: " ").compactMap { Int($0) }
            map[(ranges[1]..<ranges[1]+ranges[2])] = ranges[0]
        }
    }

    func locationForSeed(_ seed: Int) -> Int {
        return locationsForSeeds(IndexSet(integer: seed)).first ?? 0
    }

    func locationsForSeeds(_ seeds: IndexSet) -> IndexSet {
        var category: Substring = "seed"
        var output = seeds

        // Follow the mappings until there are no more
        while true {
            guard let nextCategory = categoryMaps[category], let map = rangeMaps[category] else {
                return output
            }
            
            output = mapIndexSet(output, using: map)
            category = nextCategory
        }
    }

    func mapIndexSet(_ indexSet: IndexSet, using map: Map) -> IndexSet {
        var input = indexSet
        var output = IndexSet()

        // iterate through the mappings for this category, subtracting them from the input as we go (to arrive at an IndexSet of unhandled ranges)
        for (range, start) in map {
            let rangeIndexSet = IndexSet(integersIn: range)
            input.intersection(rangeIndexSet).rangeView.forEach { innerRange in
                // adjust the intersecting range by the delta between the from and to values
                let delta = start - range.lowerBound
                let lower = innerRange.lowerBound + delta, upper = innerRange.upperBound + delta
                output.insert(integersIn: (lower..<upper))
            }
            input.subtract(rangeIndexSet)
        }

        // add the unhandled ranges (1:1 mappings) and return
        return output.union(input)
    }
}
