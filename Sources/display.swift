import CSDL2

/*
SDL_GetClosestDisplayMode
SDL_GetCurrentDisplayMode
SDL_GetCurrentVideoDriver
SDL_GetDesktopDisplayMode
SDL_GetDisplayBounds
SDL_GetDisplayDPI
SDL_GetDisplayMode
SDL_GetDisplayName
SDL_GetDisplayUsableBounds
SDL_GetGrabbedWindow
SDL_GetNumDisplayModes
SDL_GetNumVideoDisplays
SDL_GetNumVideoDrivers
SDL_GetVideoDriver

SDL_VideoInit
SDL_VideoQuit

SDL_ShowMessageBox
SDL_ShowSimpleMessageBox
*/

public extension sdl {
	public static func disableScreenSaver() {
		SDL_DisableScreenSaver()
	}

	public static func enableScreenSaver() {
		SDL_EnableScreenSaver()
	}

	public static func isScreenSaverEnabled() -> Bool {
		return SDL_IsScreenSaverEnabled() == SDL_TRUE
	}
}