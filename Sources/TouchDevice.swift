import CSDL2

public struct TouchDevice {
	init(deviceID: SDL_TouchID) {
		self.deviceID = deviceID
	}

	public func numberOfActiveFingers() -> Int {
		return Int(SDL_GetNumTouchFingers(deviceID))
	}

	let deviceID: SDL_TouchID
}