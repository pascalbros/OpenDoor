import Foundation
import ARKit

fileprivate typealias ReferencePosition = (simd_float4, Vector3)

public class OpenDoorManager {

    public weak var dataSource: OpenDoorDataSource?
    public weak var delegate: OpenDoorDelegate?

    public fileprivate(set) var floor: ODFloor?
    public fileprivate(set) var location: ODLocation?

    fileprivate var sessionManager: OpenDoorSessionManager!

    public init() {
        sessionManager = OpenDoorSessionManager(manager: self)
    }

    public func start() {
        sessionManager.session.run(sessionManager.configuration, options: [.removeExistingAnchors, .resetTracking])
    }

    public func stop() {
        sessionManager.session.pause()
    }

    public func loadReferences(_ references: [ODImageReference]) {
        var images: Set<ARReferenceImage> = []
        for anchor in references {
            guard let image = anchor.image?.cgImage else { continue }
            let reference = ARReferenceImage(image, orientation: .up, physicalWidth: anchor.physicalWidth)
            reference.name = anchor.identifier
            images.insert(reference)
        }
        sessionManager.configuration.detectionImages = images
    }

    public func injectLocation(_ location: ODLocation, floor: ODFloor) {
        if self.floor != floor {
            onFloorChanged(floor)
        }
        onLocationChanged(location)
    }

    fileprivate func onFloorChanged(_ floor: ODFloor) {
        self.floor = floor
    }

    fileprivate func onLocationChanged(_ location: ODLocation) {
        self.location = location
        delegate?.openDoor(self, didUpdateLocation: location)
    }
}

fileprivate class OpenDoorSessionManager: NSObject, ARSessionDelegate {

    unowned let manager: OpenDoorManager
    var referencePosition: (simd_float4, Vector3)?
    var session = ARSession()
    var configuration = ARWorldTrackingConfiguration()

    init(manager: OpenDoorManager) {
        self.manager = manager
        super.init()
        session.delegate = self
        configuration.worldAlignment = .gravityAndHeading
    }

    public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        anchors.forEach {
            guard let name = $0.name else { return }
            guard let anchor = manager.dataSource?.recognizeAnchor(name: name) else { return }
            if manager.floor != anchor.floor {
                referencePosition = nil
                manager.onFloorChanged(anchor.floor)
            }
            if referencePosition == nil {
                let position = Vector3(Float(anchor.position.x), Float(anchor.position.y), 0)
                referencePosition = ($0.transform.columns.3, position)
            }
        }
    }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        switch frame.camera.trackingState {
        case .normal: break
        default: return
        }
        let position = frame.camera.transform.columns.3
        if let referencePosition = referencePosition, let floor = manager.floor {
            let currentLocation = calculateLocation(currentPosition: position, referencePosition: referencePosition, oneMeterInPixels: floor.oneMeterInPixels)
            manager.injectLocation(currentLocation, floor: floor)
        }
    }

    fileprivate func calculateLocation(currentPosition: simd_float4, referencePosition: ReferencePosition, oneMeterInPixels: Float) -> ODLocation {
        let mapPositionInMeters = referencePosition.1 / oneMeterInPixels
        let delta = referencePosition.0 - currentPosition
        let newPosition = Vector3(x: (mapPositionInMeters.x + delta.x) * oneMeterInPixels,
                                  y: (mapPositionInMeters.y + delta.z) * oneMeterInPixels,
                                  z: currentPosition.y)
        return ODLocation(coordinates: newPosition)
    }

}
