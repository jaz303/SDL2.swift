import CSDL2

public class Timers {
	public class func delay(delay: Int) {
		SDL_Delay(UInt32(delay))
	}

	public class func setTimeout(delay: Int, callback: (AnyObject?) -> Void) -> Int32 {
		//SDL_AddTimer(UInt32(delay), handleTimeout, nil)
		return 0
	}

	public class func clearTimeout(timerId : Int32) -> Bool {
		return SDL_RemoveTimer(timerId) == SDL_TRUE
	}

	public class func getPerformanceCounter() -> UInt64 {
		return SDL_GetPerformanceCounter()
	}

	public class func getPerformanceFrequency() -> UInt64 {
		return SDL_GetPerformanceFrequency()
	}

	public class func getTicks() -> UInt32 {
		return SDL_GetTicks()
	}
}

func handleTimeout(interval: UInt32, userData: COpaquePointer) {
	
}

/*
func handleTimeout(t: Timeout) {
	t.callback(t.userData)
}
*/

struct Timeout {
	let callback: (AnyObject?) -> Void
	let sdlTimerId: Int32
	let userData: AnyObject? 
}