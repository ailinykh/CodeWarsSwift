import Cocoa
import XCTest

// https://www.codewars.com/kata/john-and-ann-sign-up-for-codewars

func both(_ n : Int) -> ([Int], [Int]) {
    var ann = Array.init(repeating: 1, count: n)
    var john = Array.init(repeating: 0, count: n)
    for i in 1..<n {
        john[i] = i-ann[john[i-1]]
        ann[i] = i-john[ann[i-1]]
    }
    return (john, ann)
}

func ann(_ n : Int) -> [Int] {
    return both(n).1
}

func john(_ n : Int) -> [Int] {
    return both(n).0
}

func sumJohn(_ n : Int) -> Int {
    return john(n).reduce(0, +)
}

func sumAnn(_ n : Int) -> Int {
    let arr = ann(n)
    return arr.reduce(0, +)
}

class AnnJohnTest: XCTestCase {
    static var allTests = [
        ("Test Examples", testExample),
        ]

    func testExample() {
        XCTAssertEqual(ann(1), [1])
        XCTAssertEqual(john(1), [0])
        XCTAssertEqual(ann(6), [1, 1, 2, 2, 3, 3])
        XCTAssertEqual(john(11), [0, 0, 1, 2, 2, 3, 4, 4, 5, 6, 6])
        XCTAssertEqual(ann(15), [1, 1, 2, 2, 3, 3, 4, 5, 5, 6, 6, 7, 8, 8, 9])
        XCTAssertEqual(john(15), [0, 0, 1, 2, 2, 3, 4, 4, 5, 6, 6, 7, 7, 8, 9])
        XCTAssertEqual(sumAnn(1), 1)
        XCTAssertEqual(sumJohn(1), 0)
        XCTAssertEqual(sumAnn(100), 3076)
        XCTAssertEqual(sumJohn(100), 3066)
    }
}

AnnJohnTest.defaultTestSuite.run()
