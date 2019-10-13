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

extension Sequence where Element: LosslessStringConvertible {
    func toString() -> String {
        return map{String($0)}.joined()
    }
}

func bracketsSequence2(_ input: String) -> String {
    let characters = Array(input)
    var output = Array(repeating: "?", count: characters.count)
    var found = false
    repeat {
        found = false
        for (i, char) in characters.enumerated() {
            guard
                "({[".contains(char),
                i < characters.count - 1,
                output[i] == "?"
            else { continue }
            
            guard let j = output.suffix(from: i+1).firstIndex(of: "?") else {
                continue
            }
            
//            print(char, i, j, found, characters.count, characters.toString(), output.count, output.joined())
            
            if characters[i] == characters[j].pair {
                found = true
                output[i] = String(characters[i])
                output[j] = String(characters[j])
            }
        }
    } while found
    return output.joined().components(separatedBy: "?").compactMap{$0}.sorted{$0.count > $1.count}.first ?? ""
}

class BracketsTest: XCTestCase {
    static var allTests = [
        ("Test Brackets 2 Sequence", testBracketsSequence2)
    ]
    
    func testBracketsSequence2() {
        XCTAssertEqual(bracketsSequence2("((}{))()[()]"), "()[()]")
        XCTAssertEqual(bracketsSequence2("(())()}[{[[]]}]"), "[{[[]]}]")
        XCTAssertEqual(bracketsSequence2("(())(){[{[[]]}]"), "[{[[]]}]")
    }
}

BracketsTest.defaultTestSuite.run()
