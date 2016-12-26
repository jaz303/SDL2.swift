import CSDL2

// TODO: dequeue (need SDL 2.0.5)

public class AudioDevice {
	public init(id: SDL_AudioDeviceID, spec: AudioSpec) {
		self.id = id
		self.spec = spec
		self.closed = false
	}

	deinit {
		close()
	}

	public var status: AudioStatus {
		get { return SDL_GetAudioDeviceStatus(id) }
	}

	public func close() {
		if !self.closed {
			SDL_CloseAudioDevice(id)
			closed = true
		}
	}

	public func pause() {
		setPaused(true)
	}

	public func resume() {
		setPaused(false)
	}

	public func setPaused(_ paused: Bool) {
		SDL_PauseAudioDevice(id, paused ? 1 : 0)
	}

	public func queuedAudioSize() -> UInt32 {
		return SDL_GetQueuedAudioSize(id)
	}

	public func lock() {
		SDL_LockAudioDevice(id)
	}

	public func unlock() {
		SDL_UnlockAudioDevice(id)
	}

	public func clearQueuedAudio() {
		SDL_ClearQueuedAudio(id)
	}

	public func queueAudio(data: [Float]) -> Bool {
		return SDL_QueueAudio(id, data, UInt32(MemoryLayout<Float>.stride * data.count)) == 0
	}

	public func queueAudio(data: [UInt32]) -> Bool {
		return SDL_QueueAudio(id, data, UInt32(MemoryLayout<UInt32>.stride * data.count)) == 0
	}

	public func queueAudio(data: [UInt16]) -> Bool {
		return SDL_QueueAudio(id, data, UInt32(MemoryLayout<UInt16>.stride * data.count)) == 0
	}

	public func queueAudio(data: [UInt8]) -> Bool {
		return SDL_QueueAudio(id, data, UInt32(MemoryLayout<UInt8>.stride * data.count)) == 0
	}

	public func queueAudio(data: [Int32]) -> Bool {
		return SDL_QueueAudio(id, data, UInt32(MemoryLayout<Int32>.stride * data.count)) == 0
	}

	public func queueAudio(data: [Int16]) -> Bool {
		return SDL_QueueAudio(id, data, UInt32(MemoryLayout<Int16>.stride * data.count)) == 0
	}

	public func queueAudio(data: [Int8]) -> Bool {
		return SDL_QueueAudio(id, data, UInt32(MemoryLayout<Int8>.stride * data.count)) == 0
	}

	// public func dequeueAudio(data: [Float]) -> UInt32 {
	// 	return SDL_DeueueAudio(id, data, UInt32(MemoryLayout<Float>.stride * data.count))
	// }

	// public func dequeueAudio(data: [UInt32]) -> UInt32 {
	// 	return SDL_DeueueAudio(id, data, UInt32(MemoryLayout<UInt32>.stride * data.count))
	// }

	// public func dequeueAudio(data: [UInt16]) -> UInt32 {
	// 	return SDL_DequeueAudio(id, data, UInt32(MemoryLayout<UInt16>.stride * data.count))
	// }

	// public func dequeueAudio(data: [UInt8]) -> UInt32 {
	// 	return SDL_DequeueAudio(id, data, UInt32(MemoryLayout<UInt8>.stride * data.count))
	// }

	// public func dequeueAudio(data: [Int32]) -> UInt32 {
	// 	return SDL_DequeueAudio(id, data, UInt32(MemoryLayout<Int32>.stride * data.count))
	// }

	// public func dequeueAudio(data: [Int16]) -> UInt32 {
	// 	return SDL_DequeueAudio(id, data, UInt32(MemoryLayout<Int16>.stride * data.count))
	// }

	// public func dequeueAudio(data: [Int8]) -> UInt32 {
	// 	return SDL_DequeueAudio(id, data, UInt32(MemoryLayout<Int8>.stride * data.count))
	// }

	let id: SDL_AudioDeviceID
	let spec: AudioSpec
	var closed: Bool
}