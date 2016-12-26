import CSDL2

public typealias AudioSpec = SDL_AudioSpec
extension AudioSpec {
	public var frequency: Int32 {
		get { return freq }
		set(newFrequency) { freq = newFrequency }
	}
}