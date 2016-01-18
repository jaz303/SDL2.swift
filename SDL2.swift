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

public func Init() -> Bool {
	if SDL_Init(Uint32(SDL_INIT_VIDEO)) < 0 {
		print("error initialising SDL");
		return false
	}
	return true
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

	public func _sdlWindow() -> COpaquePointer {
		return theWindow
	}

	let theWindow: COpaquePointer
}

public func createWindowAndWait() {

	var evt = SDL_Event();
	while true {
		SDL_WaitEvent(&evt);
		if evt.type == Uint32(K_SDL_WINDOWEVENT) && evt.window.event == Uint8(K_SDL_WINDOWEVENT_CLOSE) {
			break;
		}
	}

	//SDL_DestroyWindow(win);
	SDL_Quit();

}

//
// Surface

public class Surface {
	public init(width: Int, height: Int, depth: Int, rmask: UInt32, gmask: UInt32, bmask:UInt32, amask:UInt32) {
		theSurface = SDL_CreateRGBSurface(0, Int32(width), Int32(height), Int32(depth), rmask, gmask, bmask, amask)
	}

	public init(sdlSurface: UnsafeMutablePointer<SDL_Surface>) {
		theSurface = sdlSurface
	}

	public func _sdlSurface() -> UnsafeMutablePointer<SDL_Surface> {
		return theSurface
	}

	let theSurface:UnsafeMutablePointer<SDL_Surface>
}

//
// Image Loading

