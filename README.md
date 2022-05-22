# OpenDoor

An iOS, infrastructure-less ARKit-based Indoor Positioning System.

OpenDoor works with explicit and implicit markers.
The first position fix is given by one of the markers found during the AR session, supports multiple floors building and custom injection of a location fix.

## Install

Install using the Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/pascalbros/OpenDoor.git", .upToNextMajor(from: "0.4.0"))
]

```

## Example

Create an instance:

```swift
let openDoor = OpenDoorManager()
openDoor.dataSource = self
openDoor.delegate = self
```

Setup explicit markers:
```swift
openDoor.shouldRecognizeImplicitMarkers = true
```

Setup implicit markers:

```swift
let floor = ODFloor(name: "Second", floor: 2, oneMeterInPixels: 100)
let reference = ODImageReference(identifier: "my-id", image: UIImage(named: " my-asset")!, imagePath: nil, position: CGPoint(x: 100, y: 100), floor: floor, physicalWidth: 0.1)
```

Implement `OpenDoorDataSource`:

```swift
openDoor.dataSource = CustomOpenDoorDataSource()
openDoor.loadReferences([reference])
```

```swift
extension MyObject: OpenDoorDataSource {
    func recognizeAnchor(name: String) -> ODReference? {
        nil
    }
}
```

Implement the delegate `OpenDoorDelegate`:

```swift
extension MyObject: OpenDoorDelegate {
    func openDoor(_ manager: OpenDoorManager, didUpdateFloor floor: ODFloor) {
        print("New floor: \(floor.name)")
    }
    
    func openDoor(_ manager: OpenDoorManager, didUpdateLocation location: ODLocation) {
        print("New location: \(location)")
    }
}
```

Run:

```swift
openDoor.start()
```

# License

OpenDoor is licensed under the terms of the MIT License. Please see the `LICENSE.md` file for full details.
