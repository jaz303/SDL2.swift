import CSDL2

public typealias Rect = SDL_Rect
extension Rect {
	public static func zero() -> Rect {
		return Rect(x: 0, y: 0, w: 0, h: 0)
	}

	public var left: Int32 { get { return x } }
	public var right: Int32 { get { return x + w } }
	public var top: Int32 { get { return y } }
	public var bottom: Int32 { get { return y + h } }

	mutating public func makeZero() {
		x = 0; y = 0; w = 0; h = 0
	}

	public func isZero() -> Bool {
		return x == 0 && y == 0 && w == 0 && h == 0
	}

	public func unionRect(aRect: Rect) -> Rect {
		var outRect = Rect()
		unionRect(aRect, outRect: &outRect)
		return outRect
	}

	public func unionRect(aRect: Rect, inout outRect: Rect) {
		outRect.x = min(x, aRect.x)
		outRect.y = min(y, aRect.y)
		outRect.w = max(right, aRect.right) - outRect.x
		outRect.h = max(bottom, aRect.bottom) - outRect.y
	}

	public func intersectRect(aRect: Rect) -> Rect {
		var outRect = Rect.zero()
		intersectRect(aRect, outRect: &outRect)
		return outRect
	}

	public func intersectRect(aRect: Rect, inout outRect: Rect) -> Bool {
		let x5 = max(x, aRect.x)
		let x6 = min(right, aRect.right)
		let y5 = max(y, aRect.y)
		let y6 = min(top, aRect.bottom)
		if x5 >= x6 || y5 >= y6 {
			return false	
		} else {
			outRect.x = x5
			outRect.y = y5
			outRect.w = x6 - x5
			outRect.h = y6 - y5
			return true
		}
	}

	public func containsRect(rect: Rect) -> Bool {
		return rect.x >= x
				&& (rect.x + rect.w) <= (x + w)
				&& rect.y >= y
				&& (rect.y + rect.h) <= (y + h)
	}

	public func intersectsRect(aRect: Rect) -> Bool {
		return !(right < aRect.left
					&& left > aRect.right
					&& bottom < aRect.top
					&& top > aRect.bottom)
	}

	mutating public func translateBy(point: Point) {
		x += point.x; y += point.y
	}

	mutating public func translateBy(dx dx: Int, dy: Int) {
		x += dx; y += dy
	}

	public func translateBy(point: Point, inout outRect: Rect) {
		outRect.x = x + point.x
		outRect.y = y + point.y
		outRect.w = w
		outRect.h = h
	}

	public func translateBy(dx dx: Int, dy: Int, inout outRect: Rect) {
		outRect.x = x + dx
		outRect.y = y + dy
		outRect.w = w
		outRect.h = h
	}

	public func translatedBy(point: Point) -> Rect {
		return Rect(x: x + point.x, y: y + point.y, w: w, h: h)
	}

	public func translatedBy(dx dx: Int, dy: Int) -> Rect {
		return Rect(x: x + dx, y: y + dy, w: w, h: h)
	}
}

public typealias Point = SDL_Point
extension Point {
	
}

public func +(left: Point, right: Point) -> Point {
	return Point(x: left.x + right.x, y: left.y + right.y)
}

public func -(left: Point, right: Point) -> Point {
	return Point(x: left.x - right.x, y: left.y - right.y)
}

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

public class PixelFormats {
	public static let ARGB8888: UInt32 = UInt32(SDL_PIXELFORMAT_ARGB8888)

	// TODO: cache this
	public class func forFormat(format: UInt32) -> PixelFormat {
		return PixelFormat(format: SDL_AllocFormat(format))
	}
}

public class PixelFormat {
	public class func forNativeFormat(format: UnsafeMutablePointer<SDL_PixelFormat>) -> PixelFormat {
		// TODO: cache
		return PixelFormat(format: format)
	}

	init(format: UnsafeMutablePointer<SDL_PixelFormat>) {
		theFormat = format
	}

	public var format: UInt32 {
		get { return SDL_X_GetPixelFormatFormat(theFormat) }
	}

	public var name: String {
		get { return String.fromCString(SDL_GetPixelFormatName(self.format))! }
	}

	public func _sdlPixelFormat() -> UnsafeMutablePointer<SDL_PixelFormat> {
		return theFormat
	}

	let theFormat: UnsafeMutablePointer<SDL_PixelFormat>
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

	public func createTextureFromSurface(surface: Surface) -> Texture {
		let tex = SDL_CreateTextureFromSurface(theRenderer, surface._sdlSurface())
		return Texture(sdlTexture: tex)
	}

	public func createStreamingTexture(width width: Int, height: Int) -> Texture {
		let tex = SDL_CreateTexture(
			theRenderer,
			Uint32(SDL_PIXELFORMAT_ARGB8888),
			K_SDL_TEXTUREACCESS_STREAMING,
			Int32(width),
			Int32(height)
		)
		return Texture(sdlTexture: tex)
	}

	public func setDrawColorRed(red: Uint8, green: Uint8, blue: Uint8, alpha: Uint8 = 255) {
		SDL_SetRenderDrawColor(theRenderer, red, green, blue, alpha)
	}

