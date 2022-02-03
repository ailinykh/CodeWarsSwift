import Foundation
import XCTest

// https://leetcode.com/problems/lru-cache/

class Node {
    var prev: Node?
    var next: Node?
    var key: Int
    var value: Int
    
    var ptr: String { "\(Unmanaged.passUnretained(self).toOpaque())" }
    
    init(key: Int, value: Int) {
        self.key = key
        self.value = value
    }
}

extension Node: Equatable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.ptr == rhs.ptr
    }
}

class List {
    private let head = Node(key: 0, value: 0)
    private let tail = Node(key: 0, value: 0)
        
    init() {
        head.next = tail
        tail.prev = head
    }
    
    func moveToFront(_ node: Node) {
        remove(node)
        pushFront(node)
    }
    
    func remove(_ node: Node) {
        node.next?.prev = node.prev
        node.prev?.next = node.next
    }
    
    func pushFront(_ node: Node) {
        node.next = head.next
        node.prev = head
        
        head.next?.prev = node
        head.next = node
    }
    
    func popTail() -> Node? {
        let node = tail.prev
        if let node = node {
            remove(node)
        }
        return node
    }
}

class LRUCache {
    private var map = [Int:Node]()
    private(set) var list = List()
    private var capacity: Int
    
    init(_ capacity: Int) {
        self.capacity = capacity
    }
    
    func get(_ key: Int) -> Int {
        guard let node = map[key] else { return -1 }
        list.moveToFront(node)
        return node.value
    }
    
    func put(_ key: Int, _ value: Int) {
        if let node = map[key] {
            node.value = value
            list.moveToFront(node)
            return
        }
        
        if map.count == capacity {
            let node = list.popTail()!
            map.removeValue(forKey: node.key)
        }
        
        let node = Node(key: key, value: value)
        map[key] = node
        list.pushFront(node)
    }
}

class LRUCacheTests: XCTestCase {
    func test_last_recently_used_cache1() {
        let cache = LRUCache(1)
        
        XCTAssertEqual(cache.get(6), -1)
        XCTAssertEqual(cache.list.description, "{}")
        
        XCTAssertEqual(cache.get(8), -1)
        XCTAssertEqual(cache.list.description, "{}")
        
        cache.put(12, 1)
        XCTAssertEqual(cache.list.description, "{[12:1]}")
        
        XCTAssertEqual(cache.get(2), -1)
        XCTAssertEqual(cache.list.description, "{[12:1]}")

        cache.put(15, 11)
        XCTAssertEqual(cache.list.description, "{[15:11]}")
        
        cache.put(5, 2)
        XCTAssertEqual(cache.list.description, "{[5:2]}")
        
        cache.put(1, 15)
        XCTAssertEqual(cache.list.description, "{[1:15]}")
        
        cache.put(4, 2)
        XCTAssertEqual(cache.list.description, "{[4:2]}")
        
        XCTAssertEqual(cache.get(5), -1)
        XCTAssertEqual(cache.list.description, "{[4:2]}")
        
        cache.put(15, 15)
        XCTAssertEqual(cache.list.description, "{[15:15]}")
    }
    
    func test_last_recently_used_cache3() {
        let cache = LRUCache(3)
        XCTAssertEqual(cache.list.description, "{}")
    
        cache.put(1, 1)
        XCTAssertEqual(cache.list.description, "{[1:1]}")
        
        cache.put(2, 2)
        XCTAssertEqual(cache.list.description, "{[2:2], [1:1]}")
        
        cache.put(3, 3)
        XCTAssertEqual(cache.list.description, "{[3:3], [2:2], [1:1]}")
        
        cache.put(4, 4)
        XCTAssertEqual(cache.list.description, "{[4:4], [3:3], [2:2]}")
        
        XCTAssertEqual(cache.get(4), 4)
        XCTAssertEqual(cache.list.description, "{[4:4], [3:3], [2:2]}")
        
        XCTAssertEqual(cache.get(3), 3)
        XCTAssertEqual(cache.list.description, "{[3:3], [4:4], [2:2]}")
        
        XCTAssertEqual(cache.get(2), 2)
        XCTAssertEqual(cache.list.description, "{[2:2], [3:3], [4:4]}")
        
        XCTAssertEqual(cache.get(1), -1)
        XCTAssertEqual(cache.list.description, "{[2:2], [3:3], [4:4]}")
        
        cache.put(5, 5)
        XCTAssertEqual(cache.list.description, "{[5:5], [2:2], [3:3]}")
        
        XCTAssertEqual(cache.get(1), -1)
        XCTAssertEqual(cache.list.description, "{[5:5], [2:2], [3:3]}")
        
        XCTAssertEqual(cache.get(2), 2)
        XCTAssertEqual(cache.list.description, "{[2:2], [5:5], [3:3]}")
        
        XCTAssertEqual(cache.get(3), 3)
        XCTAssertEqual(cache.list.description, "{[3:3], [2:2], [5:5]}")
        
        XCTAssertEqual(cache.get(4), -1)
        XCTAssertEqual(cache.list.description, "{[3:3], [2:2], [5:5]}")
        
        XCTAssertEqual(cache.get(5), 5)
        XCTAssertEqual(cache.list.description, "{[5:5], [3:3], [2:2]}")
    }
}

extension List: CustomStringConvertible {
    var description: String {
        var nodes = [String]()
        var n = head.next
        while n != tail {
            nodes.append("[\(n!.key):\(n!.value)]")
            n = n?.next
        }
        return "{\(nodes.joined(separator: ", "))}"
    }
}

extension Node: CustomStringConvertible {
    var description: String {
        [
            "{Node<\(ptr.dropFirst(10))>",
            "prev: \(prev?.ptr.dropFirst(10) ?? "nil")",
            "next: \(next?.ptr.dropFirst(10) ?? "nil")",
            "key: \(key), val: \(value)}"
        ].joined(separator: ", ")
    }
}
