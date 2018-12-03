import Cocoa
import XCTest

// https://www.codewars.com/kata/bingo-card/

func getCard() -> [String] {
    let letters = ["B", "I", "N", "G", "O"]
    var bingo = [String]()

    for i in 0...4 {
        var a = [Int]()
        for _ in 0...4 {
            let start = UInt32(i*15+1),
                end = UInt32((i+1)*15)
            a.addRandomIntFromRange(start...end)
        }
        if i == 2 { a.removeLast() }
        bingo += a.map{ letters[i]+String($0) }
    }
    return bingo
}

extension Array where Element == Int {
    mutating func addRandomIntFromRange(_ range: CountableClosedRange<UInt32>) {
        var n:Int
        repeat {
            n = Int(arc4random_uniform(range.upperBound - range.lowerBound) + range.lowerBound)
        } while self.contains(n)
        self.append(n)
    }
}

class SolutionTest: XCTestCase {
    static var allTests = [
        ("Test Example", testExample),
        ]

    func splitCard(_ card: [String]) -> [(Character,Int)] {
        return card.map({return ($0[$0.startIndex], Int($0.substring(from: $0.index(after: $0.startIndex))) ?? 0)} )
    }

    func getColumns(card: [String]) -> [[Int]] {
        let bingo : [Character] = ["B", "I", "N", "G", "O"]
        return bingo.map {(ch: Character) -> [Int] in splitCard(card).filter({$0.0 == ch}).map({$0.1})}
    }

    // Test functionality adapted from F# version of the Kata
    func cardAppearsSufficientlyRandom(card1: [String], card2: [String], retries: Int) -> Bool {
        guard retries > 0 else { return true }
        guard (0..<24).map({return card1[$0] == card2[$0]}).filter({$0}).count < 16 else { return false }
        let c3 = getCard()
        return (cardAppearsSufficientlyRandom(card1: card1, card2: c3, retries: retries-1))
    }

    func columnLengthsAreCorrect(card: [String]) -> Bool {
        return getColumns(card: card).map {$0.count} == [5,5,4,5,5]
    }

    func columnRangesAreValid(card: [String]) -> Bool {
        return getColumns(card: card).enumerated().flatMap({(i: Int, v: [Int]) -> [Int] in v.map({$0-(15*i)})}).reduce(true, {$0 && 1...15 ~= $1})
    }

    func columnsAreInOrder(card: [String]) -> Bool {
        let bingo : [Character] = ["B", "I", "N", "G", "O"]
        let lens = [5,5,4,5,5]
        let chkstr = bingo.enumerated().map({String.init(repeating: String($1), count: lens[$0])}).joined()
        return chkstr == splitCard(card).map({String($0.0)}).joined()
    }

    func columnSquaresOrderedRandomly(card: [String]) -> Bool {
        return getColumns(card: card).map({(col : [Int]) -> Bool in col != col.sorted(by: >) && col != col.sorted(by: <=)}).reduce(false, {$0 || $1})
    }

    func allValuesAreUnique(card: [String]) -> Bool {
        var uniques = Set<Int>()
        let insertionCount = splitCard(card).map({$0.1}).reduce(0, {uniques.insert($1); return $0+1})
        return insertionCount == uniques.count
    }

    func testExample() {
        for _ in 1...3 {
            let c1 = getCard()
            let c2 = getCard()
            XCTAssertEqual(c1.count, 24, "Card length incorrect.")
            XCTAssertTrue(allValuesAreUnique(card: c1), "Card has duplicate square entries.")
            XCTAssertTrue(columnLengthsAreCorrect(card: c1), "Some columns have incorrect length.")
            XCTAssertTrue(columnRangesAreValid(card: c1), "Some square value is out of range.")
            XCTAssertTrue(columnsAreInOrder(card: c1), "Columns are not in BINGO order.")
            XCTAssertTrue(columnSquaresOrderedRandomly(card: c1), "Squares do not appear to be ordered randomly.  On extremely rare occasions this is a false positive, try one more time.")
            XCTAssertTrue(cardAppearsSufficientlyRandom(card1: c1, card2: c2, retries: 10), "Card failed randomness check. On extremely rare occasions this is a false positive, try one more time.")
        }
    }
}

SolutionTest.defaultTestSuite.run()
