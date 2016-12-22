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