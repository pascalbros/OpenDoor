import Foundation
import CoreImage
import ARKit
import VisionKit

class BarCodesRecognizer {

    fileprivate var symbologies: [VNBarcodeSymbology]
    init(symbologies: [VNBarcodeSymbology]) {
        self.symbologies = symbologies
    }

    func recognize(frame: ARFrame, result: @escaping ([(CGPoint, String)]) -> Void) {
        let frameWidth = CGFloat(CVPixelBufferGetWidth(frame.capturedImage))
        let frameHeight = CGFloat(CVPixelBufferGetHeight(frame.capturedImage))
        let request = VNDetectBarcodesRequest { request, error in
            guard let observations = request.results else { return }
            let results: [(CGPoint, String)] = observations.compactMap { $0 as? VNBarcodeObservation }
                .compactMap {
                    guard let content = $0.payloadStringValue else { return nil }
                    let center = CGPoint(x: $0.boundingBox.midX * frameWidth, y: $0.boundingBox.midY * frameHeight)
                    //let hit = (frame.hitTest(center, types: .featurePoint).first?.worldTransform ?? frame.camera.transform).columns.3
                    return (center, content)
                }
            guard !results.isEmpty else { return }
            result(results)
        }
        request.symbologies = symbologies.isEmpty ? [.qr] : symbologies
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: frame.capturedImage, orientation: CGImagePropertyOrientation(rawValue: 6)!, options: [:])
        try? imageRequestHandler.perform([request])
    }
}
