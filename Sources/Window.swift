import CSDL2

public class Window {
	public init(title: String = "Untitled Window", width: Int = 800, height: Int = 600) {
		theWindow = SDL_CreateWindow(
			title,
			K_SDL_WINDOWPOS_UNDEFINED, K_SDL_WINDOWPOS_UNDEFINED,
			Int32(width), Int32(height),
			Uint32(K_SDL_WINDOW_SHOWN)
		);
		theRenderer = nil
	}

	deinit {
		SDL_DestroyWindow(theWindow)
	}

	public var title: String {
		get {
			return String(SDL_GetWindowTitle(theWindow))
		}
		set(newTitle) {
			SDL_SetWindowTitle(theWindow, newTitle)
		}
	}

	public var id: UInt32 {
		return SDL_GetWindowID(theWindow)
	}

	public var width: Int {
		var width: Int32 = 0
		SDL_GetWindowSize(theWindow, &width, nil)
		return Int(width)
	}

	public var height: Int {
		var height: Int32 = 0
		SDL_GetWindowSize(theWindow, nil, &height)
		return Int(height)
	}

	public var renderer: Renderer {
		if theRenderer == nil {
			theRenderer = Renderer(window: self)
		}
		return theRenderer!
	}

	public var surface: Surface {
		if windowSurface == nil {
			windowSurface = Surface(sdlSurface: SDL_GetWindowSurface(theWindow), takeOwnership: false)
		}
		return windowSurface!
	}

	public func show() {
		SDL_ShowWindow(theWindow)
	}

	public func hide() {
		SDL_HideWindow(theWindow)
	}

	public func setWidth(width: Int, height: Int) {
		SDL_SetWindowSize(theWindow, Int32(width), Int32(height))
	}

	public func showMessageBox(type: MessageBoxType, title: String, message: String) {
		showSimpleMessageBox(type, title: title, message: message, window: self)
	}

	public func update() {
		SDL_UpdateWindowSurface(theWindow)
	}

	public func updateRects() {
		// TODO: implement using SDL_UpdateWindowSurfaceRects()
	}

	public func _sdlWindow() -> COpaquePointer {
		return theWindow
	}

	let theWindow: COpaquePointer
	var theRenderer: Renderer?
	var windowSurface: Surface?
}