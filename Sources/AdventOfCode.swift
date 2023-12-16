import ArgumentParser

// Add each new day implementation to this array:
let allChallenges: [any AdventDay] = [
    Day01(),
    Day02(),
    Day03(),
    Day04(),
    Day05(),
    Day06(),
    Day07(),
    Day08(),
    Day09(),
    Day10(),
    Day11(),
    Day12(),
    Day13(),
    Day14(),
    Day15(),
    Day16(),
]

@main
struct AdventOfCode: AsyncParsableCommand {
    @Argument(help: "The day of the challenge. For December 1st, use '1'. For every day, use '0'")
    var day: Int?

    @Flag(help: "Benchmark the time taken by the solution")
    var benchmark: Bool = false

    /// The selected day, or the latest day if no selection is provided.
    var selectedChallenges: [any AdventDay] {
        get throws {
            if let day {
                if day == 0 {
                    return allChallenges
                }
                if let challenge = allChallenges.first(where: { $0.day == day }) {
                    return [challenge]
                } else {
                    throw ValidationError("No solution found for day \(day)")
                }
            } else {
                return [latestChallenge]
            }
        }
    }

    /// The latest challenge in `allChallenges`.
    var latestChallenge: any AdventDay {
        allChallenges.max(by: { $0.day < $1.day })!
    }

    func run(part: () async throws -> Any, named: String) async -> Duration {
        var result: Result<Any, Error> = .success("<unsolved>")
        let timing = await ContinuousClock().measure {
            do {
                result = .success(try await part())
            } catch {
                result = .failure(error)
            }
        }
        switch result {
        case .success(let success):
            print("\(named): \(success)")
        case .failure(let failure):
            print("\(named): Failed with error: \(failure)")
        }
        return timing
    }

    func run() async throws {
        let challenges = try selectedChallenges
        var allTiming1s: Duration = .zero
        var allTiming2s: Duration = .zero
        for challenge in challenges {
            print("Executing Advent of Code challenge \(challenge.day)...")

            let timing1 = await run(part: challenge.part1, named: "Part 1")
            let timing2 = await run(part: challenge.part2, named: "Part 2")

            if benchmark {
                print("Part 1 took \(timing1), part 2 took \(timing2).")
                allTiming1s += timing1
                allTiming2s += timing2
                #if DEBUG
                print("Looks like you're benchmarking debug code. Try swift run -c release")
                #endif
            }
        }
        if challenges.count > 1 && benchmark {
            print("All Parts 1 took \(allTiming1s), all Parts 2 took \(allTiming2s).")
            print("Combined execution time: \(allTiming1s + allTiming2s)")
        }
    }
}
