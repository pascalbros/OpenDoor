import Foundation
import UIKit

public struct ODFloor: Equatable {
    public let name: String
    public let floor: Int
    public let scale: Float

    public init(name: String, floor: Int, scale: Float = 1) {
        self.name = name
        self.floor = floor
        self.scale = scale
    }

    public static func == (lhs: ODFloor, rhs: ODFloor) -> Bool {
        lhs.name == rhs.name && lhs.floor == rhs.floor
    }
}
