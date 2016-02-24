import CSDL2

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

public func calculateGammaRamp(gamma: Float, ramp: [UInt16]) {
	// TODO: get unsafe pointer
	// SDL_CalculateGammaRamp(gamma, ramp)
}

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
