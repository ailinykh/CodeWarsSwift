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

typealias Entity = (Character, Int, Int)

func brackets(_ input: String) -> String {
    var processed = [Entity]()
    for (i, char) in input.enumerated() {
        if "({[".contains(char) { // is opening
            processed.append(Entity(char, i, 0))
        }
        else {
            guard let lastIndex = processed.lastIndex(where: { $0.0 == char.pair && $0.2 == 0 })
                else { continue }
            let last = processed[lastIndex]
            let entity = Entity(last.0, last.1, i)
            processed[lastIndex] = entity
        }
    }
    
    let entity = processed.sorted {
        $0.2 - $0.1 > $1.2 - $1.1
    }.first!
    
    let start = input.index(input.startIndex, offsetBy: entity.1)
    let end = input.index(input.startIndex, offsetBy: entity.2)
    return String(input[start...end])
}

class BracketsTest: XCTestCase {
    static var allTests = [
        ("Test Brackets", testBrackets)
    ]
    
    func testBrackets() {
        XCTAssertEqual(brackets("((}{))()[()]"), "((}{))")
        XCTAssertEqual(brackets("(())()}[{[[]]}]"), "[{[[]]}]")
        XCTAssertEqual(brackets("[{(())](){[{[[]]}]}}"), "{(())](){[{[[]]}]}}")
    }
}

BracketsTest.defaultTestSuite.run()
