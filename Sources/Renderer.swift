import CSDL2

// TODO: support flags
// TODO: support index
public class Renderer {
	public init(window: Window) {
		theRenderer = SDL_CreateRenderer(window._sdlWindow(), -1, UInt32(0))
		theWindow = window
	}

	deinit {
		SDL_DestroyRenderer(theRenderer)
	}

	public func _sdlRenderer() -> COpaquePointer {
		return theRenderer
	}

	public func clear() {
		SDL_RenderClear(theRenderer)
	}

	public func present() {
		SDL_RenderPresent(theRenderer)
	}

	public func createTextureFromSurface(surface: Surface) -> Texture {
		let tex = SDL_CreateTextureFromSurface(theRenderer, surface._sdlSurface())
		return Texture(sdlTexture: tex)
	}

	public func createStreamingTexture(width width: Int, height: Int) -> Texture {
		let tex = SDL_CreateTexture(
			theRenderer,
			Uint32(SDL_PIXELFORMAT_ARGB8888),
			K_SDL_TEXTUREACCESS_STREAMING,
			Int32(width),
			Int32(height)
		)
		return Texture(sdlTexture: tex)
	}

	public func setDrawColorRed(red: Uint8, green: Uint8, blue: Uint8, alpha: Uint8 = 255) {
		SDL_SetRenderDrawColor(theRenderer, red, green, blue, alpha)
	}

	public func copyTexture(texture: Texture) {
		SDL_RenderCopy(theRenderer, texture._sdlTexture(), nil, nil)
	}

	public func copyTexture(texture: Texture, sourceRect: Rect, destinationRect: Rect) {
		var s = sourceRect
		var d = destinationRect
		SDL_RenderCopy(theRenderer, texture._sdlTexture(), &s, &d)
	}

	public func copyTexturePtr(texture: Texture, inout sourceRect: Rect, inout destinationRect: Rect) {
		SDL_RenderCopy(theRenderer, texture._sdlTexture(), &sourceRect, &destinationRect)
	}

	public func drawLineX1(x1: Int, y1: Int, x2: Int, y2: Int) {
		SDL_RenderDrawLine(theRenderer, Int32(x1), Int32(y1), Int32(x2), Int32(y2))
	}

	public func drawPointX(x: Int, y: Int) {
		SDL_RenderDrawPoint(theRenderer, Int32(x), Int32(y))
	}

	public func drawRect(rect: Rect) {
		var r = rect
		SDL_RenderDrawRect(theRenderer, &r)
	}

	public func drawRectPtr(inout rect: Rect) {
		SDL_RenderDrawRect(theRenderer, &rect)
	}

	public func fillRect(rect: Rect) {
		var r = rect
		SDL_RenderFillRect(theRenderer, &r)
	}

	public func fillRectPtr(inout rect: Rect) {
		SDL_RenderFillRect(theRenderer, &rect)
	}

	let theRenderer: COpaquePointer
	let theWindow: Window
}