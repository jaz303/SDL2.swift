import CSDL2

public typealias Rect = SDL_Rect

/*
public struct InitOptions : OptionSetType {
	public init(rawValue : UInt) {
		self.rawValue = rawValue
	}

	static var InitVideo: InitOptions { get { return InitOptions([Int(SDL_INIT_VIDEO)]) } }

	public let rawValue : UInt
}
*/

public enum MessageBoxType : UInt32 {
	case Error = 0x00000010 // K_SDL_MESSAGEBOX_ERROR
	case Warning = 0x00000020 // K_SDL_MESSAGEBOX_WARNING
	case Information = 0x00000040 // K_SDL_MESSAGEBOX_INFORMATION
}

/*
public struct MessageBoxFlag : RawRepresentable, Equatable {
	public init(rawValue: UInt) {
		self.rawValue = rawValue
	}

	public let rawValue : UInt
}
*/

public func showSimpleMessageBox(type: MessageBoxType, title: String, message: String, window: Window? = nil) {
	let w = (window == nil) ? nil : window!._sdlWindow()
	SDL_ShowSimpleMessageBox(UInt32(0), title, message, w)
}

public func Init() -> Bool {
	if SDL_Init(Uint32(SDL_INIT_VIDEO)) < 0 {
		print("error initialising SDL");
		return false
	}
	return true
}

//
// Window

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

	public func _sdlWindow() -> COpaquePointer {
		return theWindow
	}

	let theWindow: COpaquePointer
	var theRenderer: Renderer?
}

//
// Renderer

// TODO: support flags
// TODO: support index
public class Renderer {
	public init(window: Window) {
		theRenderer = SDL_CreateRenderer(window._sdlWindow(), -1, UInt32(0))
		theWindow = window
	}

	deinit {
		SDL_DestroyRenderer(theRenderer)
	}

	public func _sdlRenderer() -> COpaquePointer {
		return theRenderer
	}

	public func clear() {
		SDL_RenderClear(theRenderer)
	}

	public func present() {
		SDL_RenderPresent(theRenderer)
	}

	let theRenderer: COpaquePointer
	let theWindow: Window
}

//
// Test stuff

public func createWindowAndWait() {

	var evt = SDL_Event();
	while true {
		SDL_WaitEvent(&evt);
		if evt.type == Uint32(K_SDL_WINDOWEVENT) && evt.window.event == Uint8(K_SDL_WINDOWEVENT_CLOSE) {
			break;
		}
	}

	//SDL_DestroyWindow(win);
	SDL_Quit();

}

//
// Surface

// TODO: SDL_ConvertSurface
// TODO: SDL_CreateRGBSurfaceFrom
// TODO: SDL_FillRect
// TODO: SDL_FillRects
// TODO: SDL_(Get|Set)ClipRect
// TODO: SDL_(Get|Set)ColorKey
// TODO: SDL_(Get|Set)SurfaceAlphaMod
// TODO: SDL_(Get|Set)SurfaceBlendMode
// TODO: SDL_(Get|Set)SurfaceColorMod
// TODO: SDL_LowerBlit
// TODO: SDL_MUSTLOCK
public class Surface {
	public init(width: Int, height: Int, depth: Int, rmask: UInt32, gmask: UInt32, bmask:UInt32, amask:UInt32) {
		theSurface = SDL_CreateRGBSurface(0, Int32(width), Int32(height), Int32(depth), rmask, gmask, bmask, amask)
	}

	public init(sdlSurface: UnsafeMutablePointer<SDL_Surface>) {
		theSurface = sdlSurface
	}

	deinit {
		SDL_FreeSurface(theSurface)
	}

	public var width: Int {
		get {
			return Int(SDL_X_GetSurfaceWidth(theSurface))
		}
	}

	public var height: Int {
		get {
			return Int(SDL_X_GetSurfaceHeight(theSurface))
		}
	}

	public func lock() {
		SDL_LockSurface(theSurface)
	}

	public func unlock() {
		SDL_UnlockSurface(theSurface)
	}

	public func blitSurface(source: Surface, inout srcRect : Rect, inout destRect: Rect) {
		SDL_UpperBlit(source._sdlSurface(), &srcRect, theSurface, &destRect)
	}

	public func blitSurface(source: Surface, inout destRect: Rect) {
		SDL_UpperBlit(source._sdlSurface(), nil, theSurface, &destRect)
	}

	public func blitSurface(source: Surface, x: Int, y: Int) {
		var r = SDL_Rect(
			x: Int32(x),
			y: Int32(y),
			w: SDL_X_GetSurfaceWidth(theSurface),
			h: SDL_X_GetSurfaceHeight(theSurface)
		)
	}

	public func _sdlSurface() -> UnsafeMutablePointer<SDL_Surface> {
		return theSurface
	}

	let theSurface:UnsafeMutablePointer<SDL_Surface>
}

//
// Image Loading

// TODO: think about error handling here; would throwing be more appropriate?
public func loadImage(file: String) -> Surface? {
	let theSurface = IMG_Load(file)
	if theSurface == nil {
		return nil
	} else {
		return Surface(sdlSurface: theSurface)
	}
}
