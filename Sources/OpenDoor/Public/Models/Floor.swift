import Foundation
import UIKit

public struct ODFloor: Equatable {
    public let name: String
    public let floor: Int
    public let oneMeterInPixels: Float

    public init(name: String, floor: Int, oneMeterInPixels: Float) {
        self.name = name
        self.floor = floor
        self.oneMeterInPixels = oneMeterInPixels
    }

    public static func == (lhs: ODFloor, rhs: ODFloor) -> Bool {
        lhs.name == rhs.name && lhs.floor == rhs.floor
    }
}
