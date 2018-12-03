import Cocoa
import XCTest

// https://www.codewars.com/kata/prize-draw

func rank(_ st: String, _ we: [Int], _ n: Int) -> String {
    // your code
    let participants = st.components(separatedBy: ",")
    guard st.count > 0 else {
        return "No participants"
    }
    guard participants.count > n else {
        return "Not enough participants"
    }
    var winningNumbers = [String: Int]()
    for (idx, name) in participants.enumerated() {
        winningNumbers[name] = nameRank(name) * we[idx]
    }
    let sortedTupleArray = winningNumbers.sorted { $0.value == $1.value ? $1.key > $0.key : $0.value > $1.value }
    return sortedTupleArray[n-1].key
}

func nameRank(_ name: String) -> Int {
    var rank = 0
    let alphabet = "abcdefghijklmnopqrstuvwxyz"

    for (_, char) in name.lowercased().enumerated() {
        if let idx = alphabet.index(of: char) {
            rank += alphabet.distance(from: alphabet.startIndex, to: idx) + 1
        }
    }

    return rank + name.count
}

class RankTest: XCTestCase {
    static var allTests = [
        ("rank", testExample),
        ]

    func testing(_ s: String, _ we: [Int], _ n: Int, _ expected: String) {
        XCTAssertEqual(rank(s, we, n), expected, "should return \(expected)")
    }

    func testExample() {
        testing("Addison,Jayden,Sofia,Michael,Andrew,Lily,Benjamin", [4, 2, 1, 4, 3, 1, 2], 4, "Benjamin");
        testing("Elijah,Chloe,Elizabeth,Matthew,Natalie,Jayden", [1, 3, 5, 5, 3, 6], 2, "Matthew");
        testing("Addison,Jayden,Sofia,Michael,Andrew,Lily,Benjamin", [4, 2, 1, 4, 3, 1, 2], 8, "Not enough participants");
        testing("", [4, 2, 1, 4, 3, 1, 2], 6, "No participants");
    }
}

RankTest.defaultTestSuite.run()
