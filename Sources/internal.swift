class Box<T> {
	init(_ v: T) { value = v }
	let value: T
}

class Weak<T: AnyObject> {
	init(_ v: T) { val = v }
	weak var val: T?
	public var value: T? {
		return val
	}
}