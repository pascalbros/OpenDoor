import XCTest
@testable import OpenDoor

class MathUtilsTests: XCTestCase {

    func testRotatePoint() throws {
        [
            (MathUtils.rotatePoint(CGPoint(x: 0, y: 100), center: .zero, angle: -.pi), CGPoint(x: 0, y: -100)),
            (MathUtils.rotatePoint(CGPoint(x: 0, y: 100), center: .zero, angle: -.pi / 2), CGPoint(x: 100, y: 0)),
            (MathUtils.rotatePoint(CGPoint(x: 0, y: 100), center: .zero, angle: 0), CGPoint(x: 0, y: 100)),
            (MathUtils.rotatePoint(CGPoint(x: 0, y: 100), center: .zero, angle: -.pi / 2), CGPoint(x: 100, y: 0)),
        ].map {
            Parameters(input: $0.0, output: $0.1)

        }.forEach { p in
            XCTAssertEqual(p.input.x, p.output.x, accuracy: 0.000001)
            XCTAssertEqual(p.input.y, p.output.y, accuracy: 0.000001)
        }
    }
}
