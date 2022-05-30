import Foundation
import CoreGraphics

struct Parameters<Input, Output> {
    let input: Input
    let output: Output
    let message: String
    let line: Int

    init(input: Input, output: Output, message: String = "", _ line: Int = #line) {
        self.input = input
        self.output = output
        self.message = message
        self.line = line
    }

    var debugMessage: String {
        return "Line \(line): \(message)"
    }
}
