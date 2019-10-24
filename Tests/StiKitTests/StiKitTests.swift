import XCTest
@testable import StiKit

final class StiKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(StiKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
