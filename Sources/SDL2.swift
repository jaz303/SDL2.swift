import CSDL2

public class sdl {}

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
	case Error = 0x00000010 // SDL_MESSAGEBOX_ERROR
	case Warning = 0x00000020 // SDL_MESSAGEBOX_WARNING
	case Information = 0x00000040 // SDL_MESSAGEBOX_INFORMATION
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

public func calculateGammaRamp(gamma: Float, ramp: [UInt16]) {
	// TODO: get unsafe pointer
	// SDL_CalculateGammaRamp(gamma, ramp)
}

public extension sdl {
	// REVIEW: should this throw on failure?
	@discardableResult public class func start() -> Bool {
		return start(subsystems: InitOptions.EVERYTHING)
	}

	// REVIEW: should this throw on failure?
	public class func start(subsystems: InitOptions) -> Bool {
		return SDL_Init(subsystems.rawValue) >= 0
	}

	public class func quit() {
		SDL_Quit()
	}

	public class func waitForQuit() {
		var evt = Event()
		while true {
			Events.wait(evt: &evt)
			if evt.isQuit {
				break
			}
		}
	}

	public static func clearError() {
		SDL_ClearError()
	}

	public static func getError() -> String {
		return String(cString: SDL_GetError())
	}
}
