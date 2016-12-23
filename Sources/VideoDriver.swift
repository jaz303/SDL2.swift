import CSDL2

public struct VideoDriver {
	public static var count: Int {
		get { return Int(SDL_GetNumVideoDrivers()) }
	}

	public static var currentName: String {
		return String(cString: SDL_GetCurrentVideoDriver())
	}

	public init(index: Int32) {
		self.index = index
	}

	public var name: String {
		return String(cString: SDL_GetVideoDriver(index))
	}

	let index: Int32
}