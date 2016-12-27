import CSDL2

public extension sdl {
	public class cpu {
		public static var cacheLineSize: Int {
			get { return Int(SDL_GetCPUCacheLineSize()) }
		}

		public static var count: Int {
			get { return Int(SDL_GetCPUCount()) }
		}

		public static var systemRAM: Int {
			get { return Int(SDL_GetSystemRAM()) }
		}

		public static var has3DNow: Bool { get { return SDL_Has3DNow() == SDL_TRUE } }
		public static var hasAVX: Bool { get { return SDL_HasAVX() == SDL_TRUE } }
		public static var hasAVX2: Bool { get { return SDL_HasAVX2() == SDL_TRUE } }
		public static var hasAltiVec: Bool { get { return SDL_HasAltiVec() == SDL_TRUE } }
		public static var hasMMX: Bool { get { return SDL_HasMMX() == SDL_TRUE } }
		public static var hasRDTSC: Bool { get { return SDL_HasRDTSC() == SDL_TRUE } }
		public static var hasSSE: Bool { get { return SDL_HasSSE() == SDL_TRUE } }
		public static var hasSSE2: Bool { get { return SDL_HasSSE2() == SDL_TRUE } }
		public static var hasSSE3: Bool { get { return SDL_HasSSE3() == SDL_TRUE } }
		public static var hasSSE41: Bool { get { return SDL_HasSSE41() == SDL_TRUE } }
		public static var hasSSE42: Bool { get { return SDL_HasSSE42() == SDL_TRUE } }
	}
}