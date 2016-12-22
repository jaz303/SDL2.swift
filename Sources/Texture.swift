import CSDL2

// TODO: SDL_QueryTexture() - need a repr. for format/access
// TODO: updateRect() should have variants for different input types:
//   - [UInt8], [Int8], OpaquePointer, UnsafePointer<UInt8>, UnsafePointer<Int8>
// TODO: SDL_LockTexture() - need to decide on a return value

// TODO: blend mode - need wrapper
//  - SDL_SetTextureBlendMode
//  - SDL_GetTextureBlendMode

public class Texture {
	init(sdlTexture: OpaquePointer) {
		theTexture = sdlTexture
		var w: Int32 = 0, h: Int32 = 0
		SDL_QueryTexture(theTexture, nil, nil, &w, &h)
		width = Int(w)
		height = Int(h)
	}

	deinit {
		SDL_DestroyTexture(theTexture)
	}

	public func updateRect(rect: inout Rect, pixels: UnsafeRawPointer, pitch: Int) {
		SDL_UpdateTexture(theTexture, &rect, pixels, Int32(pitch))
	}

	public func copyAlphaModTo(alpha: inout UInt8) -> Bool {
		return SDL_GetTextureAlphaMod(theTexture, &alpha) == 0
	}

	public func setAlphaMod(alpha: UInt8) -> Bool {
		return SDL_SetTextureAlphaMod(theTexture, alpha) == 0
	}

	public func copyColorModTo( r r: inout UInt8, g: inout UInt8, b: inout UInt8) -> Bool {
		return SDL_GetTextureColorMod(theTexture, &r, &g, &b) == 0
	}

	public func setColorMod(r: UInt8, g: UInt8, b: UInt8) -> Bool {
		return SDL_SetTextureColorMod(theTexture, r, g, b) == 0
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
			surface._sdlSurface().pointee.pixels,
			surface._sdlSurface().pointee.pitch
		)
	}

	public func unlock() {
		SDL_UnlockTexture(theTexture)
	}

	public func _sdlTexture() -> OpaquePointer {
		return theTexture
	}

	public let width: Int
	public let height: Int

	let theTexture: OpaquePointer
}