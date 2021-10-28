//
//  HalfTests.swift
//  HalfTests
//
//  Copyright © 2020 SomeRandomiOSDev. All rights reserved.
//

@testable import Half
import XCTest

#if canImport(CoreGraphics)
import CoreGraphics.CGBase
#endif // #if canImport(CoreGraphics)

// swiftlint:disable function_body_length

class HalfTests: XCTestCase {

    // MARK: Test Methods

    func testBasicValues() {
        var value = Half()
        XCTAssertEqual(value, 0.0)

        value = 1.5
        XCTAssertEqual(value, 1.5)

        value = 3.14
        XCTAssertEqual(value, 3.14)
    }

    func testBitPattern() {
        for bitPattern in 0 ... UInt16.max {
            XCTAssertEqual(Half(bitPattern: bitPattern).bitPattern, bitPattern)
        }
    }

    func testManualFloatingPointInitialization() {
        for sign: FloatingPointSign in [.plus, .minus] {
            for exponent: UInt in 0 ..< ((1 << Half.exponentBitCount) - 1) {
                for significand: UInt16 in 0 ..< ((1 << Half.significandBitCount) - 1) {
                    let half = Half(sign: sign, exponentBitPattern: exponent, significandBitPattern: significand)

                    XCTAssertEqual(half.sign, sign)
                    XCTAssertEqual(half.exponentBitPattern, exponent)
                    XCTAssertEqual(half.significandBitPattern, significand)
                }
            }
        }

        XCTAssertEqual(Half(sign: .plus, exponent: -1, significand: 1.5), 0.75)
        XCTAssertEqual(Half(sign: .plus, exponent: 0, significand: 1.5), 1.5)
        XCTAssertEqual(Half(sign: .plus, exponent: 1, significand: 1.5), 3.0)

        XCTAssertEqual(Half(sign: .plus, exponent: -15, significand: 1.5), 4.5776367e-05)
        XCTAssertTrue(Half(sign: .minus, exponent: 16, significand: 1.5).isInfinite)
    }

