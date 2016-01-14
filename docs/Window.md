### Create a new `Window`

```swift
let window = Window()
let window = Window(title: "Hello from SDL")
let window = Window(width: 1024, height: 768)
let window = Windoo(title: "Boom!", width: 600, height: 200)
```

### Show/hide `Window`

```swift
window.show()
window.hide()
```

### Get `Window` attributes

```swift
window.id
window.width
window.height
window.title
```

### Resize `Window`

```swift
window.setWidth(1024, height: 768)
```

### Message box

```swift
// Valid MesageBoxTypes: Error, Warning, Information
window.showMessageBox(MessageBoxType.Warning, title: "Hello", message: "This is a message")
```
