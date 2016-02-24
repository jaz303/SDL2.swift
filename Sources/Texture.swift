import CSDL2

public class Texture {
	init(sdlTexture: COpaquePointer) {
		theTexture = sdlTexture
		var w: Int32 = 0, h: Int32 = 0
		SDL_QueryTexture(theTexture, nil, nil, &w, &h)
		width = Int(w)
		height = Int(h)
	}

	deinit {
		SDL_DestroyTexture(theTexture)
	}

	/**
	 * Copy image data from surface to the texture.
	 *
	 * This method provides a bridge between software and hardware rendering.
	 *
	 * Assumes surface and texture have same size and pixel format.
	 *
	 * FIXME: will probably break horribly if assumptions are breached.
	 */
	public func copyFromSurface(surface: Surface) {
		SDL_UpdateTexture(
			theTexture,
			nil,
			surface._sdlSurface().memory.pixels,
			surface._sdlSurface().memory.pitch
		)
	}

	//public func lock() {
	//	SDL_LockTexture(theTexture)
	//}

	public func unlock() {
		SDL_UnlockTexture(theTexture)
	}

	public func _sdlTexture() -> COpaquePointer {
		return theTexture
	}

	public let width: Int
	public let height: Int

	let theTexture: COpaquePointer
}