    func testConvertFromOtherFloatTypes() {
        let half: Half = 3.14
        let float: Float = 3.14
        let double: Double = 3.14
#if canImport(CoreGraphics)
        let cgfloat: CGFloat = 3.14
#endif // #if canImport(CoreGraphics)
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
        let float80: Float80 = 3.14
#endif

        let half1 = Half(float)
        let half2 = Half(double)
#if canImport(CoreGraphics)
        let half3 = Half(cgfloat)
#endif // #if canImport(CoreGraphics)
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
        let half4 = Half(float80)
#endif

        XCTAssertEqual(half, Half(half))
        XCTAssertEqual(half1, half2)
#if canImport(CoreGraphics)
        XCTAssertEqual(half2, half3)
#endif // #if canImport(CoreGraphics)
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
        XCTAssertEqual(half2, half4)
#endif

        binaryFloatingPoint(Double(1.0)) { XCTAssertEqual($0, $1) }
        exactBinaryFloatingPoint(Double(1.0), shouldFail: false) { XCTAssertEqual($0, $1) }
        exactBinaryFloatingPoint(Double.pi, shouldFail: true) { XCTAssertEqual($0, $1) }

#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
        for infinite in [Float80.infinity, -.infinity] {
            XCTAssertTrue(Half(infinite).isInfinite)
            binaryFloatingPoint(infinite) { XCTAssertTrue($0.isInfinite); XCTAssertTrue($1.isInfinite) }
            exactBinaryFloatingPoint(infinite, shouldFail: false) { XCTAssertTrue($0.isInfinite); XCTAssertTrue($1.isInfinite) }
        }
#endif
        for infinite in [Double.infinity, -.infinity] {
            XCTAssertTrue(Half(infinite).isInfinite)
            binaryFloatingPoint(infinite) { XCTAssertTrue($0.isInfinite); XCTAssertTrue($1.isInfinite) }
            exactBinaryFloatingPoint(infinite, shouldFail: false) { XCTAssertTrue($0.isInfinite); XCTAssertTrue($1.isInfinite) }
        }
        for infinite in [Float.infinity, -.infinity] {
            XCTAssertTrue(Half(infinite).isInfinite)
            binaryFloatingPoint(infinite) { XCTAssertTrue($0.isInfinite); XCTAssertTrue($1.isInfinite) }
            exactBinaryFloatingPoint(infinite, shouldFail: false) { XCTAssertTrue($0.isInfinite); XCTAssertTrue($1.isInfinite) }
        }
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
        for nan in [Float80.nan, .signalingNaN] {
            XCTAssertTrue(Half(nan).isNaN)
            XCTAssertEqual(Half(nan).isSignalingNaN, nan.isSignalingNaN)
            binaryFloatingPoint(nan) { XCTAssertTrue($0.isNaN); XCTAssertTrue($1.isNaN); XCTAssertEqual($0.isSignalingNaN, $1.isSignalingNaN) }
            exactBinaryFloatingPoint(nan, shouldFail: false) { XCTAssertTrue($0.isNaN); XCTAssertTrue($1.isNaN); XCTAssertEqual($0.isSignalingNaN, $1.isSignalingNaN) }
        }
#endif
        for nan in [Double.nan, .signalingNaN] {
            XCTAssertTrue(Half(nan).isNaN)
            XCTAssertEqual(Half(nan).isSignalingNaN, nan.isSignalingNaN)
            binaryFloatingPoint(nan) { XCTAssertTrue($0.isNaN); XCTAssertTrue($1.isNaN); XCTAssertEqual($0.isSignalingNaN, $1.isSignalingNaN) }
            exactBinaryFloatingPoint(nan, shouldFail: false) { XCTAssertTrue($0.isNaN); XCTAssertTrue($1.isNaN); XCTAssertEqual($0.isSignalingNaN, $1.isSignalingNaN) }
        }
        for nan in [Float.nan, .signalingNaN] {
            XCTAssertTrue(Half(nan).isNaN)
            XCTAssertEqual(Half(nan).isSignalingNaN, nan.isSignalingNaN)
            binaryFloatingPoint(nan) { XCTAssertTrue($0.isNaN); XCTAssertTrue($1.isNaN); XCTAssertEqual($0.isSignalingNaN, $1.isSignalingNaN) }
            exactBinaryFloatingPoint(nan, shouldFail: false) { XCTAssertTrue($0.isNaN); XCTAssertTrue($1.isNaN); XCTAssertEqual($0.isSignalingNaN, $1.isSignalingNaN) }
        }

#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
        binaryFloatingPoint(Float80.greatestFiniteMagnitude) { XCTAssertFalse($0.isInfinite); XCTAssertTrue($1.isInfinite) }
        exactBinaryFloatingPoint(Float80.greatestFiniteMagnitude, shouldFail: true) { _, _ in }
#endif
        binaryFloatingPoint(Double.greatestFiniteMagnitude) { XCTAssertFalse($0.isInfinite); XCTAssertTrue($1.isInfinite) }
        exactBinaryFloatingPoint(Double.greatestFiniteMagnitude, shouldFail: true) { _, _ in }

        binaryFloatingPoint(Float.greatestFiniteMagnitude) { XCTAssertFalse($0.isInfinite); XCTAssertTrue($1.isInfinite) }
        exactBinaryFloatingPoint(Float.greatestFiniteMagnitude, shouldFail: true) { _, _ in }
    }

    func testConvertFromIntTypes() throws {
        let int8: Int8 = -8
        let uint8: UInt8 = 8
        let int16: Int16 = -16
        let uint16: UInt16 = 16
        let int32: Int32 = -32
        let uint32: UInt32 = 32
        let int64: Int64 = -64
        let uint64: UInt64 = 64
        let int: Int = -1
        let uint: UInt = 1

        XCTAssertEqual(Half(int8), -8.0)
        XCTAssertEqual(Half(int8), -8)
        XCTAssertEqual(Half(uint8), 8.0)
        XCTAssertEqual(Half(uint8), 8)
        XCTAssertEqual(Half(int16), -16.0)
        XCTAssertEqual(Half(int16), -16)
        XCTAssertEqual(Half(uint16), 16.0)
        XCTAssertEqual(Half(uint16), 16)
        XCTAssertEqual(Half(int32), -32.0)
        XCTAssertEqual(Half(int32), -32)
        XCTAssertEqual(Half(uint32), 32.0)
        XCTAssertEqual(Half(uint32), 32)
        XCTAssertEqual(Half(int64), -64.0)
        XCTAssertEqual(Half(int64), -64)
        XCTAssertEqual(Half(uint64), 64.0)
        XCTAssertEqual(Half(uint64), 64)
        XCTAssertEqual(Half(int), -1.0)
        XCTAssertEqual(Half(int), -1)
        XCTAssertEqual(Half(uint), 1.0)
        XCTAssertEqual(Half(uint), 1)

        XCTAssertEqual(Half(exactly: 8), 8.0)
        XCTAssertNil(Half(exactly: Int64.max))
    }

