import CSDL2

public class sdl {
	public class func delay(delay: Int) {
		SDL_Delay(UInt32(delay))
	}

	// FIXME
	// public class func setTimeout(delay: Int, callback: TimerCallback) -> TimerID {
	// 	let box = Box(callback)
	// 	let opq = Unmanaged.passRetained(box).toOpaque()
	// 	let mut = UnsafeMutableRawPointer(opq)
	// 	return SDL_AddTimer(UInt32(delay), { (delay,userdata) in
	// 		let opq = OpaquePointer(userdata)
	// 		let box: Box<TimerCallback> = Unmanaged
	// 										.fromOpaque(opq)!
	// 										.takeRetainedValue()
	// 		return UInt32(box.value(Int(delay)))
	// 	}, mut)
	// }

	public class func clearTimeout(timerId: TimerID) -> Bool {
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
