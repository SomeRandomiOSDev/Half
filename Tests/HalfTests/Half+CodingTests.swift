//
//  Half+CodingTests.swift
//  Half
//
//  Copyright © 2020 SomeRandomiOSDev. All rights reserved.
//

@testable import Half
import XCTest

//swiftlint:disable nesting function_body_length

class HalfCodingTests: XCTestCase {

    // MARK: Test Methods

    func testEncodingDecoding() throws {
        struct Simple: Codable, Equatable {
            var half: Half
            var int: Int

            static func == (lhs: Simple, rhs: Simple) -> Bool {
                return lhs.int == rhs.int && lhs.half == rhs.half
            }
        }

        do {
            let simple = Simple(half: 3.14, int: 1)
            var decoded = Simple(half: 0, int: 0)
            var data = Data()

            XCTAssertNoThrow(data = try JSONEncoder().encode(simple))
            XCTAssertNoThrow(decoded = try JSONDecoder().decode(Simple.self, from: data))
            XCTAssertEqual(decoded, simple)
        }
        do {
            let values: [Half] = [1.0, 2.0, 3.0]
            var decoded: [Half] = []
            var data = Data()

            XCTAssertNoThrow(data = try JSONEncoder().encode(values))
            XCTAssertNoThrow(decoded = try JSONDecoder().decode([Half].self, from: data))
            XCTAssertEqual(decoded, values)
        }
        do {
            let values: [Simple] = [Simple(half: 1.5, int: 1), Simple(half: 2.5, int: 2), Simple(half: 3.5, int: 3)]
            var decoded: [Simple] = []
            var data = Data()

            XCTAssertNoThrow(data = try JSONEncoder().encode(values))
            XCTAssertNoThrow(decoded = try JSONDecoder().decode([Simple].self, from: data))
            XCTAssertEqual(decoded, values)
        }
        do {
            let simple = Simple(half: .infinity, int: 0)
            var decoded = Simple(half: 0, int: 0)
            var data = Data()

            let encoder = JSONEncoder()
            encoder.nonConformingFloatEncodingStrategy = .convertToString(positiveInfinity: "+inf", negativeInfinity: "-inf", nan: "nan")

            let decoder = JSONDecoder()
            decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+inf", negativeInfinity: "-inf", nan: "nan")

            XCTAssertNoThrow(data = try encoder.encode(simple))
            XCTAssertNoThrow(decoded = try decoder.decode(Simple.self, from: data))

            XCTAssertEqual(decoded.int, simple.int)
            XCTAssertTrue(decoded.half.isInfinite)
        }
        do {
            let simple = Simple(half: -.infinity, int: 0)
            var decoded = Simple(half: 0, int: 0)
            var data = Data()

            let encoder = JSONEncoder()
            encoder.nonConformingFloatEncodingStrategy = .convertToString(positiveInfinity: "+inf", negativeInfinity: "-inf", nan: "nan")

            let decoder = JSONDecoder()
            decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+inf", negativeInfinity: "-inf", nan: "nan")

            XCTAssertNoThrow(data = try encoder.encode(simple))
            XCTAssertNoThrow(decoded = try decoder.decode(Simple.self, from: data))

            XCTAssertEqual(decoded.int, simple.int)
            XCTAssertTrue(decoded.half.isInfinite)
        }
        do {
            let simple = Simple(half: .nan, int: 0)
            var decoded = Simple(half: 0, int: 0)
            var data = Data()

            let encoder = JSONEncoder()
            encoder.nonConformingFloatEncodingStrategy = .convertToString(positiveInfinity: "+inf", negativeInfinity: "-inf", nan: "nan")

            let decoder = JSONDecoder()
            decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+inf", negativeInfinity: "-inf", nan: "nan")

            XCTAssertNoThrow(data = try encoder.encode(simple))
            XCTAssertNoThrow(decoded = try decoder.decode(Simple.self, from: data))

            XCTAssertEqual(decoded.int, simple.int)
            XCTAssertTrue(decoded.half.isNaN)
        }
        do {
            let simple = Simple(half: .signalingNaN, int: 0)
            var decoded = Simple(half: 0, int: 0)
            var data = Data()

            let encoder = JSONEncoder()
            encoder.nonConformingFloatEncodingStrategy = .convertToString(positiveInfinity: "+inf", negativeInfinity: "-inf", nan: "nan")

            let decoder = JSONDecoder()
            decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+inf", negativeInfinity: "-inf", nan: "nan")

            XCTAssertNoThrow(data = try encoder.encode(simple))
            XCTAssertNoThrow(decoded = try decoder.decode(Simple.self, from: data))

            XCTAssertEqual(decoded.int, simple.int)
            XCTAssertTrue(decoded.half.isNaN)
        }
    }

    func testThrowingCases() {
        do {
            struct FloatValue: Codable {
                var value: Float
            }
            struct HalfValue: Codable {
                var value: Half
            }

            var data = Data()

            XCTAssertNoThrow(data = try JSONEncoder().encode(FloatValue(value: Float(Half.greatestFiniteMagnitude).nextUp)))
            XCTAssertThrowsError(try JSONDecoder().decode(HalfValue.self, from: data))
        }
        do {
            struct FloatValues: Codable {
                var values: [Float]
            }
            struct HalfValues: Codable {
                var values: [Half]
            }

            let values = [Float(Half.greatestFiniteMagnitude) + 1.0, Float(Half.greatestFiniteMagnitude) + 2.0, Float(Half.greatestFiniteMagnitude) + 3.0]
            var data = Data()

            XCTAssertNoThrow(data = try JSONEncoder().encode(FloatValues(values: values)))
            XCTAssertThrowsError(try JSONDecoder().decode(HalfValues.self, from: data))
        }
    }
}
