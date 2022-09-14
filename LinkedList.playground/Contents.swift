import UIKit

// MARK: - Node

class Node<Value> {

	var value: Value
	var next: Node?

	init(value: Value, next: Node? = nil) {
		self.value = value
		self.next = next
	}
}

extension Node: CustomStringConvertible {

	var description: String {
		guard let next = next else { return "\(value)" }
		return "\(value) -> \(next.description)"
	}
}

// MARK: - LinkedList

struct LinkedList<Value> {

	var head, tail: Node<Value>?

	var isEmpty: Bool { head == nil }

	mutating func push(_ value: Value) {
		copyNodes()
		head = Node(value: value, next: head)
		if tail == nil { tail = head }
	}

	mutating func append(_ value: Value) {
		copyNodes()
		guard !isEmpty else {
			push(value)
			return
		}
		tail?.next = Node(value: value)
		tail = tail?.next
	}

	func node(at index: Int) -> Node<Value>? {
		var (currentNode, currentIndex) = (head, 0)
		while currentNode != nil, currentIndex < index {
			currentNode = currentNode?.next
			currentIndex += 1
		}
		return currentNode
	}

	@discardableResult
	mutating func insert(_ value: Value, after node: Node<Value>) -> Node<Value> {
		copyNodes()
		guard tail != nil else {
			append(value)
			return tail!
		}
		node.next = Node(value: value, next: node.next)
		return node.next!
	}

	@discardableResult
	mutating func pop() -> Value? {
		copyNodes()
		defer {
			head = head?.next
			if isEmpty { tail = nil }
		}
		return head?.value
	}

	@discardableResult
	mutating func removeLast() -> Value? {
		copyNodes()
		guard let head = head else { return nil }
		guard head.next != nil else { return pop() }
		var (previous, current) = (head, head)
		while let next = current.next {
			previous = current
			current = next
		}
		previous.next = nil
		tail = previous
		return current.value
	}

	@discardableResult
	public mutating func remove(after node: Node<Value>) -> Value? {
		copyNodes()
		defer {
			if node.next === tail {
				tail = node
			}
			node.next = node.next?.next
		}
		return node.next?.value
	}

	private mutating func copyNodes() {
		guard !isKnownUniquelyReferenced(&head) else { return }
		guard var oldNode = head else { return }
		head = Node(value: oldNode.value)
		var newNode = head
		while let nextOldNode = oldNode.next {
			newNode!.next = Node(value: nextOldNode.value)
			newNode = newNode!.next
			oldNode = nextOldNode
		}
		tail = newNode
	}
}

extension LinkedList: CustomStringConvertible {

	var description: String {
		guard let head = head else { return "Empty LinkedList" }
		return "LinkedList: \(head)"
	}
}

extension LinkedList: Collection {

	func index(after i: Index) -> Index {
		Index(node: i.node?.next)
	}

	subscript(position: Index) -> Value {
		position.node!.value
	}

	var startIndex: Index {
		Index(node: head)
	}

	var endIndex: Index {
		Index(node: tail?.next)
	}

	struct Index: Comparable {

		var node: Node<Value>?

		static func ==(lhs: Index, rhs: Index) -> Bool {
			lhs.node === rhs.node
		}

		static func <(lhs: Index, rhs: Index) -> Bool {
			guard lhs != rhs else { return false }
			guard let lhsNode = lhs.node, let rhsNode = rhs.node else { return false }
			let nodes = sequence(first: lhsNode) { $0.next }
			return nodes.contains { $0 === rhsNode }
		}
	}
}

// MARK: - Examples

func example(of string: String, block: () -> Void) {
	print("\nExample: \(string)")
	block()
	print(String(repeating: "_", count: 60))
}

example(of: "push") {
	var list = LinkedList<Int>()
	list.push(3)
	list.push(2)
	list.push(1)
	print(list)
}

example(of: "append") {
	var list = LinkedList<Int>()
	list.append(1)
	list.append(2)
	list.append(3)
	print(list)
}

example(of: "inserting at a particular index") {
	var list = LinkedList<Int>()
	list.push(3)
	list.push(2)
	list.push(1)
	print("Before inserting: \(list)")
	var middleNode = list.node(at: 1)!
	for _ in 1...4 {
		middleNode = list.insert(-1, after: middleNode)
	}
	print("After inserting: \(list)")
}

example(of: "pop") {
	var list = LinkedList<Int>()
	list.push(3)
	list.push(2)
	list.push(1)
	print("Before popping list: \(list)")
	let poppedValue = list.pop()
	print("After popping list: \(list)")
	print("Popped value: " + String(describing: poppedValue))
}

example(of: "removing the last node") {
	var list = LinkedList<Int>()
	list.push(3)
	list.push(2)
	list.push(1)
	print("Before removing last node: \(list)")
	let removedValue = list.removeLast()
	print("After removing last node: \(list)")
	print("Removed value: " + String(describing: removedValue))
}

example(of: "removing a node after a particular node") {
	var list = LinkedList<Int>()
	list.push(3)
	list.push(2)
	list.push(1)
	print("Before removing at particular index: \(list)")
	let index = 1
	let node = list.node(at: index - 1)!
	let removedValue = list.remove(after: node)
	print("After removing at index \(index): \(list)")
	print("Removed value: " + String(describing: removedValue))
}

example(of: "using collection") {
	var list = LinkedList<Int>()
	for i in 0...9 {
		list.append(i)
	}
	print("List: \(list)")
	print("First element: \(list[list.startIndex])")
	print("Array containing first 3 elements: \(Array(list))") // todo: добавить
	print("Array containing last 3 elements: \(Array(list))") // todo: добавить
	let sum = list.reduce(0, +)
	print("Sum of all values: \(sum)")
}

example(of: "linked list cow") {
	var list1 = LinkedList<Int>()
	list1.append(1)
	list1.append(2)
	var list2 = list1
	print("List1: \(list1)")
	print("List2: \(list2)")
	print("After appending 3 to list2")
	list2.append(3)
	print("List1: \(list1)")
	print("List2: \(list2)")
}
