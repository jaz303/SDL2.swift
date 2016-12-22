import CSDL2

// TODO: review filtering/watching for thread safety
// TODO: SDL_RecordGesture
// TODO: dollar templates

public class WatchID {
	init(_ callback: @escaping EventWatchCallback) {
		cb = callback
	}
	let cb: EventWatchCallback
}

public class Events {

	public static func isEventTypeEnabled(type: SDL_EventType) -> Bool {
		return SDL_EventState(type.rawValue, -1) == 1
	}

	public static func setEventTypeEnabled(type: SDL_EventType, _ enabled: Bool) {
		SDL_EventState(type.rawValue, enabled ? SDL_ENABLE : SDL_DISABLE)
	}

	public static func registerEvents(count: Int) -> UInt32 {
		return SDL_RegisterEvents(Int32(count))
	}

	public class func pump() {
		SDL_PumpEvents()
	}

	public class func push(evt: inout Event) {
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

	public class func poll(_ evt: inout Event) -> Bool {
		return SDL_PollEvent(&evt) == Int32(1)
	}

	public class func wait() -> Event {
		var evt = Event()
		wait(evt: &evt)
		return evt
	}

	public class func wait(timeout: Int) -> Event? {
		var evt = Event()
		if wait(evt: &evt, timeout: timeout) {
			return evt
		} else {
			return nil
		}
	}

	public class func wait(evt: inout Event) {
		SDL_WaitEvent(&evt)
	}

	public class func wait(evt: inout Event, timeout: Int) -> Bool {
		return SDL_WaitEventTimeout(&evt, Int32(timeout)) == 1
	}

	public class func flush(type: SDL_EventType) {
		SDL_FlushEvent(type.rawValue)
	}

	public class func flush(type: UInt32) {
		SDL_FlushEvent(type)
	}

	public class func flush(minType min: SDL_EventType, maxType max: SDL_EventType) {
		SDL_FlushEvents(min.rawValue, max.rawValue)
	}	

	public class func flush(minType min: UInt32, maxType max: UInt32) {
		SDL_FlushEvents(min, max)
	}

	public class func add(events: inout [Event], count: Int = -1) {
		let c = (count == -1) ? events.count : count
		SDL_PeepEvents(&events, Int32(c), SDL_ADDEVENT, SDL_FIRSTEVENT.rawValue, SDL_LASTEVENT.rawValue)
	}

	public class func get(events: inout [Event], count: Int = -1, minType: UInt32 = SDL_FIRSTEVENT.rawValue, maxType: UInt32 = SDL_LASTEVENT.rawValue) {
		let c = (count == -1) ? events.count : count
		SDL_PeepEvents(&events, Int32(c), SDL_GETEVENT, SDL_FIRSTEVENT.rawValue, SDL_LASTEVENT.rawValue)
	}

	public class func peek(events: inout [Event], count: Int = -1, minType: UInt32 = SDL_FIRSTEVENT.rawValue, maxType: UInt32 = SDL_LASTEVENT.rawValue) {
		let c = (count == -1) ? events.count : count
		SDL_PeepEvents(&events, Int32(c), SDL_PEEKEVENT, minType, maxType)
	}

	public class func hasEvent(type: SDL_EventType) -> Bool {
		return SDL_HasEvent(type.rawValue) == SDL_TRUE
	}

	public class func hasEvent(type: UInt32) -> Bool {
		return SDL_HasEvent(type) == SDL_TRUE
	}

	public class func hasEvents(minType: SDL_EventType, maxType: SDL_EventType) -> Bool {
		return SDL_HasEvents(minType.rawValue, maxType.rawValue) == SDL_TRUE
	}

	public class func hasEvents(minType: UInt32, maxType: UInt32) -> Bool {
		return SDL_HasEvents(minType, maxType) == SDL_TRUE
	}

	//public class func qUItRequested() {
	//	return SDL_QUItRequested()
	//}

	public class var numberOfTouchDevices: Int {
		return Int(SDL_GetNumTouchDevices()) 
	}

	public class func getTouchDevice(index: Int) -> TouchDevice {
		return TouchDevice(deviceID: SDL_GetTouchDevice(Int32(index)))
	}

	//
	// Filtering

	public static func filter(callback: EventFilterCallback) {
		// FIXME
		// let box = Box(callback)
		// let opq = Unmanaged.passRetained(box).toOpaque()
		// let mut = UnsafeMutableRawPointer(opq)
		// SDL_FilterEvents({ (userdata,evt) in
		// 	let opq = OpaquePointer(userdata)
		// 	let box: Box<EventFilterCallback> = Unmanaged
		// 											.fromOpaque(opq)
		// 											.takeRetainedValue()
		// 	return box.value(&evt.pointee) ? 1 : 0
		// }, mut)
	}

	public static func getFilter() -> EventFilterCallback? {
		return activeFilter?.value
	}

