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
		SDL_PushEvent(&evt)
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
		return SDL_PollEvent(&evt) == Int32(1)
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
		SDL_WaitEvent(&evt)
	}

	public class func wait(inout evt: Event, timeout: Int) -> Bool {
		return SDL_WaitEventTimeout(&evt, Int32(timeout)) == 1
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

public extension Event {
	// NOTE: this should be safe, structs are all laid out identically
	public var timestamp: Uint32 { get { return self.motion.timestamp } }
	public var windowID: Uint32 { get { return self.motion.windowID } }

	//
	// App

	public var isQuit: Bool {
		get { return self.type == Uint32(K_SDL_QUIT) }
	}

	//
	// Window

	public var isWindow: Bool {
		get { return self.type == Uint32(K_SDL_WINDOWEVENT) }
	}

	public var isWindowClose: Bool {
		get { return self.window.event == Uint8(K_SDL_WINDOWEVENT_CLOSE) }
	}

	// Keyboard

	public var isKeyDown: Bool {
		get { return self.type == Uint32(K_SDL_KEYDOWN) }
	}

	public var isKeyUp: Bool {
		get { return self.type == Uint32(K_SDL_KEYUP) }
	}

	public var isTextEditing: Bool {
		get { return self.type == Uint32(K_SDL_TEXTEDITING) }
	}

	public var isTextInput: Bool {
		get { return self.type == Uint32(K_SDL_TEXTINPUT) }
	}

	//public var isKeyMapChanged: Bool {
	//	get { return self.type == Uint32(K_SDL_KEYMAPCHANGED) }
	//}

	// Mouse
	// TODO: "state" member

	public var isMouseMotion: Bool {
		get { return self.type == Uint32(K_SDL_MOUSEMOTION) }
	}

	public var mouseMotionWhich: Uint32 { get { return self.motion.which } }
	public var mouseMotionX: Int { get { return Int(self.motion.x) } }
	public var mouseMotionY: Int { get { return Int(self.motion.y) } }
	public var mouseMotionDX: Int { get { return Int(self.motion.xrel) } }
	public var mouseMotionDY: Int { get { return Int(self.motion.yrel) } }
	
	public var isMouseButtonDown: Bool {
		get { return self.type == Uint32(K_SDL_MOUSEBUTTONDOWN) }
	}

	public var isMouseButtonUp: Bool {
		get { return self.type == Uint32(K_SDL_MOUSEBUTTONUP) }
	}

	public var isLeftMouseButton: Bool {
		get { return self.button.button == Uint8(SDL_BUTTON_LEFT) }
	}

	public var isMiddleMouseButton: Bool {
		get { return self.button.button == Uint8(SDL_BUTTON_MIDDLE) }
	}

	public var isRightMouseButton: Bool {
		get { return self.button.button == Uint8(SDL_BUTTON_RIGHT) }
	}

	public var isX1MouseButton: Bool {
		get { return self.button.button == Uint8(SDL_BUTTON_X1) }
	}

	public var isX2MouseButton: Bool {
		get { return self.button.button == Uint8(SDL_BUTTON_X2) }
	}

	public var mouseButtonWhich: Uint32 { get { return self.button.which } }

	// TODO: replace this with an internal constant
	public var mouseButtonButton: Int { get { return Int(self.button.button) } }
	public var mouseButtonX: Int { get { return Int(self.button.x) } }
	public var mouseButtonY: Int { get { return Int(self.button.y) } }
	public var mouseButtonClicks: Int { get { return Int(self.button.clicks) } }

	public var isMouseWheel: Bool {
		get { return self.type == Uint32(K_SDL_MOUSEWHEEL) }
	}

	public var mouseWheelWhich: Uint32 { get { return self.wheel.which } }
	public var mouseWheelDX: Int { get { return Int(self.wheel.x) } }
	public var mouseWheelDY: Int { get { return Int(self.wheel.y) } }
	
	// TODO: "direction" member (constantify)
	//public var mouseWheelIsFlipped: Bool { get { return self.wheel.direction == SDL_MOUSEWHEEL_FLIPPED } }
}