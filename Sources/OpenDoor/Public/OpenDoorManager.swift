import Foundation
import ARKit
import RealityKit

fileprivate typealias ReferencePosition = (simd_float4, Vector3)

public class OpenDoorManager {

    public weak var dataSource: OpenDoorDataSource?
    public weak var delegate: OpenDoorDelegate?

    public var shouldRecognizeImplicitMarkers = false

    public fileprivate(set) var floor: ODFloor?
    public fileprivate(set) var location: ODLocation?
    public var session: ARSession { sessionManager.session }

    fileprivate var sessionManager: OpenDoorSessionManager!
    fileprivate var barCodesRecognizer = BarCodesRecognizer(symbologies: [.qr])
    fileprivate var barCodesRecognizerLastUpdated = Date()

    public init() {
        sessionManager = OpenDoorSessionManager(manager: self)
    }

    public func start() {
        sessionManager.session.run(sessionManager.configuration, options: [.removeExistingAnchors, .resetTracking])
    }

    public func stop() {
        sessionManager.session.pause()
    }

    public func loadReferences(_ references: [ODReference]) {
        loadImageReferences(references.compactMap { $0 as? ODImageReference })
    }

    public func loadImageReferences(_ references: [ODImageReference]) {
        var images: Set<ARReferenceImage> = []
        for anchor in references {
            guard let image = anchor.image?.cgImage else { continue }
            let reference = ARReferenceImage(image, orientation: .up, physicalWidth: anchor.physicalWidth)
            reference.name = anchor.identifier
            images.insert(reference)
        }
        sessionManager.configuration.detectionImages = images
    }

    public func injectCurrentLocationFix(_ position: CGPoint, floor: ODFloor) {
        guard let cameraPosition = sessionManager.session.currentFrame?.camera.transform.columns.3 else { return }
        let injectedPosition = Vector3(Float(position.x), Float(position.y), 0)
        sessionManager.onAnchorFound(position: (cameraPosition, injectedPosition), floor: floor, updatePositionFix: true)
    }

    func injectLocation(_ location: ODLocation, floor: ODFloor) {
        onFloorChanged(floor)
        onLocationChanged(location)
    }

    fileprivate func onFloorChanged(_ floor: ODFloor) {
        if self.floor == floor { return }
        self.floor = floor
        delegate?.openDoor(self, didUpdateFloor: floor)
    }

    fileprivate func onLocationChanged(_ location: ODLocation) {
        self.location = location
        delegate?.openDoor(self, didUpdateLocation: location)
    }
}

extension OpenDoorManager {
    fileprivate func recognizeQRCodes(frame: ARFrame) {
        guard shouldRecognizeImplicitMarkers else { return }
        guard Date().timeIntervalSince(barCodesRecognizerLastUpdated) > 1 else { return } //One request for each second
        barCodesRecognizerLastUpdated = Date()
        let cameraPosition = frame.camera.transform.columns.3
        barCodesRecognizer.recognize(frame: frame) { barCodes in
            for barCode in barCodes {
                guard let anchor = self.dataSource?.recognizeAnchor(name: barCode.1) else { continue }
                let position = Vector3(Float(anchor.position.x), Float(anchor.position.y), 0)
                self.sessionManager.onAnchorFound(position: (cameraPosition, position), floor: anchor.floor, updatePositionFix: true)
            }
        }
    }
}

fileprivate class OpenDoorSessionManager: NSObject, ARSessionDelegate {

    unowned let manager: OpenDoorManager
    var referencePosition: ReferencePosition?
    var session = ARSession()
    var configuration = ARWorldTrackingConfiguration()

    init(manager: OpenDoorManager) {
        self.manager = manager
        super.init()
        session.delegate = self
        configuration.worldAlignment = .gravityAndHeading
    }

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        anchors.forEach {
            guard let name = $0.name else { return }
            guard let anchor = manager.dataSource?.recognizeAnchor(name: name) else { return }
            let position = Vector3(Float(anchor.position.x), Float(anchor.position.y), 0)
            onAnchorFound(position: ($0.transform.columns.3, position), floor: anchor.floor, updatePositionFix: true)
        }
    }

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        anchors.forEach {
            guard let name = $0.name else { return }
            guard let anchor = manager.dataSource?.recognizeAnchor(name: name) else { return }
            let position = Vector3(Float(anchor.position.x), Float(anchor.position.y), 0)
            onAnchorFound(position: ($0.transform.columns.3, position), floor: anchor.floor, updatePositionFix: true)
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
        manager.recognizeQRCodes(frame: frame)
    }

    func onAnchorFound(position: ReferencePosition, floor: ODFloor, updatePositionFix: Bool) {
        if manager.floor != floor {
            referencePosition = nil
            manager.floor = nil
            manager.onFloorChanged(floor)
        }
        if updatePositionFix || referencePosition == nil {
            referencePosition = position
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
