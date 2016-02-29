import CSDL2

public typealias TimerCallback = (Int) -> (Int)
public typealias TimerID = SDL_TimerID
public typealias Event = SDL_Event
public typealias EventType = SDL_EventType
public typealias EventFilterCallback = (inout Event) -> Bool
public typealias EventWatchCallback = (inout Event) -> ()
public typealias TouchID = SDL_TouchID
