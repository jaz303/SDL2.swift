import CSDL2

public typealias Point = SDL_Point
extension Point {
	
}

public func +(left: Point, right: Point) -> Point {
	return Point(x: left.x + right.x, y: left.y + right.y)
}

public func -(left: Point, right: Point) -> Point {
	return Point(x: left.x - right.x, y: left.y - right.y)
}