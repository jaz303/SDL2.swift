import CSDL2

/*
SDL_ShowMessageBox
SDL_ShowSimpleMessageBox
*/

public extension sdl {
	public static var grabbedWindow: Window? {
		let gWindow = SDL_GetGrabbedWindow()
		if gWindow == nil {
			return nil
		}
		return Window.lookup(id: SDL_GetWindowID(gWindow))
	}

	public static func disableScreenSaver() {
		SDL_DisableScreenSaver()
	}

	public static func enableScreenSaver() {
		SDL_EnableScreenSaver()
	}

	public static func isScreenSaverEnabled() -> Bool {
		return SDL_IsScreenSaverEnabled() == SDL_TRUE
	}

	public static func videoInit(driverName: String? = nil) -> Bool {
		return SDL_VideoInit(driverName) == 0
	}

	public static func videoQuit() {
		SDL_VideoQuit()
	}
}