import CSDL2

public extension sdl {
	public class byteorder {
		public static func swap(_ val: Float) -> Float { return SDL_SwapFloat(val) }
		public static func swap(_ val: UInt16) -> UInt16 { return SDL_Swap16(val) }
		public static func swap(_ val: UInt32) -> UInt32 { return SDL_Swap32(val) }
		public static func swap(_ val: UInt64) -> UInt64 { return SDL_Swap64(val) }

		// public static func bigEndianToHost(_ val: Float) -> Float { return SDL_SwapFloatBE(val) }
		// public static func bigEndianToHost(_ val: UInt16) -> UInt16 { return SDL_SwapBE16(val) }
		// public static func bigEndianToHost(_ val: UInt32) -> UInt32 { return SDL_SwapBE32(val) }
		// public static func bigEndianToHost(_ val: UInt64) -> UInt64 { return SDL_SwapBE64(val) }

		// public static func littleEndianToHost(_ val: Float) -> Float { return SDL_SwapFloatLE(val) }
		// public static func littleEndianToHost(_ val: UInt16) -> UInt16 { return SDL_SwapLE16(val) }
		// public static func littleEndianToHost(_ val: UInt32) -> UInt32 { return SDL_SwapLE32(val) }
		// public static func littleEndianToHost(_ val: UInt64) -> UInt64 { return SDL_SwapLE64(val) }
	}
}