import Foundation
import CoreGraphics

public struct ODGenericReference: ODReference {
    public let identifier: String
    public let floor: ODFloor
    public let position: CGPoint
    public let heading: CGFloat

    public init(identifier: String, floor: ODFloor, position: CGPoint, heading: CGFloat) {
        self.identifier = identifier
        self.floor = floor
        self.position = position
        self.heading = heading
    }
}
