import CSDL2

public extension sdl {
    public static func setHintRenderScaleQualityNearestPixel() {
        SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "0")
    }

    public static func setHintRenderScaleQualityLinear() {
        SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "1")
    }

    public static func setHintRenderScaleQualityAnistropic() {
        SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "2")
    }
}