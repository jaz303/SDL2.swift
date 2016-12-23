import CSDL2

public typealias Rect = SDL_Rect
extension Rect {
	public static func zero() -> Rect {
		return Rect(x: 0, y: 0, w: 0, h: 0)
	}

	public var left: Int32 { get { return x } }
	public var right: Int32 { get { return x + w } }
	public var top: Int32 { get { return y } }
	public var bottom: Int32 { get { return y + h } }
	public var width: Int32 { get { return w } }
	public var height: Int32 { get { return h } }

	mutating public func makeZero() {
		x = 0; y = 0; w = 0; h = 0
	}

	public func isZero() -> Bool {
		return x == 0 && y == 0 && w == 0 && h == 0
	}

	public func unionRect(_ aRect: Rect) -> Rect {
		var outRect = Rect()
		unionRect(aRect, outRect: &outRect)
		return outRect
	}

	public func unionRect(_ aRect: Rect, outRect: inout Rect) {
		outRect.x = min(x, aRect.x)
		outRect.y = min(y, aRect.y)
		outRect.w = max(right, aRect.right) - outRect.x
		outRect.h = max(bottom, aRect.bottom) - outRect.y
	}

	public func intersectRect(_ aRect: Rect) -> Rect {
		var outRect = Rect.zero()
		intersectRect(aRect, outRect: &outRect)
		return outRect
	}

	public func intersectRect(_ aRect: Rect, outRect: inout Rect) -> Bool {
		let x5 = max(x, aRect.x)
		let x6 = min(right, aRect.right)
		let y5 = max(y, aRect.y)
		let y6 = min(top, aRect.bottom)
		if x5 >= x6 || y5 >= y6 {
			return false	
		} else {
			outRect.x = x5
			outRect.y = y5
			outRect.w = x6 - x5
			outRect.h = y6 - y5
			return true
		}
	}

	public func containsRect(_ rect: Rect) -> Bool {
		return rect.x >= x
				&& (rect.x + rect.w) <= (x + w)
				&& rect.y >= y
				&& (rect.y + rect.h) <= (y + h)
	}

	public func intersectsRect(_ aRect: Rect) -> Bool {
		return !(right < aRect.left
					&& left > aRect.right
					&& bottom < aRect.top
					&& top > aRect.bottom)
	}

	mutating public func translateBy(_ point: Point) {
		x += point.x; y += point.y
	}

	mutating public func translateBy(dx: Int, dy: Int) {
		x += dx; y += dy
	}

	public func translateBy(point: Point, outRect: inout Rect) {
		outRect.x = x + point.x
		outRect.y = y + point.y
		outRect.w = w
		outRect.h = h
	}

	public func translateBy(dx: Int, dy: Int, outRect: inout Rect) {
		outRect.x = x + dx
		outRect.y = y + dy
		outRect.w = w
		outRect.h = h
	}

	public func translatedBy(point: Point) -> Rect {
		return Rect(x: x + point.x, y: y + point.y, w: w, h: h)
	}

	public func translatedBy(dx: Int, dy: Int) -> Rect {
		return Rect(x: x + dx, y: y + dy, w: w, h: h)
	}
}