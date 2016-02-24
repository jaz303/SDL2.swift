import CSDL2

// TODO: cache pixel formats created in forNativeFormat()
// TODO: everything palette related
// TODO: SDL_MasksToPixelFormatEnum(), SDL_PixelFormatEnumToMasks()
// TODO: cache this
// TODO: pixel format enums

public class PixelFormats {
	public static let ARGB8888: UInt32 = UInt32(SDL_PIXELFORMAT_ARGB8888)

	public class func forFormat(format: UInt32) -> PixelFormat {
		return PixelFormat(format: SDL_AllocFormat(format))
	}
}

public class PixelFormat {
	public class func forNativeFormat(format: UnsafeMutablePointer<SDL_PixelFormat>) -> PixelFormat {
		return PixelFormat(format: format)
	}

	init(format: UnsafeMutablePointer<SDL_PixelFormat>) {
		theFormat = format
	}

	public var format: UInt32 {
		get { return theFormat.memory.format }
	}

	public var name: String {
		get { return String.fromCString(SDL_GetPixelFormatName(self.format))! }
	}

	public func getColorComponents(color: UInt32, inout r: UInt8, inout g: UInt8, inout b: UInt8) {
		SDL_GetRGB(color, theFormat, &r, &g, &b)
	}

	public func getColorComponents(color: UInt32, inout r: UInt8, inout g: UInt8, inout b: UInt8, inout a: UInt8) {
		SDL_GetRGBA(color, theFormat, &r, &g, &b, &a)
	}

	public func mapColor(r r: UInt8, g: UInt8, b: UInt8) -> UInt32 {
		return SDL_MapRGB(theFormat, r, g, b)
	}

	public func mapColor(r r: UInt8, g: UInt8, b: UInt8, a: UInt8) -> UInt32 {
		return SDL_MapRGBA(theFormat, r, g, b, a)
	}

	public func sdlPixelFormat() -> UnsafeMutablePointer<SDL_PixelFormat> {
		return theFormat
	}

	let theFormat: UnsafeMutablePointer<SDL_PixelFormat>
}