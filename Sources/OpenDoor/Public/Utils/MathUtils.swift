import Foundation
import CoreGraphics

class MathUtils {
    static func rotatePoint(_ point: CGPoint, center: CGPoint, angle: CGFloat) -> CGPoint {
        let translateTransform = CGAffineTransform(translationX: center.x, y: center.y)
        let rotationTransform = CGAffineTransform(rotationAngle: angle)

        let customRotation = translateTransform.inverted().concatenating(rotationTransform).concatenating(translateTransform)

        return point.applying(customRotation)
    }
}
