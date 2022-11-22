//
//  Stack.swift
//  feedback2go
//
//  Created by Tom Rudnick on 19.11.22.
//

import Foundation

protocol Stackable {
    associatedtype Element
    func peek() -> Element?
    mutating func push(_ element: Element)
    @discardableResult mutating func pop() -> Element?
    func size() -> Int
}

extension Stackable {
    var isEmpty: Bool { peek() == nil }
}

class Stack<Element>: ExpressibleByArrayLiteral, Stackable where Element: Equatable {
    private(set) var storage = [Element]()
    func peek() -> Element? { storage.last }
    func push(_ element: Element) { storage.append(element)  }
    func pop() -> Element? { storage.popLast() }
    func size() -> Int { storage.count }

    init() {
        self.storage = []
    }

    init(storage: [Element]) {
        self.storage = storage
    }

    required init(arrayLiteral elements: Stack.Element...) {
        self.storage = elements
    }

}
