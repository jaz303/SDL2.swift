import CSDL2

// TODO: SDL_GetKeyboardFocus - need SDL_Window* -> Window mapping
// TODO: SDL_GetKeyboardState - need a wrapper class for keyboard state
// TODO: SDL_GetModState - need enum repr
// TODO: SDL_SetModState - need enum repr

public class Keyboard {

	//
	// Conversion

	public static func keyForName(name: String) -> Keycode? {
		let kc = SDL_GetKeyFromName(name)
		return (kc == Int32(SDLK_UNKNOWN)) ? nil : kc
	}

	public static func keyForScancode(scancode: Scancode) -> Keycode? {
		let kc = SDL_GetKeyFromScancode(scancode)
		return (kc == Int32(SDLK_UNKNOWN)) ? nil : kc
	}

	public static func nameForKey(keycode: Keycode) -> String? {
		let str = String.fromCString(SDL_GetKeyName(keycode))!
		return (str == "") ? nil : str
	}

	public static func nameForScancode(scancode: Scancode) -> String? {
		let str = String.fromCString(SDL_GetScancodeName(scancode))
		return (str == "") ? nil : str
	}

	public static func scancodeForKey(keycode: Keycode) -> Scancode? {
		let sc = SDL_GetScancodeFromKey(keycode)
		return (sc == SDL_SCANCODE_UNKNOWN) ? nil : sc
	}

	public static func scancodeForName(name: String) -> Scancode? {
		let sc = SDL_GetScancodeFromName(name)
		return (sc == SDL_SCANCODE_UNKNOWN) ? nil : sc
	}

	//
	// Screen keyboard

	public static func isScreenKeyboardSupported() -> Bool {
		return SDL_HasScreenKeyboardSupport() == SDL_TRUE
	}

	public static func isScreenKeyboardShownOnWindow(window: Window) -> Bool {
		return SDL_IsScreenKeyboardShown(window._sdlWindow()) == SDL_TRUE	
	}

	//
	// Text input

	public static func isTextInputActive() -> Bool {
		return SDL_IsTextInputActive() == SDL_TRUE	
	}

	public static func startTextInput() {
		SDL_StartTextInput()
	}

	public static func stopTextInput() {
		SDL_StopTextInput()
	}

	public static func setTextInputRect(inout rect: Rect) {
		SDL_SetTextInputRect(&rect)
	}

}