import Foundation
import CoreGraphics

public struct ODGenericReference: ODReference {
    public let identifier: String
    public let floor: ODFloor
    public let position: CGPoint

    public init(identifier: String, floor: ODFloor, position: CGPoint) {
        self.identifier = identifier
        self.floor = floor
        self.position = position
    }
}
