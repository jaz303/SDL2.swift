# SDL2.swift

Work-in-progress SDL2 bindings for Swift.

## Usage notes

When first compiling a project that uses this package, the build will probably fail. To fix, run these commands, replacing `$VERSION` as necessary:

    $ cd Packages/SDL2.swift-$VERSION
    $ ./Hooks/post-install

This step is required because SDL uses `enum` and integers interchangably; as far as I can tell this isn't compatible with Swift's C interop. As a workaround, `constants.swift` is generated which defines suitably-typed integers for all SDL constants.

If SDL's prefix is not `/usr` you will need to update `support/sdl2-prefix` before running the post install script.

If the post install script fails you may need to update the configuration options in `support/gen.rb`.

## Example

```swift
import SDL2

SDL.start()

let win = Window(title: "Hello from SDL!", width: 1024, height: 768)
```