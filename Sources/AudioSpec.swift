import CSDL2

public class DummyContext {}
let theDummyContext = DummyContext()

public typealias AudioSpec = SDL_AudioSpec
extension AudioSpec {
	public var frequency: Int32 {
		get { return freq }
		set(newFrequency) { freq = newFrequency }
	}

	mutating public func setCallback(callback: @escaping AudioCallback<DummyContext>) {
		setCallback(context: theDummyContext, callback: callback)
	}

	mutating public func setCallback<C>(context: C, callback: @escaping AudioCallback<C>) {
		let opq = Unmanaged.passRetained(CallbackShim(context, callback)).toOpaque()
		let mut = UnsafeMutableRawPointer(opq)
		self.userdata = mut
		self.callback = { (userdata, data, numBytes) in
			let opq = UnsafeRawPointer(userdata)!
			let box: CallbackShim<AnyObject> = Unmanaged.fromOpaque(opq).takeUnretainedValue()
			box.cb(box.ctx, data!, Int(numBytes))
		}
	}

	mutating public func setCallback<T>(callback: @escaping AudioCallbackFoo<DummyContext,T>) {
		setCallback(context: theDummyContext, callback: callback)
	}

	mutating public func setCallback<C,T>(context: C, callback: @escaping AudioCallbackFoo<C,T>) {
		setCallback(context: context) { (ctx, data, length) in
			let elementCount = length / MemoryLayout<T>.stride
			data.withMemoryRebound(to: T.self, capacity: elementCount) { (data) in
				callback(ctx, UnsafeMutableBufferPointer<T>(start: data, count: elementCount))
			}
		}
	}
}

class CallbackShim<C> {
	init(_ ctx: C, _ cb: @escaping AudioCallback<C>) {
		self.ctx = ctx
		self.cb = cb
	}
	let ctx: C
	let cb: AudioCallback<C>
}
