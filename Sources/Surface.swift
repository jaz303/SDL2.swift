import CSDL2

// TODO: SDL_ConvertSurface
// TODO: SDL_CreateRGBSurfaceFrom
// TODO: SDL_(Get|Set)ColorKey
// TODO: SDL_(Get|Set)SurfaceAlphaMod
// TODO: SDL_(Get|Set)SurfaceBlendMode
// TODO: SDL_(Get|Set)SurfaceColorMod
// TODO: SDL_LowerBlit
// TODO: SDL_MUSTLOCK
public class Surface {
	public init(width: Int,
				height: Int,
				depth: Int = 32,
				rmask: UInt32 = 0x00FF0000,
				gmask: UInt32 = 0x0000FF00,
				bmask:UInt32 = 0x000000FF,
				amask:UInt32 = 0xFF000000) {
		theSurface = SDL_CreateRGBSurface(0, Int32(width), Int32(height), Int32(depth), rmask, gmask, bmask, amask)
		owned = true
		pixelFormat = PixelFormat.forNativeFormat(theSurface.memory.format)
	}

	public init(sdlSurface: UnsafeMutablePointer<SDL_Surface>, takeOwnership: Bool = true) {
		theSurface = sdlSurface
		owned = takeOwnership
		pixelFormat = PixelFormat.forNativeFormat(theSurface.memory.format)
	}

	deinit {
		if (owned) {
			SDL_FreeSurface(theSurface)
		}
	}

	public var width: Int {
		get { return Int(theSurface.memory.w) }
	}

	public var height: Int {
		get { return Int(theSurface.memory.h) }
	}

	public var pitch: Int {
		get { return Int(theSurface.memory.pitch) }
	}

	public var pixels: UnsafeMutablePointer<UInt8> {
		get {
			let ptr = COpaquePointer(theSurface.memory.pixels)
			return UnsafeMutablePointer<UInt8>(ptr)
		}
	}

	public func convertedToPixelFormat(pixelFormat: PixelFormat) -> Surface {
		return Surface(sdlSurface: SDL_ConvertSurface(theSurface, pixelFormat.sdlPixelFormat(), Uint32(0)))
	}

	/*
	 * Plot a pixel on the surface, assuming that the underyling SDL surface
	 * representation uses 32 bits per pixel. The pixel value is written
	 * unaltered, i.e. no color format conversion is performed.
	 *
	 * FIXME: this assumes 4 bytes per pixel
	 * FIXME: endianness issues?
	 */
	public func putPixel32(x: Int, _ y: Int, _ color: Uint32) {
		let px = UnsafeMutablePointer<UInt8>(COpaquePointer(theSurface.memory.pixels))
		let pitch = theSurface.memory.pitch
		let offset = (y * Int(pitch)) + (x * 4)
		px[offset + 0] = UInt8((color >> 24) & 0xFF)
		px[offset + 1] = UInt8((color >> 16) & 0xFF)
		px[offset + 2] = UInt8((color >>  8) & 0xFF)
		px[offset + 3] = UInt8((color >>  0) & 0xFF)
	}

	public func colorKey() -> UInt32 {
		var color: UInt32 = 0
		SDL_GetColorKey(theSurface, &color)
		return color
	}

	public func copyColorKeyTo(inout color: UInt32) -> Bool {
		return SDL_GetColorKey(theSurface, &color) != 1
	}

	public func disableColorKey() {
		SDL_SetColorKey(theSurface, 0, 0)
	}

	public func enableColorKey(color: UInt32) {
		SDL_SetColorKey(theSurface, 1, color)
	}

	public func lock() {
		SDL_LockSurface(theSurface)
	}

	public func unlock() {
		SDL_UnlockSurface(theSurface)
	}

	public func fillRect(inout rect: Rect, color: UInt32) {
		SDL_FillRect(theSurface, &rect, color)
	}

	public func fillRects(rects: [Rect], color: UInt32) {
		SDL_FillRects(theSurface, rects, Int32(rects.count), color)
	}

	public func clipRect() -> Rect {
		var r = Rect()
		SDL_GetClipRect(theSurface, &r)
		return r
	}

	public func clipRect(inout rect: Rect) {
		SDL_GetClipRect(theSurface, &rect)
	}

	public func clearClipRect() {
		SDL_SetClipRect(theSurface, nil)
	}

	public func setClipRect(inout rect: Rect) {
		SDL_SetClipRect(theSurface, &rect)
	}

	public func blitSurface(source: Surface, inout srcRect : Rect, inout destRect: Rect) {
		SDL_UpperBlit(source._sdlSurface(), &srcRect, theSurface, &destRect)
	}

	public func blitSurface(source: Surface, inout destRect: Rect) {
		SDL_UpperBlit(source._sdlSurface(), nil, theSurface, &destRect)
	}

	public func blitSurface(source: Surface, x: Int, y: Int) {
		var r = SDL_Rect(
			x: Int32(x),
			y: Int32(y),
			w: theSurface.memory.w,
			h: theSurface.memory.h
		)
		SDL_UpperBlit(source._sdlSurface(), nil, theSurface, &r)
	}

	public func _sdlSurface() -> UnsafeMutablePointer<SDL_Surface> {
		return theSurface
	}

	public let pixelFormat: PixelFormat
	let theSurface: UnsafeMutablePointer<SDL_Surface>
	let owned: Bool

}