    func testBasicMathematicalFunctions() {
        let half1: Half = 3.0
        let half2: Half = 4.0
        let half3: Half = -2.5
        let half4: Half = -5.0

        XCTAssertEqual(half1 + half2, 7.0)
        XCTAssertEqual(half1 - half2, -1.0)
        XCTAssertEqual(half1 * half2, 12.0)
        XCTAssertEqual(half1 / half2, 0.75)

        XCTAssertEqual(half2 + half3, 1.5)
        XCTAssertEqual(half2 - half3, 6.5)
        XCTAssertEqual(half2 * half3, -10.0)
        XCTAssertEqual(half2 / half3, -1.6)

        XCTAssertEqual(half3 + half4, -7.5)
        XCTAssertEqual(half3 - half4, 2.5)
        XCTAssertEqual(half3 * half4, 12.5)
        XCTAssertEqual(half3 / half4, 0.5)

        XCTAssertEqual(half4 + half1, -2.0)
        XCTAssertEqual(half4 - half1, -8.0)
        XCTAssertEqual(half4 * half1, -15.0)
        XCTAssertEqual(half4 / half1, -1.6666666666666667)

        var result = half1
        result += half2
        XCTAssertEqual(result, half1 + half2)

        result = half1
        result -= half2
        XCTAssertEqual(result, half1 - half2)

        result = half1
        result *= half2
        XCTAssertEqual(result, half1 * half2)

        result = half1
        result /= half2
        XCTAssertEqual(result, half1 / half2)
    }

    func testBasicComparisons() {
        let half1: Half = 1.0
        let half2: Half = 2.0
        let half3: Half = 3.0
        let half4: Half = 3.0

        XCTAssertTrue(half1 < half2)
        XCTAssertTrue(half2 > half1)
        XCTAssertTrue(half2 < half3)
        XCTAssertTrue(half3 > half2)

        XCTAssertFalse(half3 < half4)
        XCTAssertFalse(half4 > half3)
        XCTAssertTrue(half3 <= half4)
        XCTAssertTrue(half4 >= half3)
    }

    func testNegativeHalfs() {
        var half1: Half = -2.0
        let half2: Half = 2.0

        XCTAssertNotEqual(half1, half2)

        half1.negate()
        XCTAssertEqual(half1, half2)

        half1.negate()
        XCTAssertEqual(-half1, half2)

        half1.negate()
        XCTAssertEqual(half1.magnitude, half2)
    }

    func testStrideableProtocolMethods() {
        let half1: Half = 3.5
        let half2: Half = 8.75

        XCTAssertEqual(half1.distance(to: half2), 5.25)
        XCTAssertEqual(half1.advanced(by: half2), 12.25)
    }

    func testHashableProtocolMethods() {
        let result1: Int, result2: Int, result3: Int, result4: Int

        do {
            var hasher = Hasher()
            let half: Half = 0.0

            hasher.combine(half)
            result1 = hasher.finalize()
        }
        do {
            var hasher = Hasher()
            let half: Half = -0.0

            hasher.combine(half)
            result2 = hasher.finalize()
        }
        do {
            var hasher = Hasher()
            let half: Half = 1.0

            hasher.combine(half)
            result3 = hasher.finalize()
        }
        do {
            var hasher = Hasher()
            let halfBits: UInt16 = 0x0000

            hasher.combine(halfBits)
            result4 = hasher.finalize()
        }

        XCTAssertEqual(result1, result2)
        XCTAssertNotEqual(result2, result3)
        XCTAssertEqual(result2, result4)
    }

