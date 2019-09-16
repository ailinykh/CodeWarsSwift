import Cocoa
import XCTest

func persistence(for num: Int) -> Int {
    var count = 0
    var num = num
    while num > 9 {
        count += 1
        num = "\(num)".map{ Int("\($0)")! }.reduce(1, *)
    }
    return count
}

class PersistenceTest: XCTestCase {
    static var allTests = [
        ("Test Persistence", testPersistence),
        ("Test Persistence", testPersistenceAgain)
    ]

    func testPersistence() {
        XCTAssertEqual(persistence(for: 18), 1)
    }

    func testPersistenceAgain() {
        XCTAssertEqual(persistence(for: 28), 2)
    }
}

PersistenceTest.defaultTestSuite.run()