import CSDL2

public class sdl {
	public class func delay(delay: Int) {
		SDL_Delay(UInt32(delay))
	}

	public class func setTimeout(delay: Int, callback: TimerCallback) -> TimerID {
		let box = Box(callback)
		let opq = Unmanaged.passRetained(box).toOpaque()
		let mut = UnsafeMutablePointer<Void>(opq)
		return SDL_AddTimer(UInt32(delay), { (delay,userdata) in
			let opq = COpaquePointer(userdata)
			let box: Box = Unmanaged
							.fromOpaque(opq)
							.takeRetainedValue()
			return UInt32(box.value(Int(delay)))
		}, mut)
	}

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

class Box {
	init(_ v: TimerCallback) { value = v }
	let value: TimerCallback
}