import CSDL2

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