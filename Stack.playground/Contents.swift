import Foundation

struct Stack<Element> {

	private var storage: [Element] = []

	init() {}

	mutating func push(_ element: Element) {
		storage.append(element)
	}

	@discardableResult
	mutating func pop() -> Element? {
		storage.popLast()
	}

	func peek() -> Element? {
		storage.last
	}

	var isEmpty: Bool {
		storage.isEmpty
	}
}

extension Stack: CustomStringConvertible {

	var description: String {
		storage
			.map { "\($0)" }
			.reversed()
			.joined(separator: "\n")
	}
}

extension Stack: ExpressibleByArrayLiteral {

	public init(arrayLiteral elements: Element...) {
		storage = elements
	}
}

func example(of str: String, block: () -> Void) {
	print("\nExample:")
	block()
}

example(of: "using a stack") {
	var stack = Stack<Int>()
	stack.push(1)
	stack.push(2)
	stack.push(3)
	stack.push(4)
	print(stack)
	if let poppedElement = stack.pop() {
		assert(4 == poppedElement)
		print("Popped: \(poppedElement)")
	}
}

example(of: "init by array literal") {
	var stack: Stack = [1,2,3,4]
	print(stack)
	if let poppedElement = stack.pop() {
		assert(4 == poppedElement)
		print("Popped: \(poppedElement)")
	}
}
