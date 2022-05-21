import Foundation
import UIKit

public protocol OpenDoorDataSource: AnyObject {
    func recognizeAnchor(name: String) -> ODImageReference?
}
