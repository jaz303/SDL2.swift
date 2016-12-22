# SDL2.swift

Work-in-progress SDL2 bindings for Swift.

## Usage notes

When first compiling a project that uses this package, the build will probably fail. To fix, run these commands:

    $ cd Packages/SDL2.swift-*
    $ ./Hooks/post-install

This step is required because SDL uses `enum` and integers interchangably; as far as I can tell this isn't compatible with Swift's C interop. As a workaround, `constants.swift` is generated which defines suitably-typed integers for all SDL constants.

If SDL's prefix is not `/usr` you will need to update `support/sdl2-prefix` before running the post install script.

If the post install script fails you may need to update the configuration options in `support/gen.rb`.

## Example

Hello Triangle (requires OpenGL support, via [JFOpenGL](https://github.com/jaz303/JFOpenGL.swift))

```swift
import SDL2
import JFOpenGL

sdl.start()
defer { sdl.quit() }

let window = Window(title: "Hello world!", width: 800, height: 600, flags: WindowFlags.OPENGL)

let gl = sdl.gl.createContext(window: window)!
defer { sdl.gl.delete(context: gl) }

let vertexShader = "" +
	"attribute vec3 vp;" +
	"void main() {" +
	"  gl_Position = vec4(vp, 1.0);" +
	"}";

let fragmentShader = "" +
	"void main() {\n" +
	"  gl_FragColor = vec4(0.5, 0.0, 0.5, 1.0);\n" +
	"}";

let points : [GLfloat] = [
	0.0,  0.5,  0.0,
   	0.5, -0.5,  0.0,
   -0.5, -0.5,  0.0
]

var success : GLint = 0

var vbo : GLuint = 0
glGenBuffers(1, &vbo)
glBindBuffer(GL_ARRAY_BUFFER, vbo)
glBufferData(GL_ARRAY_BUFFER, 9 * MemoryLayout<GLfloat>.size, points, GL_STATIC_DRAW);

var vao : GLuint = 0
glGenVertexArrays(1, &vao)
glBindVertexArray(vao)
glEnableVertexAttribArray(0)
glBindBuffer(GL_ARRAY_BUFFER, vbo)
glVertexAttribPointer(0, 3, GL_FLOAT, false, 0, nil);

let vs = glCreateShader(GL_VERTEX_SHADER)
print(vertexShader)
glShaderSource(vs, vertexShader)
glCompileShader(vs)
glGetShaderiv(vs, GL_COMPILE_STATUS, &success)
print(success == GL_FALSE)

let fs = glCreateShader(GL_FRAGMENT_SHADER)
print(fragmentShader)
glShaderSource(fs, fragmentShader)
glCompileShader(fs)
glGetShaderiv(fs, GL_COMPILE_STATUS, &success)
print(success == GL_FALSE)

let prog = glCreateProgram()
glAttachShader(prog, fs)
glAttachShader(prog, vs)
glLinkProgram(prog)

glClearColor(1.0, 0.3, 0.1, 0)
glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
glUseProgram(prog)
glBindVertexArray(vao)
glDrawArrays(GL_TRIANGLES, 0, 3)

sdl.gl.swap(window: window)

var evt = Event()

while true {
	Events.wait(evt: &evt)
	if evt.isQuit {
		break
	}
}
```