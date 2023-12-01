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
                String(decoding: UnsafeRawBufferPointer(rebasing: $0), as: UTF8.self)[...]
            }
        }
    }
}
