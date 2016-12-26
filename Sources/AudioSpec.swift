import CSDL2

public typealias AudioSpec = SDL_AudioSpec
extension AudioSpec {
	public var frequency: Int32 {
		get { return freq }
		set(newFrequency) { freq = newFrequency }
	}

	// NOTE: this is leaky and probably very, very illegal
	// TODO: we should return a token that can be used to destroy the callback
	mutating public func setCallback<C,T>(context: C, callback: @escaping AudioCallback<C,T>) {
		let opq = Unmanaged.passRetained(CallbackShim(context, callback, Int32(MemoryLayout<T>.stride))).toOpaque()
		let mut = UnsafeMutableRawPointer(opq)
		self.userdata = mut
		self.callback = { (userdata, data, numBytes) in
			let opq = UnsafeRawPointer(userdata)!
			let box: CallbackShim<AnyObject,UInt8> = Unmanaged.fromOpaque(opq).takeUnretainedValue()
			let elemCount = Int(numBytes / box.sz)
			box.cb(box.ctx, Array(UnsafeBufferPointer(start: data, count: elemCount)))
		}
	}
}

class CallbackShim<C,T> {
	init(_ ctx: C, _ cb: @escaping AudioCallback<C,T>, _ elementSize: Int32) {
		self.ctx = ctx
		self.cb = cb
		self.sz = elementSize
	}
	let ctx: C
	let cb: AudioCallback<C,T>
	let sz: Int32
}