    func testNonNumberValues() {
        XCTAssertTrue(Half.infinity.isInfinite)
        XCTAssertFalse(Half.infinity.isFinite)
        XCTAssertTrue(Half.infinity.nextUp.isInfinite)
        XCTAssertTrue(Half.nan.isNaN)
        XCTAssertFalse(Half.nan.isSignalingNaN)
        XCTAssertTrue(Half.signalingNaN.isNaN)
        XCTAssertTrue(Half.signalingNaN.isSignalingNaN)
        XCTAssertTrue(Half(nan: 0, signaling: false).isNaN)
        XCTAssertFalse(Half(nan: 0, signaling: false).isSignalingNaN)
        XCTAssertTrue(Half(nan: 0, signaling: true).isNaN)
        XCTAssertTrue(Half(nan: 0, signaling: true).isSignalingNaN)
    }

    func testRounding() {
        var half: Half = 4.5

        XCTAssertEqual(half.rounded(.awayFromZero), 5.0)
        XCTAssertEqual(half.rounded(.down), 4.0)
        XCTAssertEqual(half.rounded(.toNearestOrAwayFromZero), 5.0)
        XCTAssertEqual(half.rounded(.toNearestOrEven), 4.0)
        XCTAssertEqual(half.rounded(.towardZero), 4.0)
        XCTAssertEqual(half.rounded(.up), 5.0)

        half = -4.5

        XCTAssertEqual(half.rounded(.awayFromZero), -5.0)
        XCTAssertEqual(half.rounded(.down), -5.0)
        XCTAssertEqual(half.rounded(.toNearestOrAwayFromZero), -5.0)
        XCTAssertEqual(half.rounded(.toNearestOrEven), -4.0)
        XCTAssertEqual(half.rounded(.towardZero), -4.0)
        XCTAssertEqual(half.rounded(.up), -4.0)
    }

    func testTruncatingRemainder() {
        var half: Half = 4.5
        var float: Float = 4.5

        half.formTruncatingRemainder(dividingBy: 1.63)
        float.formTruncatingRemainder(dividingBy: 1.63)

        XCTAssertTrue((Half(float) - half).magnitude < 0.001)
    }

    func testRemainder() {
        var half: Half = 4.5
        var float: Float = 4.5

        half.formRemainder(dividingBy: 1.63)
        float.formRemainder(dividingBy: 1.63)

        XCTAssertTrue((Half(float) - half).magnitude < 0.001)
    }

    func testSquareRoot() {
        var value: Half = 4.0
        value.formSquareRoot()
        XCTAssertEqual(value, 2.0)

        value = 81.0
        value.formSquareRoot()
        XCTAssertEqual(value, 9.0)
    }

    func testAddProduct() {
        var value: Half = 3.5
        value.addProduct(2.0, 7.5)

        XCTAssertEqual(value, 18.5)
    }

    func testPi() {
        XCTAssertTrue((Float(Half.pi) - Float.pi).magnitude < 0.001)
    }

    func testSmallestNumbers() {
        XCTAssertTrue(Half.leastNormalMagnitude > 0.0)
        XCTAssertTrue(Half.leastNonzeroMagnitude > 0.0)

        #if arch(arm)
        XCTAssertEqual(Half.leastNonzeroMagnitude, Half.leastNormalMagnitude)
        #else
        XCTAssertTrue(Half.leastNonzeroMagnitude < Half.leastNormalMagnitude)
        #endif
    }

    func testLargestNumbers() {
        XCTAssertTrue(Half.greatestFiniteMagnitude < Half.infinity)
        XCTAssertTrue(Half.greatestFiniteMagnitude.nextUp.isInfinite)
    }

    func testULP() {
        XCTAssertTrue(Half.infinity.ulp.isNaN)
        XCTAssertEqual(Half(1.0).ulp, 0.0009765625)
        XCTAssertEqual(Half(sign: .plus, exponentBitPattern: 0, significandBitPattern: 1).ulp, 5.9604645e-08) // subnormal
    }

