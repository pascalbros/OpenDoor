import Foundation
import UIKit

public struct ODImageReference: ODReference {
    public let identifier: String
    public let image: UIImage?
    public let imagePath: String?
    public let floor: ODFloor
    public let position: CGPoint
    public let physicalWidth: CGFloat
    public let heading: CGFloat

    public init(identifier: String, image: UIImage?, imagePath: String?, position: CGPoint, floor: ODFloor, physicalWidth: CGFloat, heading: CGFloat) {
        self.identifier = identifier
        self.image = image
        self.imagePath = imagePath
        self.position = position
        self.floor = floor
        self.physicalWidth = physicalWidth
        self.heading = heading
    }
}
