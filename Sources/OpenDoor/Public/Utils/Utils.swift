import Foundation
import simd

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

    var heading: Float { self < 0 ? 360 + self : self }
}
