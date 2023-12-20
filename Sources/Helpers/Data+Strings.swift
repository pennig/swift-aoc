import Foundation

extension Data {
    func strings() -> [String] {
        withUnsafeBytes {
            return $0.split(separator: UInt8(ascii: "\n"), omittingEmptySubsequences: true).map {
                String(decoding: UnsafeRawBufferPointer(rebasing: $0), as: UTF8.self)
            }
        }
    }

    func substrings() -> [Substring] {
        withUnsafeBytes {
            return $0.split(separator: UInt8(ascii: "\n"), omittingEmptySubsequences: true).map {
                Substring(decoding: UnsafeRawBufferPointer(rebasing: $0), as: UTF8.self)
            }
        }
    }

    func utf8view() -> Substring.UTF8View {
        String(data: self, encoding: .utf8)![...].utf8
    }
    
    func utf8views() -> [Substring.UTF8View] {
        substrings().map(\.utf8)
    }

    func stringGroups() -> [[String]] {
        withUnsafeBytes {
            $0.split(separator: UInt8(ascii: "\n"), omittingEmptySubsequences: false)
                .split(whereSeparator: { $0.isEmpty })
                .map {
                    $0.map {
                        String(decoding: UnsafeRawBufferPointer(rebasing: $0), as: UTF8.self)
                    }
                }
        }
    }
}

extension String {
    var numbers: [Int] {
        self.matches(of: #/-?\d+/#).compactMap { Int($0.output) }
    }
}
