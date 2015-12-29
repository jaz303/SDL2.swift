import CSDL2

public func createWindowAndWait() {

	if SDL_Init(Uint32(SDL_INIT_VIDEO)) < 0 {
		print("error initialising SDL");
	}

	let win = SDL_CreateWindow("Hello World", K_SDL_WINDOWPOS_UNDEFINED, K_SDL_WINDOWPOS_UNDEFINED, 640, 480, Uint32(K_SDL_WINDOW_SHOWN));
	if win == nil {
		print("error creating window");
	}

	var evt = SDL_Event();
	while true {
		SDL_WaitEvent(&evt);
		if evt.type == Uint32(K_SDL_WINDOWEVENT) && evt.window.event == Uint8(K_SDL_WINDOWEVENT_CLOSE) {
			break;
		}
	}

	SDL_DestroyWindow(win);
	SDL_Quit();

}