import XCTest

@testable import AdventOfCode

final class Day05Tests: XCTestCase {
    let testData = """
    seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15

    fertilizer-to-water map:
    49 53 8
    0 11 42
    42 0 7
    57 7 4

    water-to-light map:
    88 18 7
    18 25 70

    light-to-temperature map:
    45 77 23
    81 45 19
    68 64 13

    temperature-to-humidity map:
    0 69 1
    1 0 69

    humidity-to-location map:
    60 56 37
    56 93 4
    """.data(using: .utf8)!

    func testPart1() throws {
        let mapping = Mapping(data: testData)
        /*
        Seed 79, soil 81, fertilizer 81, water 81, light 74, temperature 78, humidity 78, location 82.
        Seed 14, soil 14, fertilizer 53, water 49, light 42, temperature 42, humidity 43, location 43.
        Seed 55, soil 57, fertilizer 57, water 53, light 46, temperature 82, humidity 82, location 86.
        Seed 13, soil 13, fertilizer 52, water 41, light 34, temperature 34, humidity 35, location 35.
        */
        XCTAssertEqual(mapping.locationForSeed(79), 82)
        XCTAssertEqual(mapping.locationForSeed(14), 43)
        XCTAssertEqual(mapping.locationForSeed(55), 86)
        XCTAssertEqual(mapping.locationForSeed(13), 35)
    }

    func testPart2() throws {
        /* (55..<68) +(79..<93) contains 84 which maps to 46, which is the lowest location in the two provded seed ranges */
        let mapping = Mapping(data: testData)
        var seeds = IndexSet()
        seeds.insert(integersIn: (79..<79+14))
        seeds.insert(integersIn: (55..<55+13))
        XCTAssertEqual(mapping.locationsForSeeds(seeds).first, 46)
    }
}
