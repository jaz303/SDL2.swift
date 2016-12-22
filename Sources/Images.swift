import CSDL2

// TODO: Images.load() should throw on failure
// (this seems to be the idiomatic thing to do now)

public class Images {
	public class func load(file: String) -> Surface? {
		let theSurface = IMG_Load(file)
		if theSurface == nil {
			return nil
		} else {
			return Surface(sdlSurface: theSurface!)
		}
	}
}
