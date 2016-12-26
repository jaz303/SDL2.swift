import CSDL2

public typealias Point = SDL_Point
extension Point {
	public func isZero() -> Bool {
		return x == 0 && y == 0
	}

	public func inverted() -> Point {
		return Point(x: -x, y: -y)
	}

	public mutating func invert() {
		x = -x; y = -y
	}
}

public func +(left: Point, right: Point) -> Point {
	return Point(x: left.x + right.x, y: left.y + right.y)
}

public func -(left: Point, right: Point) -> Point {
	return Point(x: left.x - right.x, y: left.y - right.y)
}