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

public class SDL {
	public class func start() -> Bool {
		if SDL_Init(Uint32(SDL_INIT_VIDEO | SDL_INIT_EVENTS)) < 0 {
			print("error initialising SDL");
			return false
		}
		return true
	}

	public class func quit() {
		SDL_Quit()
	}
}

//
// Events

// TODO: SDL_PeepEvents
// TODO: SDL_RecordGesture
// TODO: SDL_RegisterEvents
// TODO: SDL_SetEventFilter
// TODO: SDL_AddEventWatch
// TODO: SDL_DelEventWatch
// TODO: SDL_EventState
// TODO: SDL_FilterEvents
// TODO: SDL_GetEventFilter
// TODO: SDL_GetEventState
// TODO: SDL_GetNumTouchFingers
// TODO: SDL_GetTouchDevice
// TODO: SDL_GetTouchFinger
// TODO: dollar templates
public class Events {
	public class func pump() {
		SDL_PumpEvents()
	}

	public class func push(inout evt: Event) {
		SDL_PushEvent(&evt.raw)
	}

	public class func poll() -> Event? {
		var evt = Event()
		if poll(&evt) {
			return evt
		} else {
			return nil
		}
	}

	public class func poll(inout evt: Event) -> Bool {
		return SDL_PollEvent(&evt.raw) == Int32(1)
	}

	public class func wait() -> Event {
		var evt = Event()
		wait(&evt)
		return evt
	}

	public class func waitTimeout(timeout: Int) -> Event? {
		var evt = Event()
		if wait(&evt, timeout: timeout) {
			return evt
		} else {
			return nil
		}
	}

	public class func wait(inout evt: Event) {
		SDL_WaitEvent(&evt.raw)
	}

	public class func wait(inout evt: Event, timeout: Int) -> Bool {
		return SDL_WaitEventTimeout(&evt.raw, Int32(timeout)) == 1
	}

	public class func flush(type: Uint32) {
		SDL_FlushEvent(type)
	}

	public class func flushMin(min: Uint32, max: Uint32) {
		SDL_FlushEvents(min, max)
	}

	public class func hasEvent(type: Uint32) -> Bool {
		return SDL_HasEvent(type) == SDL_TRUE
	}

	public class func hasEvents(minType: Uint32, maxType: Uint32) -> Bool {
		return SDL_HasEvents(minType, maxType) == SDL_TRUE
	}

	//public class func quitRequested() {
	//	return SDL_QuitRequested()
	//}

	public class var numberOfTouchDevices: Int {
		get { return Int(SDL_GetNumTouchDevices()) }
	}
}

public class Event {
	public init() {
		raw = SDL_Event()
	}

	public var type: Uint32 { get { return raw.type } }

	// NOTE: this should be safe, structs are all laid out identically
	public var timestamp: Uint32 { get { return raw.motion.timestamp } }
	public var windowID: Uint32 { get { return raw.motion.windowID } }

	//
	// App

	public var isQuit: Bool {
		get { return raw.type == Uint32(K_SDL_QUIT) }
	}

	//
	// Window

	public var isWindow: Bool {
		get { return raw.type == Uint32(K_SDL_WINDOWEVENT) }
	}

	public var isWindowClose: Bool {
		get { return raw.window.event == Uint8(K_SDL_WINDOWEVENT_CLOSE) }
	}

	// Keyboard

	public var isKeyDown: Bool {
		get { return raw.type == Uint32(K_SDL_KEYDOWN) }
	}

	public var isKeyUp: Bool {
		get { return raw.type == Uint32(K_SDL_KEYUP) }
	}

	public var isTextEditing: Bool {
		get { return raw.type == Uint32(K_SDL_TEXTEDITING) }
	}

	public var isTextInput: Bool {
		get { return raw.type == Uint32(K_SDL_TEXTINPUT) }
	}

	//public var isKeyMapChanged: Bool {
	//	get { return raw.type == Uint32(K_SDL_KEYMAPCHANGED) }
	//}

	// Mouse
	// TODO: "state" member

	public var isMouseMotion: Bool {
		get { return raw.type == Uint32(K_SDL_MOUSEMOTION) }
	}

