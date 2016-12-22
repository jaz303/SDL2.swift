import CSDL2

public typealias TimerCallback = (Int) -> (Int)
public typealias TimerID = SDL_TimerID
public typealias Event = SDL_Event
public typealias EventType = SDL_EventType
public typealias EventFilterCallback = (inout Event) -> Bool
public typealias EventWatchCallback = (inout Event) -> ()
public typealias TouchID = SDL_TouchID
public typealias SystemCursor = SDL_SystemCursor
public typealias Keycode = SDL_Keycode
public typealias Scancode = SDL_Scancode

public struct WindowFlags : OptionSet {
	public let rawValue : UInt32
	public init(rawValue: UInt32) { self.rawValue = rawValue }

	static let FULLSCREEN = WindowFlags(rawValue: UInt32(SDL_WINDOW_FULLSCREEN))
	static let FULLSCREEN_DESKTOP = WindowFlags(rawValue: UInt32(SDL_WINDOW_FULLSCREEN_DESKTOP))
	static let OPENGL = WindowFlags(rawValue: UInt32(SDL_WINDOW_OPENGL))
	static let SHOWN = WindowFlags(rawValue: UInt32(SDL_WINDOW_SHOWN))
	static let HIDDEN = WindowFlags(rawValue: UInt32(SDL_WINDOW_HIDDEN))
	static let BORDERLESS = WindowFlags(rawValue: UInt32(SDL_WINDOW_BORDERLESS))
	static let RESIZABLE = WindowFlags(rawValue: UInt32(SDL_WINDOW_RESIZABLE))
	static let MINIMIZED = WindowFlags(rawValue: UInt32(SDL_WINDOW_MINIMIZED))
	static let MAXIMIZED = WindowFlags(rawValue: UInt32(SDL_WINDOW_MAXIMIZED))
	static let INPUT_GRABBED = WindowFlags(rawValue: UInt32(SDL_WINDOW_INPUT_GRABBED))
	static let INPUT_FOCUS = WindowFlags(rawValue: UInt32(SDL_WINDOW_INPUT_FOCUS))
	static let MOUSE_FOCUS = WindowFlags(rawValue: UInt32(SDL_WINDOW_MOUSE_FOCUS))
	static let FOREIGN = WindowFlags(rawValue: UInt32(SDL_WINDOW_FOREIGN))
	static let ALLOW_HIGHDPI = WindowFlags(rawValue: UInt32(SDL_WINDOW_ALLOW_HIGHDPI))
	static let MOUSE_CAPTURE = WindowFlags(rawValue: UInt32(SDL_WINDOW_MOUSE_CAPTURE))
	
	// FIXME: need a >= 2.0.5 version check here
	// static let ALWAYS_ON_TOP = WindowFlags(rawValue: UInt32(SDL_INIT_ALWAYS_ON_TOP))
	// static let SKIP_TASKBAR = WindowFlags(rawValue: UInt32(SDL_INIT_SKIP_TASKBAR))
	// static let UTILITY = WindowFlags(rawValue: UInt32(SDL_INIT_UTILITY))
	// static let TOOLTIP = WindowFlags(rawValue: UInt32(SDL_INIT_TOOLTIP))
	// static let POPUP_MENU = WindowFlags(rawValue: UInt32(SDL_INIT_POPUP_MENU))
}

public struct InitOptions : OptionSet {
	public let rawValue : UInt32
	public init(rawValue: UInt32) { self.rawValue = rawValue }

	static let TIMER = InitOptions(rawValue: UInt32(SDL_INIT_TIMER))
	static let AUDIO = InitOptions(rawValue: UInt32(SDL_INIT_AUDIO))
	static let VIDEO = InitOptions(rawValue: UInt32(SDL_INIT_VIDEO))
	static let JOYSTICK = InitOptions(rawValue: UInt32(SDL_INIT_JOYSTICK))
	static let HAPTIC = InitOptions(rawValue: UInt32(SDL_INIT_HAPTIC))
	static let GAMECONTROLLER = InitOptions(rawValue: UInt32(SDL_INIT_GAMECONTROLLER))
	static let EVENTS = InitOptions(rawValue: UInt32(SDL_INIT_EVENTS))
	static let EVERYTHING = InitOptions(rawValue: UInt32(SDL_INIT_TIMER | SDL_INIT_AUDIO | SDL_INIT_VIDEO | SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC | SDL_INIT_GAMECONTROLLER | SDL_INIT_EVENTS))
}