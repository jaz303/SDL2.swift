import CSDL2

// TODO: SDL_GetMouseFocus - need a way to map SDL_Window* to Window
// TODO: SDL_CaptureMouse - undefined?
// TODO: SDL_CreateCursor - needed?
// TODO: SDL_GetGlobalMouseState - undefined?
// TODO: SDL_WarpMouseGlobal - undefined?

public class Mouse {
	// public static func startCapture() {
	// 	SDL_CaptureMouse(SDL_TRUE)
	// }

	// public static func stopCapture() {
	// 	SDL_CaptureMouse(SDL_FALSE)
	// }

	// public static func warpMouseTo(x x: Int, y: Int) {
	// 	SDL_WarpMouseGlobal(Int32(x), Int32(y))
	// }

	public static func enableRelativeMouseMode() -> Bool {
		return SDL_GetRelativeMouseMode() == SDL_TRUE
	}

	public static func enableRelativeMouseMode() {
		SDL_SetRelativeMouseMode(SDL_TRUE)
	}

	public static func disableRelativeMouseMode() {
		SDL_SetRelativeMouseMode(SDL_FALSE)	
	}

	public static func warpMouseTo(x x: Int, y: Int, inWindow window: Window) {
		SDL_WarpMouseInWindow(window._sdlWindow(), Int32(x), Int32(y))
	}

	public static func copyMouseStateTo(x: inout Int, _ y: inout Int) {
		// TODO: get button state too
		var x32: Int32 = 0, y32: Int32 = 0
		SDL_GetMouseState(&x32, &y32)
		x = Int(x32)
		y = Int(y32)
	}

	// public static func copyGlobalMouseStateTo(x: inout Int, inout _ y: Int) {
	// 	// TODO: get button state too
	// 	var x32: Int32 = 0, y32: Int32 = 0
	// 	SDL_GetGlobalMouseState(&x32, &y32)
	// 	x = Int(x32)
	// 	y = Int(y32)
	// }

	public static func copyRelativeMouseStateTo(x: inout Int, _ y: inout Int) {
		// TODO: get button state too
		var x32: Int32 = 0, y32: Int32 = 0
		SDL_GetRelativeMouseState(&x32, &y32)
		x = Int(x32)
		y = Int(y32)
	}

	public static var defaultCursor: Cursor {
		if _defaultCursor == nil {
			_defaultCursor = Cursor(cursor: SDL_GetDefaultCursor())
		}
		return _defaultCursor!
	}

	public static func getCursor() -> Cursor {
		if _activeCursor != nil {
			return _activeCursor!
		} else {
			return defaultCursor
		}
	}

	public static func setCursor(cursor: Cursor) {
		_activeCursor = cursor
		SDL_SetCursor(cursor.cursor)
	}

	public static func hideCursor() {
		SDL_ShowCursor(0)
	}

	public static func showCursor() {
		SDL_ShowCursor(1)
	}

	static var _activeCursor: Cursor?
	static var _defaultCursor: Cursor?
}

public class Cursor {
	public init(systemCursor: SystemCursor, owned: Bool = true) {
		self.cursor = SDL_CreateSystemCursor(systemCursor)
		self.owned = owned
	}

	public init(surface: Surface, hotX: Int, hotY: Int, owned: Bool = true) {
		self.cursor = SDL_CreateColorCursor(
			surface._sdlSurface(),
			Int32(hotX),
			Int32(hotY)
		)
		self.owned = owned
	}

	init(cursor: COpaquePointer) {
		self.cursor = cursor
		self.owned = false
	}

	deinit {
		if owned {
			SDL_FreeCursor(cursor)	
		}
	}

	public func use() {
		Mouse.setCursor(self)
	}

	let cursor: COpaquePointer
	let owned: Bool
}