    func testSignificand() {
        XCTAssertTrue(Half.nan.significand.isNaN)
        XCTAssertEqual(Half(0.75).significand.significandBitPattern, 512)
        XCTAssertEqual(Half(sign: .plus, exponentBitPattern: 0, significandBitPattern: 1).significand.significandBitPattern, 0) // subnormal
        XCTAssertEqual(Half.infinity.significand.significandBitPattern, 0)
    }

    func testCanonical() {
        #if arch(arm)
        XCTAssertTrue(Half(1.0).isCanonical)
        XCTAssertFalse(Half(sign: .plus, exponentBitPattern: 0, significandBitPattern: 1).isCanonical) // subnormal
        #else
        for bitPattern in 0 ... UInt16.max {
            XCTAssertTrue(Half(bitPattern: bitPattern).isCanonical)
        }
        #endif
    }

    func testExponent() {
        XCTAssertEqual(Half.infinity.exponent, .max)
        XCTAssertEqual(Half().exponent, .min)
        XCTAssertEqual(Half(1.0).exponent, 0)
        XCTAssertEqual(Half(8.0).exponent, 3)
        XCTAssertEqual(Half(sign: .plus, exponentBitPattern: 0, significandBitPattern: 1).exponent, -24) // subnormal
    }

    func testBinade() {
        XCTAssertTrue(Half.infinity.binade.isNaN)
        XCTAssertEqual(Half(21.5).binade, 16.0)
        XCTAssertEqual(Half(sign: .plus, exponentBitPattern: 0, significandBitPattern: 1).binade, 5.9604645e-08) // subnormal
    }

    func testSignificandWidth() {
        XCTAssertEqual(Half(8.0).significandWidth, 0)
        XCTAssertEqual(Half(2.5).significandWidth, 2)
        XCTAssertEqual(Half.infinity.significandWidth, -1)
        XCTAssertEqual(Half.nan.significandWidth, -1)
        XCTAssertEqual(Half(sign: .plus, exponentBitPattern: 0, significandBitPattern: 0xFF).significandWidth, 7) // subnormal
    }

    func testDescription() {
        let half: Half = 2.5
        let float: Float = 2.5

        XCTAssertEqual(half.description, float.description)
        XCTAssertEqual(half.debugDescription, float.debugDescription)
        XCTAssertEqual(Half.nan.description, "nan")
        XCTAssertEqual(Half.nan.debugDescription, "nan")
    }

    func testOutputStreamable() {
        #if swift(>=5.0)
        var tests = self
        Half(2.5).write(to: &tests)
        #endif // #if swift(>=5.0)
    }

    // MARK: Private Methods

    private func binaryFloatingPoint<BFP>(_ float: BFP, compare: (BFP, BFP) -> Void) where BFP: BinaryFloatingPoint {
        let half = Half(float)
        let testFloat: BFP

        if half.isInfinite {
            let infinity = BFP.infinity
            testFloat = BFP(sign: half.sign, exponentBitPattern: infinity.exponentBitPattern, significandBitPattern: infinity.significandBitPattern)
        } else if half.isSignalingNaN {
            testFloat = .signalingNaN
        } else if half.isNaN {
            testFloat = .nan
        } else {
            testFloat = BFP(half)
        }

        compare(float, testFloat)
    }

    private func exactBinaryFloatingPoint<BFP>(_ float: BFP, shouldFail: Bool, file: StaticString = #file, line: UInt = #line, compare: (BFP, BFP) -> Void) where BFP: BinaryFloatingPoint {
        let half = Half(exactly: float)

        if let half = half {
            if shouldFail {
                XCTFail("Expected Half initializer to fail", file: file, line: line)
            } else {
                let testFloat: BFP
                if half.isInfinite {
                    let infinity = BFP.infinity
                    testFloat = BFP(sign: half.sign, exponentBitPattern: infinity.exponentBitPattern, significandBitPattern: infinity.significandBitPattern)
                } else if half.isSignalingNaN {
                    testFloat = .signalingNaN
                } else if half.isNaN {
                    testFloat = .nan
                } else {
                    testFloat = BFP(half)
                }

                compare(float, testFloat)
            }
        } else if !shouldFail {
            XCTFail("Unexpected failure of Half initializer", file: file, line: line)
        }
    }
}

extension HalfTests: TextOutputStream {

    func write(_ string: String) {
        XCTAssertEqual(string, "2.5")
    }
}
