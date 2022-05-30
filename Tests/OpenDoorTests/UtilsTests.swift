import XCTest
@testable import OpenDoor

class UtilsTests: XCTestCase {

    func testDegToRad() throws {
        [
            Parameters(input: Float(-90).rad, output: -.pi / 2, message: "-90"),
            Parameters(input: Float(0).rad, output: 0, message: "0"),
            Parameters(input: Float(90).rad, output: .pi / 2, message: "90"),
            Parameters(input: Float(180).rad, output: .pi, message: "180"),
            Parameters(input: Float(360).rad, output: .pi * 2, message: "360"),
            Parameters(input: Float(360+180).rad, output: .pi * 2 + .pi, message: "360+180")
        ].forEach { p in
            XCTAssertEqual(p.input, p.output, accuracy: 0.0001, p.debugMessage)
        }
    }

    func testRadToDeg() throws {
        [
            Parameters(input: -Float.pi.deg / 2, output: Float(-90), message: "-90"),
            Parameters(input: Float(0).deg, output: Float(0), message: "0"),
            Parameters(input: (Float.pi / 2).deg, output: Float(90), message: "90"),
            Parameters(input: (Float.pi).deg, output: Float(180), message: "180"),
            Parameters(input: (Float.pi * 2).deg, output: Float(360), message: "360"),
            Parameters(input: (Float.pi * 2 + .pi).deg, output: Float(360+180), message: "360+180")
        ].forEach { p in
            XCTAssertEqual(p.input, p.output, accuracy: 0.0001, p.debugMessage)
        }
    }

    func testHeading() throws {
        (-1000...1000).forEach {
            let heading = Float($0).heading
            XCTAssertGreaterThanOrEqual(heading, 0)
            XCTAssertLessThanOrEqual(heading, 360)
        }
    }

    func testHeadingNegativeValues() throws {
        XCTAssertEqual(Float(-90 + (360 * 10)).heading, 270)
        XCTAssertEqual(Float(-180 + (360 * 20)).heading, 180)
        XCTAssertEqual(Float(-270 + (360 * 30)).heading, 90)
    }
}
