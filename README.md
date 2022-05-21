# OpenDoor

An iOS ARKit-based Indoor Positioning System.

## Install

Install using the Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/pascalbros/OpenDoor.git", .upToNextMajor(from: "1.0.0"))
]

```

## Example

Create an instance:

```Swift
let openDoor = OpenDoorManager()
openDoor.dataSource = self
openDoor.delegate = self
```

Setup the references:

```swift
let floor = ODFloor(name: "Second", floor: 2, picture: nil, picturePath: nil, oneMeterInPixels: 100)
let reference = ODImageReference(identifier: "my-id", image: UIImage.myAsset, imagePath: nil, position: CGPoint(x: 100, y: 100), floor: floor, physicalWidth: 0.1)
```

Implement `OpenDoorDataSource`:

```swift
openDoor.dataSource = CustomOpenDoorDataSource()
openDoor.loadReferences([reference])
```

```swift
extension MyObject: OpenDoorDataSource {
    func recognizeAnchor(name: String) -> ODImageReference? {
        nil
    }
}
```

Implements the delegate `OpenDoorDelegate`:

```swift
extension MyObject: OpenDoorDelegate {
    func openDoor(_ manager: OpenDoorManager, didUpdateLocation location: ODLocation) {
        print(location)
    }
}
```

Run:

```swift
openDoor.start()
```