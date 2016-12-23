import CSDL2

// TODO: SDL_CreateWindowFrom
// TODO: SDL_GetWindowData - not needed?
// TODO: SDL_SetWindowData - not needed?
// TODO: SDL_GetWindowWMInfo - not needed?
// TODO: SDL_GetWindowFromID - we have an internal map
// TODO: SDL_SetWindowModalFor
// TODO: SDL_SetWindowHitTest
// TODO: SDL_GetWindowBordersSize

// TODO: SDL_GetWindowDisplayMode - need display mode wrapper
// TODO: SDL_SetWindowDisplayMode - need display mode wrapper

var windows = [UInt32: Weak<Window>]()

public class Window {
	public static func lookup(id: UInt32) -> Window? {
		if let windowRef = windows[id] {
			let window = windowRef.value
			if window == nil {
				windows.removeValue(forKey: id)
			}
			return window
		} else {
			return nil
		}
	}

	public init(title: String = "Untitled Window",
				width: Int = 800, height: Int = 600,
				x: Int = SDL_WINDOWPOS_CENTERED, y: Int = SDL_WINDOWPOS_CENTERED,
				flags: WindowFlags = WindowFlags(rawValue: 0)) {
		theWindow = SDL_CreateWindow(title, Int32(x), Int32(y), Int32(width), Int32(height), flags.rawValue)
		theRenderer = nil

		windows[SDL_GetWindowID(theWindow)] = Weak<Window>(self)
	}

	deinit {
		SDL_DestroyWindow(theWindow)
	}

	public var title: String {
		get {
			return String(describing: SDL_GetWindowTitle(theWindow))
		}
		set(newTitle) {
			SDL_SetWindowTitle(theWindow, newTitle)
		}
	}

	public var flags: WindowFlags {
		get {
			return WindowFlags(rawValue: SDL_GetWindowFlags(theWindow))
		}
	}

	// public var opacity: Float {
	// 	get {
	// 		var opacity: Float = 0.0
	// 		SDL_GetWindowOpacity(theWindow, &opacity)
	// 		return opacity
	// 	}
	// 	set(newOpacity) {
	// 		SDL_SetWindowOpacity(theWindow, opacity)
	// 	}
	// }

	public var brightness: Float {
		get {
			return SDL_GetWindowBrightness(theWindow)
		}
		set(newBrightness) {
			SDL_SetWindowBrightness(theWindow, newBrightness)
		}
	}

	// TODO: redo this when we start handling pixel formats properly
	public var pixelFormat: XXPixelFormat {
		return SDL_GetWindowPixelFormat(theWindow)
	}

	public var displayIndex: Int {
		return Int(SDL_GetWindowDisplayIndex(theWindow))
	}

	public var grab: Bool {
		get {
			return SDL_GetWindowGrab(theWindow) == SDL_TRUE
		}
		set(isGrabbed) {
			SDL_SetWindowGrab(theWindow, isGrabbed ? SDL_TRUE : SDL_FALSE)
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

	public var screenKeyboardShown: Bool {
		return Keyboard.isScreenKeyboardShownOnWindow(window: self)
	}

	public var renderer: Renderer {
		if theRenderer == nil {
			theRenderer = WindowRenderer(window: self)
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

	public func raise() {
		SDL_RaiseWindow(theWindow)
	}

	public func restore() {
		SDL_RestoreWindow(theWindow)
	}

	public func minimize() {
		SDL_MinimizeWindow(theWindow)
	}

	public func maximize() {
		SDL_MaximizeWindow(theWindow)
	}

	public func resize(width: Int, height: Int) {
		SDL_SetWindowSize(theWindow, Int32(width), Int32(height))
	}

	public func moveTo(x: Int, y: Int) {
		SDL_SetWindowPosition(theWindow, Int32(x), Int32(y))
	}

	public func showMessageBox(type: MessageBoxType, title: String, message: String) {
		showSimpleMessageBox(type: type, title: title, message: message, window: self)
	}

	public func update() {
		SDL_UpdateWindowSurface(theWindow)
	}

	public func updateRects(_ rects: [Rect]) {
		SDL_UpdateWindowSurfaceRects(theWindow, rects, Int32(rects.count))
	}

	public func setIcon(_ icon: Surface) {
		SDL_SetWindowIcon(theWindow, icon._sdlSurface())
	}

	// public func setInputFocus() {
	// 	SDL_SetWindowInputFocus(theWindow)
	// }

	public func getPosition(x: inout Int, y: inout Int) {
		var x_: Int32 = 0, y_: Int32 = 0
		SDL_GetWindowPosition(theWindow, &x_, &y_)
		x = Int(x_)
		y = Int(y_)
	}

	public func getSize(width: inout Int, height: inout Int) {
		var w: Int32 = 0, h: Int32 = 0
		SDL_GetWindowSize(theWindow, &w, &h)
		width = Int(w)
		height = Int(h)
	}

	public func getMaximumSize(width: inout Int, height: inout Int) {
		var w: Int32 = 0, h: Int32 = 0
		SDL_GetWindowMaximumSize(theWindow, &w, &h)
		width = Int(w)
		height = Int(h)
	}

	public func getMinimumSize(width: inout Int, height: inout Int) {
		var w: Int32 = 0, h: Int32 = 0
		SDL_GetWindowMinimumSize(theWindow, &w, &h)
		width = Int(w)
		height = Int(h)	
	}

	public func setMaximumSize(width: Int, height: Int) {
		SDL_SetWindowMaximumSize(theWindow, Int32(width), Int32(height))
	}

	public func setMinimumSize(width: Int, height: Int) {
		SDL_SetWindowMinimumSize(theWindow, Int32(width), Int32(height))
	}

	public func getGammaRamp(r: inout [UInt16], g: inout [UInt16], b: inout [UInt16]) {
		SDL_GetWindowGammaRamp(theWindow, &r, &g, &b)
	}

	public func setGammaRamp(r: [UInt16], g: [UInt16], b: [UInt16]) {
		SDL_SetWindowGammaRamp(theWindow, r, g, b)
	}

	public func setBordered(_ bordered: Bool) {
		SDL_SetWindowBordered(theWindow, bordered ? SDL_TRUE : SDL_FALSE)
	}

	public func setFullscreenFlags(_ flags: WindowFlags) {
		SDL_SetWindowFullscreen(theWindow, flags.rawValue)
	}

	// public func setResizable(_ resizable: Bool) {
	// 	SDL_SetWindowResizable(theWindow, resizable)
	// }

	public func _sdlWindow() -> OpaquePointer {
		return theWindow
	}

	let theWindow: OpaquePointer
	var theRenderer: WindowRenderer?
	var windowSurface: Surface?
}