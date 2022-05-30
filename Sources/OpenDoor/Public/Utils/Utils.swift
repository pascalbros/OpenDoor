import Foundation
import simd
import CoreGraphics

public typealias Vector3 = SIMD3<Float>

extension simd_float4x4 {
    var eulerAngles: simd_float3 {
        simd_float3(
            x: asin(-self[2][1]),
            y: atan2(self[2][0], self[2][2]),
            z: atan2(self[0][1], self[1][1])
        )
    }
}

extension Float {
    var deg: Float { self * 180 / .pi }

    var rad: Float { self * .pi / 180 }

    var heading: Float {
        let value = self.truncatingRemainder(dividingBy: 360)
        return value < 0 ? value + 360 : value
    }
}

extension CGPoint {
    init(x: Float, y: Float) {
        self.init(x: CGFloat(x), y: CGFloat(y))
    }
}
