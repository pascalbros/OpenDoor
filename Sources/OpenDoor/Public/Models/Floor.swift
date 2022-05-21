import Foundation
import UIKit

open class ODFloor: Equatable {
    public let name: String
    public let floor: Int
    public let picture: UIImage?
    public let picturePath: String?
    public let oneMeterInPixels: Float

    public init(name: String, floor: Int, picture: UIImage?, picturePath: String?, oneMeterInPixels: Float) {
        self.name = name
        self.floor = floor
        self.picture = picture
        self.picturePath = picturePath
        self.oneMeterInPixels = oneMeterInPixels
    }

    public static func == (lhs: ODFloor, rhs: ODFloor) -> Bool {
        lhs.name == rhs.name && lhs.floor == rhs.floor
    }
}
