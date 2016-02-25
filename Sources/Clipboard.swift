import CSDL2

public class Clipboard {
	public static func hasText() -> Bool {
		return SDL_HasClipboardText() == SDL_TRUE
	}

	public static func getText() -> String? {
		return String.fromCString(SDL_GetClipboardText())
	}

	public static func setText(text: String) {
		SDL_SetClipboardText(text)
	}
}