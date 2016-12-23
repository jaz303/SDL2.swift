import CSDL2

public struct Display {
	public static var count: Int {
		get { return Int(SDL_GetNumVideoDisplays()) }
	}

	public init(index: Int32) {
		self.index = index
	}

	public var currentDisplayMode: DisplayMode {
		get {
			var mode : DisplayMode = DisplayMode()
			SDL_GetCurrentDisplayMode(index, &mode)
			return mode	
		}
	}

	public var desktopDisplayMode: DisplayMode {
		get {
			var mode : DisplayMode = DisplayMode()
			SDL_GetDesktopDisplayMode(index, &mode)
			return mode	
		}
	}

	public var bounds: Rect {
		get {
			var rect: Rect = Rect()
			SDL_GetDisplayBounds(index, &rect)
			return rect
		}
	}

	public var displayModeCount: Int {
		get { return Int(SDL_GetNumDisplayModes(index)) }
	}

	// public var usableBounds: Rect {
	// 	get {
	// 		var rect: Rect = Rect()
	// 		SDL_GetDisplayUsableBounds(index, &rect)
	// 		return rect
	// 	}
	// }

	public var name: String {
		get { return String(cString: SDL_GetDisplayName(index)) }
	}

	public func displayModeAtIndex(_ modeIndex: Int) -> DisplayMode {
		var mode : DisplayMode = DisplayMode()
		SDL_GetDisplayMode(Int32(index), Int32(modeIndex), &mode)
		return mode		
	}

	public func closestDisplayMode(toDisplayMode: DisplayMode) -> DisplayMode {
		var to = toDisplayMode
		var mode : DisplayMode = DisplayMode()
		SDL_GetClosestDisplayMode(index, &to, &mode)
		return mode
	}

	public func getDPI(diagonal: inout Float, horizontal: inout Float, vertical: inout Float) {
		SDL_GetDisplayDPI(index, &diagonal, &horizontal, &vertical)
	}

	public let index: Int32
}