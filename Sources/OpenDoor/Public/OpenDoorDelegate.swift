import Foundation

public protocol OpenDoorDelegate: AnyObject {
    func openDoor(_ manager: OpenDoorManager, didUpdateLocation location: ODLocation)
}
