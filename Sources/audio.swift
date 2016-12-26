import CSDL2

// Quite a lot missing here; going to wait until I've looked at SDL_mixer
// before deciding on the best approach
//
// TODO: SDL_MixAudioFormat- not sure if any point in implementing
//
// TODO: SDL_BuildAudioCVT
// TODO: SDL_ConvertAudio
//
// TODO: wave file handling, need to think about how to do this properly
//  - SDL_FreeWAV
//  - SDL_LoadWAV
//  - SDL_LoadWAV_RW

extension sdl {
	public class audio {
		public static func start(driverName: String) -> Bool {
			return SDL_AudioInit(driverName) == 0
		}

		public static func quit() {
			SDL_AudioQuit()
		}

		public static var currentDriverName: String? {
			let cstr = SDL_GetCurrentAudioDriver()
			return (cstr == nil) ? nil : String(cString: cstr!)
		}

		public static var playbackDeviceCount: Int {
			get { return Int(SDL_GetNumAudioDevices(0)) }
		}

		public static var captureDeviceCount: Int {
			get { return Int(SDL_GetNumAudioDevices(1)) }
		}

		public static var driverCount: Int {
			get { return Int(SDL_GetNumAudioDrivers()) }
		}

		public static func playbackDeviceAtIndex(_ index: Int) -> String {
			return String(cString: SDL_GetAudioDeviceName(Int32(index), 0))
		}

		public static func captureDeviceAtIndex(_ index: Int) -> String {
			return String(cString: SDL_GetAudioDeviceName(Int32(index), 1))
		}

		public static func driverNameAtIndex(_ index: Int) -> String {
			return String(cString: SDL_GetAudioDriver(Int32(index)))
		}

		public static func openDefaultPlaybackDevice(spec: AudioSpec, allowedChanges: AudioChange = AudioChange.NONE) -> AudioDevice? {
			return openPlaybackDevice(device: nil, spec: spec, allowedChanges: allowedChanges)
		}

		public static func openDefaultCaptureDevice(spec: AudioSpec, allowedChanges: AudioChange = AudioChange.NONE) -> AudioDevice? {
			return openCaptureDevice(device: nil, spec: spec, allowedChanges: allowedChanges)
		}

		public static func openPlaybackDevice(device: String?, spec: AudioSpec, allowedChanges: AudioChange = AudioChange.NONE) -> AudioDevice? {
			var desiredSpec : AudioSpec = spec
			var obtainedSpec : AudioSpec = AudioSpec()
			let res = SDL_OpenAudioDevice(device, 0, &desiredSpec, &obtainedSpec, allowedChanges.rawValue)
			if res == 0 {
				return nil
			} else {
				return AudioDevice(id: res, spec: obtainedSpec)
			}
		}

		public static func openCaptureDevice(device: String?, spec: AudioSpec, allowedChanges: AudioChange = AudioChange.NONE) -> AudioDevice? {
			var desiredSpec : AudioSpec = spec
			var obtainedSpec : AudioSpec = AudioSpec()
			let res = SDL_OpenAudioDevice(device, 1, &desiredSpec, &obtainedSpec, allowedChanges.rawValue)
			if res == 0 {
				return nil
			} else {
				return AudioDevice(id: res, spec: obtainedSpec)
			}
		}
	}
}