	public func copyTexture(texture: Texture) {
		SDL_RenderCopy(theRenderer, texture._sdlTexture(), nil, nil)
	}

	public func copyTexture(texture: Texture, sourceRect: Rect, destinationRect: Rect) {
		var s = sourceRect
		var d = destinationRect
		SDL_RenderCopy(theRenderer, texture._sdlTexture(), &s, &d)
	}

	public func copyTexturePtr(texture: Texture, inout sourceRect: Rect, inout destinationRect: Rect) {
		SDL_RenderCopy(theRenderer, texture._sdlTexture(), &sourceRect, &destinationRect)
	}

	public func drawLineX1(x1: Int, y1: Int, x2: Int, y2: Int) {
		SDL_RenderDrawLine(theRenderer, Int32(x1), Int32(y1), Int32(x2), Int32(y2))
	}

	public func drawPointX(x: Int, y: Int) {
		SDL_RenderDrawPoint(theRenderer, Int32(x), Int32(y))
	}

	public func drawRect(rect: Rect) {
		var r = rect
		SDL_RenderDrawRect(theRenderer, &r)
	}

	public func drawRectPtr(inout rect: Rect) {
		SDL_RenderDrawRect(theRenderer, &rect)
	}

	public func fillRect(rect: Rect) {
		var r = rect
		SDL_RenderFillRect(theRenderer, &r)
	}

	public func fillRectPtr(inout rect: Rect) {
		SDL_RenderFillRect(theRenderer, &rect)
	}

	let theRenderer: COpaquePointer
	let theWindow: Window
}

public class Texture {
	init(sdlTexture: COpaquePointer) {
		theTexture = sdlTexture
		var w: Int32 = 0, h: Int32 = 0
		SDL_QueryTexture(theTexture, nil, nil, &w, &h)
		width = Int(w)
		height = Int(h)
	}

	deinit {
		SDL_DestroyTexture(theTexture)
	}

	/**
	 * Copy image data from surface to the texture.
	 *
	 * This method provides a bridge between software and hardware rendering.
	 *
	 * Assumes surface and texture have same size and pixel format.
	 *
	 * FIXME: will probably break horribly if assumptions are breached.
	 */
	public func copyFromSurface(surface: Surface) {
		SDL_UpdateTexture(
			theTexture,
			nil,
			SDL_X_GetSurfacePixels(surface._sdlSurface()),
			SDL_X_GetSurfacePitch(surface._sdlSurface())
		)
	}

	//public func lock() {
	//	SDL_LockTexture(theTexture)
	//}

	public func unlock() {
		SDL_UnlockTexture(theTexture)
	}

	public func _sdlTexture() -> COpaquePointer {
		return theTexture
	}

	public let width: Int
	public let height: Int

	let theTexture: COpaquePointer
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

	public class func wait(timeout timeout: Int) -> Event? {
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
	public init(width: Int,
				height: Int,
				depth: Int = 32,
				rmask: UInt32 = 0x00FF0000,
				gmask: UInt32 = 0x0000FF00,
				bmask:UInt32 = 0x000000FF,
				amask:UInt32 = 0xFF000000) {
		theSurface = SDL_CreateRGBSurface(0, Int32(width), Int32(height), Int32(depth), rmask, gmask, bmask, amask)
		owned = true
		pixelFormat = PixelFormat.forNativeFormat(SDL_X_GetSurfacePixelFormat(theSurface))
	}

	public init(sdlSurface: UnsafeMutablePointer<SDL_Surface>, takeOwnership: Bool = true) {
		theSurface = sdlSurface
		owned = takeOwnership
		pixelFormat = PixelFormat.forNativeFormat(SDL_X_GetSurfacePixelFormat(theSurface))
	}

	deinit {
		if (owned) {
			SDL_FreeSurface(theSurface)
		}
	}

	public var width: Int {
		get { return Int(SDL_X_GetSurfaceWidth(theSurface)) }
	}

	public var height: Int {
		get { return Int(SDL_X_GetSurfaceHeight(theSurface)) }
	}

	public var pitch: Int {
		get { return Int(SDL_X_GetSurfacePitch(theSurface)) }
	}

	public var pixels: UnsafeMutablePointer<UInt8> {
		get { return SDL_X_GetSurfacePixels(theSurface) }
	}

	public func convertedToPixelFormat(pixelFormat: PixelFormat) -> Surface {
		return Surface(sdlSurface: SDL_ConvertSurface(theSurface, pixelFormat._sdlPixelFormat(), Uint32(0)))
	}

	/*
	 * Plot a pixel on the surface, assuming that the underyling SDL surface
	 * representation uses 32 bits per pixel. The pixel value is written
	 * unaltered, i.e. no color format conversion is performed.
	 */
	public func putPixel32(x: Int, _ y: Int, _ color: Uint32) {
		SDL_X_SetSurfacePixel32(theSurface, Int32(x), Int32(y), color)
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

	public let pixelFormat: PixelFormat
	let theSurface: UnsafeMutablePointer<SDL_Surface>
	let owned: Bool

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
