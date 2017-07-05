import Cocoa
import XCTest

func playPass(_ s: String, _ n: Int) -> String {
    // your code
    var s = s
    s.shift(n)
    s.complementDigitsToNine()
    s.uppercaseAndDowncaseEachLetter()
    s.reverse()
    return s
}

extension String {
    mutating func shift(_ n: Int) {
        self = String(unicodeScalars.enumerated().map {
            switch $1.value {
            case 65...90, 97...122:
                return Character(UnicodeScalar(shiftedLetter($1.value, n))!)
            default:
                return Character($1)
            }
        })
    }

    mutating func complementDigitsToNine() {
        self = String(unicodeScalars.enumerated().map {
            switch $1.value {
            case 48...57:
                return Character("\(9-Int("\(Character($1))")!)")
            default:
                return Character($1)
            }
        })
    }

    mutating func uppercaseAndDowncaseEachLetter() {
        self = String(unicodeScalars.enumerated().map {
            switch $1.value {
            case 65...90, 97...122:
                return $0 % 2 == 0 ? Character("\($1)".uppercased()) : Character("\($1)".lowercased())
            default:
                return Character($1)
            }
        })
    }

    mutating func reverse() {
        self = String(Array(characters).reversed())
    }

    func shiftedLetter(_ char: UInt32, _ n: Int) -> UInt32 {
        let letters = Array<UInt32>([65...90, 97...122].joined())
        let position = letters.index(of: char)! + n
        return letters[position >= letters.count ? position - letters.count : position]
    }
}

class PassphrasesTest: XCTestCase {
    static var allTests = [
        ("playPass", testExample),
        ]

    func dotest(_ s: String, _ n: Int, _ expected: String) {
        XCTAssertEqual(playPass(s, n), expected, "should return \(expected)")
    }

    func testExample() {
        dotest("I LOVE YOU!!!", 1, "!!!vPz fWpM J");
        dotest("I LOVE YOU!!!", 0, "!!!uOy eVoL I");
        dotest("AAABBCCY", 1, "zDdCcBbB");
        dotest("MY GRANMA CAME FROM NY ON THE 23RD OF APRIL 2015", 2,
               "4897 NkTrC Hq fT67 GjV Pq aP OqTh gOcE CoPcTi aO");
    }
}

let testSuite = PassphrasesTest.defaultTestSuite()
testSuite.run()
