import CSDL2

// TODO: SDL_GL_LoadLibrary (don't think I need it)
// TODO: SDL_GL_UnloadLibrary (don't think I need it)
// TODO: SDL_GL_GetProcAddress (don't think I need it)
// TODO: SDL_GL_GetCurrentWindow (needs internal map)

extension sdl {
	public class gl {
		public static func createContext(window: Window) -> GLContext? {
			return SDL_GL_CreateContext(window._sdlWindow())
		}

		public static func delete(context: GLContext) {
			SDL_GL_DeleteContext(context)
		}

		public static func supports(ext: String) -> Bool {
			return SDL_GL_ExtensionSupported(ext) == SDL_TRUE
		}

		public static func getAttribute(name: GLattr, value: inout Int32) -> Bool {
			return SDL_GL_GetAttribute(name, &value) == 0
		}

		public static func getCurrentContext() -> GLContext? {
			return SDL_GL_GetCurrentContext()
		}

		public static func getDrawableSize(window: Window, width: inout Int, height: inout Int) {
			var w32 : Int32 = 0
			var h32 : Int32 = 0
			SDL_GL_GetDrawableSize(window._sdlWindow(), &w32, &h32)
			width = Int(w32)
			height = Int(h32)
		}

		public static func getSwapInterval() -> Int {
			return Int(SDL_GL_GetSwapInterval())
		}

		public static func makeCurrent(context: GLContext, forWindow window: Window) -> Bool {
			return SDL_GL_MakeCurrent(window._sdlWindow(), context) == 0
		}

		public static func resetAttributes() {
			SDL_GL_ResetAttributes()
		}

		public static func setAttribute(name: GLattr, value: Int32) -> Bool {
			return SDL_GL_SetAttribute(name, value) == 0
		}

		public static func setSwapInterval(interval: Int) {
			SDL_GL_SetSwapInterval(Int32(interval))
		}

		public static func swap(window: Window) {
			SDL_GL_SwapWindow(window._sdlWindow())
		}
	}
}
