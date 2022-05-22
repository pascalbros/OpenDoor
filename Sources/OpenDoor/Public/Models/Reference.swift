import Foundation
import CoreGraphics

public protocol ODReference {
    var identifier: String { get }
    var floor: ODFloor { get }
    var position: CGPoint { get }
}
