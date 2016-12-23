import CSDL2

extension sdl {
	public class func delay(ms delay: Int) {
		SDL_Delay(UInt32(delay))
	}

	public class func setTimeout(delay: Int, callback: TimerCallback) -> TimerID {
		let opq = Unmanaged.passRetained(Box(callback)).toOpaque()
		let mut = UnsafeMutableRawPointer(opq)
		return SDL_AddTimer(UInt32(delay), { (delay,userdata) in
			let opq = UnsafeRawPointer(userdata)!
			let box: Box<TimerCallback> = Unmanaged
											.fromOpaque(opq)
											.takeRetainedValue()
			return UInt32(box.value(Int(delay)))
		}, mut)
	}

	// FIXME: think this might cause a memory leak as the callback will never
	// be released. Might need to maintain an internal map of timer IDs and
	// manage them manually...
	public class func clearTimeout(id timerId: TimerID) -> Bool {
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
