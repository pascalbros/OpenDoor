import Foundation
import CoreImage
import ARKit
import VisionKit

class BarCodesRecognizer {

    fileprivate var symbologies: [VNBarcodeSymbology]
    init(symbologies: [VNBarcodeSymbology]) {
        self.symbologies = symbologies
    }

    func recognize(frame: ARFrame, result: @escaping ([String]) -> Void) {
        recognize(pixelBuffer: frame.capturedImage, result: result)
    }

    func recognize(pixelBuffer: CVPixelBuffer, result: @escaping ([String]) -> Void) {
        let request = VNDetectBarcodesRequest { request, error in
            guard let observations = request.results else { return }
            let results = observations.compactMap {($0 as? VNBarcodeObservation)?.payloadStringValue }
            guard !results.isEmpty else { return }
            result(results)
        }
        request.symbologies = symbologies.isEmpty ? [.qr] : symbologies
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 6)!, options: [:])
        try? imageRequestHandler.perform([request])
    }
}
