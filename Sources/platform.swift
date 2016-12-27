import CSDL2

public extension sdl {
	public class platform {
		public static var name: String {
			get { return String(cString: SDL_GetPlatform()) }
		}
	}
}