	public var mouseMotionWhich: Uint32 { get { return raw.motion.which } }
	public var mouseMotionX: Int { get { return Int(raw.motion.x) } }
	public var mouseMotionY: Int { get { return Int(raw.motion.y) } }
	public var mouseMotionDX: Int { get { return Int(raw.motion.xrel) } }
	public var mouseMotionDY: Int { get { return Int(raw.motion.yrel) } }
	
	public var isMouseButtonDown: Bool {
		get { return raw.type == Uint32(K_SDL_MOUSEBUTTONDOWN) }
	}

	public var isMouseButtonUp: Bool {
		get { return raw.type == Uint32(K_SDL_MOUSEBUTTONUP) }
	}

	public var isLeftMouseButton: Bool {
		get { return raw.button.button == Uint8(SDL_BUTTON_LEFT) }
	}

	public var isMiddleMouseButton: Bool {
		get { return raw.button.button == Uint8(SDL_BUTTON_MIDDLE) }
	}

	public var isRightMouseButton: Bool {
		get { return raw.button.button == Uint8(SDL_BUTTON_RIGHT) }
	}

	public var isX1MouseButton: Bool {
		get { return raw.button.button == Uint8(SDL_BUTTON_X1) }
	}

	public var isX2MouseButton: Bool {
		get { return raw.button.button == Uint8(SDL_BUTTON_X2) }
	}

	public var mouseButtonWhich: Uint32 { get { return raw.button.which } }

	// TODO: replace this with an internal constant
	public var mouseButtonButton: Int { get { return Int(raw.button.button) } }
	public var mouseButtonX: Int { get { return Int(raw.button.x) } }
	public var mouseButtonY: Int { get { return Int(raw.button.y) } }
	public var mouseButtonClicks: Int { get { return Int(raw.button.clicks) } }

	public var isMouseWheel: Bool {
		get { return raw.type == Uint32(K_SDL_MOUSEWHEEL) }
	}

	public var mouseWheelWhich: Uint32 { get { return raw.wheel.which } }
	public var mouseWheelDX: Int { get { return Int(raw.wheel.x) } }
	public var mouseWheelDY: Int { get { return Int(raw.wheel.y) } }
	
	// TODO: "direction" member (constantify)
	//public var mouseWheelIsFlipped: Bool { get { return raw.wheel.direction == SDL_MOUSEWHEEL_FLIPPED } }

	public var raw: SDL_Event;
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
		owned = true
	}

	public init(sdlSurface: UnsafeMutablePointer<SDL_Surface>, takeOwnership: Bool = true) {
		theSurface = sdlSurface
		owned = takeOwnership
	}

	deinit {
		if (owned) {
			SDL_FreeSurface(theSurface)
		}
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
		SDL_UpperBlit(source._sdlSurface(), nil, theSurface, &r)
	}

	public func _sdlSurface() -> UnsafeMutablePointer<SDL_Surface> {
		return theSurface
	}

	let theSurface:UnsafeMutablePointer<SDL_Surface>
	let owned:Bool
}

//
// Timers

public class Timers {
	public class func delay(delay: Int) {
		SDL_Delay(UInt32(delay))
	}

	public class func setTimeout(delay: Int, callback: (AnyObject?) -> Void) -> Int32 {
		//SDL_AddTimer(UInt32(delay), handleTimeout, nil)
		return 0
	}

	public class func clearTimeout(timerId : Int32) -> Bool {
		return SDL_RemoveTimer(timerId) == SDL_TRUE
	}

	public class func getPerformanceCounter() -> UInt64 {
		return SDL_GetPerformanceCounter()
	}

	public class func getPerformanceFrequency() -> UInt64 {
		return SDL_GetPerformanceFrequency()
	}

	public class func getTicks() -> UInt32 {
		return SDL_GetTicks()
	}
}

func handleTimeout(interval: UInt32, userData: COpaquePointer) {
	
}

/*
func handleTimeout(t: Timeout) {
	t.callback(t.userData)
}
*/

struct Timeout {
	let callback: (AnyObject?) -> Void
	let sdlTimerId: Int32
	let userData: AnyObject? 
}

//
// Image Loading

public class Images {
	// TODO: think about error handling here; would throwing be more appropriate?
	public class func load(file: String) -> Surface? {
		let theSurface = IMG_Load(file)
		if theSurface == nil {
			return nil
		} else {
			return Surface(sdlSurface: theSurface)
		}
	}
}
