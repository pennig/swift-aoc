import Collections
import Foundation
import Parsing

struct Day20: AdventDay {
    var data: Data

    func modules() throws -> [String: any Day20_Module] {
        let modules = Dictionary(uniqueKeysWithValues: try data.parseLines(parser()))
        for (k, m) in modules {
            for o in m.outputs {
                modules[o]?.wireInput(k)
            }
        }
        return modules
    }

    func part1() throws -> Any {
        let modules = try modules()
        var deque = Deque<[(String, Pulse, String)]>()

        var lowCount = 0
        var highCount = 0

        for _ in (1...1000) {
            deque.append([("button", .low, "broadcaster")])
            while let signals = deque.popFirst() {
                for signal in signals {
                    switch signal.1 {
                    case .high: highCount += 1
                    case .low: lowCount += 1
                    }
                    guard let module = modules[signal.2] else { continue }
                    let outputs = module.process(signal.1, from: signal.0).map { (signal.2, $0.0, $0.1) }
                    deque.append(outputs)
                }
            }
        }

        return lowCount * highCount
    }

    func part2() throws -> Any {
        let modules = try modules()
        var deque = Deque<[(String, Pulse, String)]>()

        // Oh yay, another sneaky LCM problem :/
        let inputsToRx = Set(modules.filter({ $0.value.outputs.contains("rx") }).keys)
        let lcmSubjects = inputsToRx.compactMap({ modules[$0]?.inputs }).flatMap({ $0 })
        var lcmValues = [String: Int]()

        button: for i in (1...) {
            deque.append([("button", .low, "broadcaster")])
            while let signals = deque.popFirst() {
                for signal in signals {
                    guard let module = modules[signal.2] else { continue }
                    let outputs = module.process(signal.1, from: signal.0).map { (signal.2, $0.0, $0.1) }
                    if lcmSubjects.contains(signal.2) && outputs[0].1 == .high {
                        lcmValues[signal.2] = i
                    }
                    if lcmValues.count == lcmSubjects.count {
                        break button
                    }
                    deque.append(outputs)
                }
            }
        }

        let lcm = lcmValues.values.reduce(1) {
            var x = 0, y = max($0, $1), z = min($0, $1)
            while z != 0 {
                x = y; y = z; z = x % y
            }
            return $0 * $1/y
        }

        return lcm
    }

    func parser() -> any Parser<Substring.UTF8View, (String, any Day20_Module)> {
        Parse {
            Optionally {
                Prefix { $0 == UInt8(ascii: "&") || $0 == UInt8(ascii: "%") }.map(.string)
            }
            UTF8.letters
            " -> ".utf8
            Many {
                UTF8.letters
            } separator: {
                ", ".utf8
            }
        }.map { (kind: String?, name: String, outputs: [String]) in
            let module: any Day20_Module = switch kind {
            case "&"?: Conjunction(outputs: outputs)
            case "%"?: FlipFlop(outputs: outputs)
            default: Broadcast(outputs: outputs)
            }
            return (name, module)
        }
    }

    enum Pulse {
        case low, high
    }
    final class Broadcast: Day20_Module {
        var inputs: Set<String> = []
        var outputs: [String] = []

        init(outputs: [String]) { self.outputs = outputs }
        
        func process(_ pulse: Pulse, from: String) -> [(Pulse, String)] {
            return outputs.map { (pulse, $0) }
        }
    }
    final class FlipFlop: Day20_Module {
        var inputs: Set<String> = []
        var outputs: [String] = []
        var state = Pulse.low

        init(outputs: [String]) { self.outputs = outputs }
        
        func process(_ pulse: Pulse, from: String) -> [(Pulse, String)] {
            if pulse == .high { return [] }
            state = state == .high ? .low : .high
            return outputs.map { (state, $0) }
        }
    }
    final class Conjunction: Day20_Module {
        var inputs: Set<String> = []
        var outputs: [String] = []
        var state = [String: Pulse]()
        
        init(outputs: [String]) { self.outputs = outputs }

        func process(_ pulse: Pulse, from: String) -> [(Pulse, String)] {
            state[from] = pulse
            let output: Pulse = inputs.allSatisfy({ state[$0] == .high }) ? .low : .high
            return outputs.map { (output, $0) }
        }
    }
    final class Sentinel: Day20_Module {
        var inputs: Set<String> = []
        var outputs: [String] = []
        var state = false

        init(outputs: [String]) { self.outputs = outputs }
        func process(_ pulse: Pulse, from: String) -> [(Pulse, String)] {
            if pulse == .low {
                state = true
            }
            return []
        }
    }
}

protocol Day20_Module: AnyObject {
    var inputs: Set<String> { get set }
    var outputs: [String] { get }
    
    init(outputs: [String])
    func wireInput(_ input: String)
    func process(_ pulse: Day20.Pulse, from: String) -> [(Day20.Pulse, String)]
}
extension Day20_Module {
    func wireInput(_ input: String) {
        inputs.insert(input)
    }
}
