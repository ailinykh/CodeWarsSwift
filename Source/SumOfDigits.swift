import Cocoa
import XCTest

// https://www.codewars.com/kata/sum-of-digits-slash-digital-root

func digitalRoot(of number: Int) -> Int {
    let num = "\(number)".map{ Int("\($0)")! }.reduce(0, +)
    return num < 10 ? num : digitalRoot(of: num)
}

class SolutionTest: XCTestCase {
    static var allTests = [
        ("Test Example", testExample),
        ]

    func testExample() {
        XCTAssertEqual(digitalRoot(of: 16), 7)
    }
}

SolutionTest.defaultTestSuite.run()
