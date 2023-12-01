import XCTest

@testable import AdventOfCode

// One off test to validate that basic data load testing works
final class AdventDayTests: XCTestCase {
  func testInitData() throws {
    let challenge = Day00()
    XCTAssertTrue(challenge.string.starts(with: "4514"))
  }
}
