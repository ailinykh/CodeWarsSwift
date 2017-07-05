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
        let ascii = unicodeScalars.filter{$0.isASCII}.map{$0.value}
        let uppercasedRange = 65...90
        let downcasedRange = 97...122

        for (idx, c) in ascii.enumerated() {
            let char = Int(c)
            if uppercasedRange.contains(char) {
                let newChar = shiftedChar(uppercasedRange, char, n)
                replaceCharAtIndex(Character(UnicodeScalar(newChar)!), idx)
            }
            else if downcasedRange.contains(char) {
                let newChar = shiftedChar(downcasedRange, char, n)
                replaceCharAtIndex(Character(UnicodeScalar(newChar)!), idx)
            }
        }
    }

    mutating func complementDigitsToNine() {
        let ascii = unicodeScalars.filter{$0.isASCII}.map{$0.value}
        let digitsRange = 48...57

        for (idx, c) in ascii.enumerated() {
            let char = Int(c)
            if digitsRange.contains(char) {
                let digit = Int(String(Character(UnicodeScalar(char)!)))!
                let newDigit = 9 - digit
                replaceCharAtIndex(Character("\(newDigit)"), idx)
            }
        }
    }

    mutating func uppercaseAndDowncaseEachLetter() {
        let ascii = unicodeScalars.filter{$0.isASCII}.map{$0.value}
        let uppercasedRange = 65...90
        let downcasedRange = 97...122

        for (idx, c) in ascii.enumerated() {
            let char = Int(c)
            if uppercasedRange.contains(char) && idx % 2 != 0 {
                let newChar = String(Character(UnicodeScalar(char)!))
                replaceCharAtIndex(Character(newChar.lowercased()), idx)
            }
            else if downcasedRange.contains(char) && idx % 2 == 0 {
                let newChar = String(Character(UnicodeScalar(char)!))
                replaceCharAtIndex(Character(newChar.uppercased()), idx)
            }
        }
    }

    mutating func shiftedChar(_ range: CountableClosedRange<Int>, _ char: Int, _ offset: Int) -> Int {
        var newChar = char + offset
        if !range.contains(newChar) {
            newChar = range.lowerBound-1 + (newChar - range.upperBound)
        }
        return newChar
    }

    mutating func reverse() {
        self = String(Array(characters).reversed())
    }

    mutating func replaceCharAtIndex(_ char: Character, _ idx: Int)
    {
        let start = index(startIndex, offsetBy: idx)
        let end = index(startIndex, offsetBy: idx + 1)
        replaceSubrange(start..<end, with: String(char))
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