	public static func setFilter(callback: EventFilterCallback?) {
		// FIXME
		// clearFilter()
		// if (callback != nil) {
		// 	activeFilter = Box(callback!)
		// 	let opq = Unmanaged.passUnretained(activeFilter!).toOpaque()
		// 	let mut = UnsafeMutableRawPointer(opq)
		// 	SDL_SetEventFilter({ (userdata,evt) in
		// 		let opq = OpaquePointer(userdata)
		// 		let box: Box<EventFilterCallback> = Unmanaged
		// 												.fromOpaque(opq)
		// 												.takeUnretainedValue()
		// 		return box.value(&evt.pointee) ? 1 : 0
		// 	}, mut)
		// }
	}

	public static func clearFilter() {
		SDL_SetEventFilter(nil, nil)
		activeFilter = nil
	}

	private static var activeFilter: Box<EventFilterCallback>?

	//
	// Watching

	// FIXME
	// public static func addWatch(callback: EventWatchCallback) -> WatchID {
	// 	let watchId = WatchID(callback)
	// 	watches.append(watchId)
	// 	if watches.count == 1 {
	// 		SDL_AddEventWatch({ (userdata,evt) in
	// 			for watch in Events.watches {
	// 				watch.cb(&evt.pointee)
	// 			}
	// 			return 0
	// 		}, nil)
	// 	}
	// 	return watchId
	// }

	public static func deleteWatch(id: WatchID) {
		let ix = watches.index(where: {$0 === id})
		if ix != nil {
			watches.remove(at: ix!)
		}
	}

	private static var watches: [WatchID] = []
	
}

public extension Event {
	// NOTE: this should be safe, structs are all laid out identically
	public var timestamp: UInt32 { return self.motion.timestamp  }
	public var windowID: UInt32 { return self.motion.windowID  }

	//
	// App

	public var isQuit: Bool {
		return self.type == SDL_QUIT.rawValue
	}

	//
	// Window

	public var isWindow: Bool {
		return self.type == SDL_WINDOWEVENT.rawValue 
	}

	public var isWindowClose: Bool {
		return self.window.event == UInt8(SDL_WINDOWEVENT_CLOSE) 
	}

	// Keyboard

	public var isKeyDown: Bool {
		return self.type == SDL_KEYDOWN.rawValue 
	}

	public var isKeyUp: Bool {
		return self.type == SDL_KEYUP.rawValue 
	}

	public var isTextEditing: Bool {
		return self.type == SDL_TEXTEDITING.rawValue 
	}

	public var isTextInput: Bool {
		return self.type == SDL_TEXTINPUT.rawValue 
	}

	//public var isKeyMapChanged: Bool {
	//	return self.type == SDL_KEYMAPCHANGED.rawValue 
	//}

	// Mouse
	// TODO: "state" member

	public var isMouseMotion: Bool {
		return self.type == SDL_MOUSEMOTION.rawValue 
	}

	public var mouseMotionWhich: UInt32 { return self.motion.which  }
	public var mouseMotionX: Int { return Int(self.motion.x)  }
	public var mouseMotionY: Int { return Int(self.motion.y)  }
	public var mouseMotionDX: Int { return Int(self.motion.xrel)  }
	public var mouseMotionDY: Int { return Int(self.motion.yrel)  }
	
	public var isMouseButtonDown: Bool {
		return self.type == SDL_MOUSEBUTTONDOWN.rawValue 
	}

	public var isMouseButtonUp: Bool {
		return self.type == SDL_MOUSEBUTTONUP.rawValue 
	}

	public var isLeftMouseButton: Bool {
		return self.button.button == UInt8(SDL_BUTTON_LEFT) 
	}

	public var isMiddleMouseButton: Bool {
		return self.button.button == UInt8(SDL_BUTTON_MIDDLE) 
	}

	public var isRightMouseButton: Bool {
		return self.button.button == UInt8(SDL_BUTTON_RIGHT) 
	}

	public var isX1MouseButton: Bool {
		return self.button.button == UInt8(SDL_BUTTON_X1) 
	}

	public var isX2MouseButton: Bool {
		return self.button.button == UInt8(SDL_BUTTON_X2) 
	}

	public var mouseButtonWhich: UInt32 { return self.button.which  }

	// TODO: replace this with an internal constant
	public var mouseButtonButton: Int { return Int(self.button.button)  }
	public var mouseButtonX: Int { return Int(self.button.x)  }
	public var mouseButtonY: Int { return Int(self.button.y)  }
	public var mouseButtonClicks: Int { return Int(self.button.clicks)  }

	public var isMouseWheel: Bool {
		return self.type == SDL_MOUSEWHEEL.rawValue 
	}

	public var mouseWheelWhich: UInt32 { return self.wheel.which  }
	public var mouseWheelDX: Int { return Int(self.wheel.x)  }
	public var mouseWheelDY: Int { return Int(self.wheel.y)  }
	
	// TODO: "direction" member (constantify)
	// public var mouseWheelIsFlipped: Bool { return self.wheel.direction == SDL_MOUSEWHEEL_FLIPPED  }
}
