import Foundation

public protocol OpenDoorDelegate: AnyObject {
    func openDoor(_ manager: OpenDoorManager, didUpdateFloor floor: ODFloor)
    func openDoor(_ manager: OpenDoorManager, didUpdateLocation location: ODLocation)
}
