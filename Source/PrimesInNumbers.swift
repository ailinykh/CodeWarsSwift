import Cocoa
import XCTest

// https://www.codewars.com/kata/primes-in-numbers

func primesInNumbers(_ num: Int) -> String {
    var num = num
    var arr = [Int]()
    
    while num > 2 {
        var iterator = PrimeIterator()
        var found = false
        
        while !found {
            if let next = iterator.next() {
                if next > 1 && num % next == 0 {
                    arr.append(next)
                    num /= next
                    found = true
                }
            }
        }
    }
    
    var count = 1
    
    return arr.reduce("", { (res, n) -> String in
        guard
            res.count > 0,
            let lastO = res.lastIndex(of: "("),
            let lastC = res.lastIndex(of: ")"),
            let prev = Int(res[res.index(after: lastO)..<lastC])
            else { return res + "(\(n))" }
        
        if prev == n {
            count += 1
            return res
        } else if count > 1 {
            let rv = res[..<lastO] + "(\(prev)**\(count))(\(n))"
            count = 1
            return String(rv)
        }
        
        return res + "(\(n))"
    })
}

extension Int {
    func isPrime() -> Bool {
        if self < 2 {
            return false
        }
        for i in 2..<self {
            if self % i == 0 {
                return false
            }
        }
        return true
    }
}

struct PrimeIterator: IteratorProtocol {
    typealias Element = Int
    var current = 0
    static var cache = [Int]()
    
    mutating func next() -> Int? {
        while !current.isPrime() {
            current += 1
        }
        let rv = current
        current += 1
        return rv
    }
}

#if swift(>=4.2)
#else
extension String {
    func lastIndex(of element: Character) -> String.Index? {
        var idx:String.Index? = nil
        for (i, n) in enumerated() {
            if n == element {
                idx = index(startIndex, offsetBy: i)
            }
        }
        return idx
    }
}
#endif

class PrimesInNumbersTest: XCTestCase {
    func testExample() {
        XCTAssertEqual(primesInNumbers(7919), "(7919)")
        XCTAssertEqual(primesInNumbers(7775460),"(2**2)(3**3)(5)(7)(11**2)(17)")
    }
}

PrimesInNumbersTest.defaultTestSuite.run()
