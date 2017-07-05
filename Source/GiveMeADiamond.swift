import Cocoa
import XCTest

func diamond(_ size: Int) -> String? {
    guard size % 2 != 0, size > 0 else { return nil }
    var arr = [String](), currentSize = size
    while currentSize > 0 {
        var a = Array.init(repeating: "*", count: currentSize)
        for _ in 0..<(size-currentSize)/2 {
            a.insert(" ", at: 0)
        }
        arr.append(a.joined())
        currentSize -= 2
    }
    return (arr.reversed() + arr[1..<arr.count]).joined(separator: "\n") + "\n"
}

class DiamondTest: XCTestCase {
    static var allTests = [
        ("Test Example", testExample),
        ]

    func testExample() {
        XCTAssertEqual(diamond(3)!, " *\n***\n *\n")
        XCTAssertEqual(diamond(2), nil)
        XCTAssertEqual(diamond(-3), nil)
        XCTAssertEqual(diamond(0), nil)
    }
}

let testSuite = DiamondTest.defaultTestSuite()
testSuite.run()
