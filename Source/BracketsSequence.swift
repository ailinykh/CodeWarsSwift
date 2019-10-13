import Cocoa
import XCTest

extension Character {
    var pair: Character {
        switch (self) {
        case "[": return "]"
        case ("]"): return "["
        case ("{"): return "}"
        case ("}"): return "{"
        case ("("): return ")"
        case (")"): return "("
        default: return Character("")
        }
    }
}

func bracketsSequence(_ input: String) -> String {
    var sequence = [Range<Int>]()
    let characters = Array(input)
    
    for (i, char) in input.enumerated() {
        if "({[".contains(char) { // is opening
            var arr = Array(characters.suffix(from: i))
            while !arr.isValid, let _ = arr.popLast() {
            }
            if arr.count > 0 {
                sequence.append(i..<i+arr.count)
            }
        }
    }
    
    guard let range = sequence.sorted(by: { $0.count > $1.count }).first else {
        return ""
    }
    
    return characters[range].map{ String($0) }.joined()
}

extension Array where Element == Character {
    var isValid: Bool {
        var arr = self
        while arr.count > 0 {
            guard
                let idx = arr.lastIndex(where: { "({[".contains($0) } ),
                idx < arr.count - 1,
                arr[idx] == arr[idx+1].pair
                else { return false }
            arr.replaceSubrange(idx...idx+1, with: [])
        }
        return true
    }
}

class BracketsTest: XCTestCase {
    static var allTests = [
        ("Test Brackets Sequence", testBracketsSequence)
    ]
    
    func testBracketsSequence() {
        XCTAssertEqual(bracketsSequence("((}{))()[()]"), "()[()]")
        XCTAssertEqual(bracketsSequence("(())()}[{[[]]}]"), "[{[[]]}]")
        XCTAssertEqual(bracketsSequence("(())(){[{[[]]}]"), "[{[[]]}]")
    }
}

BracketsTest.defaultTestSuite.run()
