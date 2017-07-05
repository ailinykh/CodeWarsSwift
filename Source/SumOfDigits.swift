import Cocoa
import XCTest

func digitalRoot(of number: Int) -> Int {
    let num = "\(number)".characters.map{ Int("\($0)")! }.reduce(0, +)
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

let testSuite = SolutionTest.defaultTestSuite()
testSuite.run()
