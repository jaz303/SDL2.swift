import CSDL2

public typealias DisplayMode = SDL_DisplayMode
extension DisplayMode {
	public var refreshRate: Int32 {
		get {
			return refresh_rate
		}
		set(newRefreshRate) {
			refresh_rate = newRefreshRate
		}
	}
}