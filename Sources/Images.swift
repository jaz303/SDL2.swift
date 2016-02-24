import CSDL2

public class Images {
	// TODO: think about error handling here; would throwing be more appropriate?
	public class func load(file: String) -> Surface? {
		let theSurface = IMG_Load(file)
		if theSurface == nil {
			return nil
		} else {
			return Surface(sdlSurface: theSurface)
		}
	}
}
