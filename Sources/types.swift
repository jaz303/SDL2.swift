import CSDL2

public typealias AudioCallback<C> = (C, UnsafeMutablePointer<UInt8>, Int) -> ()
public typealias AudioCallbackFoo<C,T> = (C, UnsafeMutableBufferPointer<T>) -> ()

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
public typealias GLContext = SDL_GLContext
public typealias GLattr = SDL_GLattr

public typealias AudioStatus = SDL_AudioStatus
//public typealias AudioFormat = SDL_AudioFormat
public typealias AudioSpect = SDL_AudioSpec

public typealias XXPixelFormat = UInt32

public struct AudioFormat : OptionSet {
	public let rawValue : UInt16
	public init(rawValue: UInt16 = 0) { self.rawValue = rawValue }

	public static let F32 = AudioFormat(rawValue: UInt16(AUDIO_F32))
}

public struct AudioChange : OptionSet {
	public let rawValue : Int32
	public init(rawValue: Int32 = 0) { self.rawValue = rawValue }

	public static let NONE = AudioChange(rawValue: 0)
	public static let FREQUENCY = AudioChange(rawValue: Int32(SDL_AUDIO_ALLOW_FREQUENCY_CHANGE))
	public static let FORMAT = AudioChange(rawValue: Int32(SDL_AUDIO_ALLOW_FORMAT_CHANGE))
	public static let CHANNELS = AudioChange(rawValue: Int32(SDL_AUDIO_ALLOW_CHANNELS_CHANGE))
	public static let ANY = AudioChange(rawValue: Int32(SDL_AUDIO_ALLOW_FREQUENCY_CHANGE | SDL_AUDIO_ALLOW_FORMAT_CHANGE | SDL_AUDIO_ALLOW_CHANNELS_CHANGE))
}

public struct WindowFlags : OptionSet {
	public let rawValue : UInt32
	public init(rawValue: UInt32 = 0) { self.rawValue = rawValue }

	public static let FULLSCREEN = WindowFlags(rawValue: UInt32(SDL_WINDOW_FULLSCREEN))
	public static let FULLSCREEN_DESKTOP = WindowFlags(rawValue: UInt32(SDL_WINDOW_FULLSCREEN_DESKTOP))
	public static let OPENGL = WindowFlags(rawValue: UInt32(SDL_WINDOW_OPENGL))
	public static let SHOWN = WindowFlags(rawValue: UInt32(SDL_WINDOW_SHOWN))
	public static let HIDDEN = WindowFlags(rawValue: UInt32(SDL_WINDOW_HIDDEN))
	public static let BORDERLESS = WindowFlags(rawValue: UInt32(SDL_WINDOW_BORDERLESS))
	public static let RESIZABLE = WindowFlags(rawValue: UInt32(SDL_WINDOW_RESIZABLE))
	public static let MINIMIZED = WindowFlags(rawValue: UInt32(SDL_WINDOW_MINIMIZED))
	public static let MAXIMIZED = WindowFlags(rawValue: UInt32(SDL_WINDOW_MAXIMIZED))
	public static let INPUT_GRABBED = WindowFlags(rawValue: UInt32(SDL_WINDOW_INPUT_GRABBED))
	public static let INPUT_FOCUS = WindowFlags(rawValue: UInt32(SDL_WINDOW_INPUT_FOCUS))
	public static let MOUSE_FOCUS = WindowFlags(rawValue: UInt32(SDL_WINDOW_MOUSE_FOCUS))
	public static let FOREIGN = WindowFlags(rawValue: UInt32(SDL_WINDOW_FOREIGN))
	public static let ALLOW_HIGHDPI = WindowFlags(rawValue: UInt32(SDL_WINDOW_ALLOW_HIGHDPI))
	public static let MOUSE_CAPTURE = WindowFlags(rawValue: UInt32(SDL_WINDOW_MOUSE_CAPTURE))
	
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

	public static let TIMER = InitOptions(rawValue: UInt32(SDL_INIT_TIMER))
	public static let AUDIO = InitOptions(rawValue: UInt32(SDL_INIT_AUDIO))
	public static let VIDEO = InitOptions(rawValue: UInt32(SDL_INIT_VIDEO))
	public static let JOYSTICK = InitOptions(rawValue: UInt32(SDL_INIT_JOYSTICK))
	public static let HAPTIC = InitOptions(rawValue: UInt32(SDL_INIT_HAPTIC))
	public static let GAMECONTROLLER = InitOptions(rawValue: UInt32(SDL_INIT_GAMECONTROLLER))
	public static let EVENTS = InitOptions(rawValue: UInt32(SDL_INIT_EVENTS))
	public static let EVERYTHING = InitOptions(rawValue: UInt32(SDL_INIT_TIMER | SDL_INIT_AUDIO | SDL_INIT_VIDEO | SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC | SDL_INIT_GAMECONTROLLER | SDL_INIT_EVENTS))
}