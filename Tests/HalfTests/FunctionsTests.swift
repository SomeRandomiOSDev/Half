//
//  FunctionsTests.swift
//  Half
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

@testable import Half
import XCTest

class TestFunctions: XCTestCase {

    // MARK: Test Methods

    func testAllFunctions() {
        let half1: Half = .pi * 0.25, half2: Half = 10.0
        let float1: Float = .pi * 0.25, float2: Float = 10.0

        assertNearEqual(acos(half1), Half(acos(float1)))
        assertNearEqual(acosh(half2), Half(acosh(float2)))
        assertNearEqual(asin(half1), Half(asin(float1)))
        assertNearEqual(asinh(half1), Half(asinh(float1)))
        assertNearEqual(atan(half1), Half(atan(float1)))
        assertNearEqual(atanh(half1), Half(atanh(float1)))
        assertNearEqual(cbrt(half1), Half(cbrt(float1)))
        assertNearEqual(cos(half1), Half(cos(float1)))
        assertNearEqual(cosh(half1), Half(cosh(float1)), epsilon: 0.0025)
        assertNearEqual(erf(half1), Half(erf(float1)))
        assertNearEqual(erfc(half1), Half(erfc(float1)))
        assertNearEqual(exp(half1), Half(exp(float1)))
        assertNearEqual(exp2(half1), Half(exp2(float1)), epsilon: 0.01)
        assertNearEqual(expm1(half1), Half(expm1(float1)), epsilon: 0.01)
        assertNearEqual(log(half1), Half(log(float1)))
        assertNearEqual(log10(half1), Half(log10(float1)))
        assertNearEqual(log1p(half1), Half(log1p(float1)))
        assertNearEqual(log2(half1), Half(log2(float1)))
        assertNearEqual(logb(half1), Half(logb(float1)))
        assertNearEqual(nearbyint(half1), Half(nearbyint(float1)))
        assertNearEqual(rint(half1), Half(rint(float1)))
        assertNearEqual(sin(half1), Half(sin(float1)))
        assertNearEqual(sinh(half1), Half(sinh(float1)))
        assertNearEqual(tan(half1), Half(tan(float1)))
        assertNearEqual(tanh(half1), Half(tanh(float1)))
        assertNearEqual(tgamma(half1), Half(tgamma(float1)))

        //

        assertNearEqual(atan2(half1, half2), Half(atan2(float1, float2)))
        assertNearEqual(copysign(half1, half2), Half(copysign(float1, float2)))
        assertNearEqual(fdim(half1, half2), Half(fdim(float1, float2)))
        assertNearEqual(fmax(half1, half2), Half(fmax(float1, float2)))
        assertNearEqual(fmin(half1, half2), Half(fmin(float1, float2)))
        assertNearEqual(hypot(half1, half2), Half(hypot(float1, float2)))
        assertNearEqual(nextafter(half1, half2), Half(nextafter(float1, float2)))
        assertNearEqual(pow(half1, half2), Half(pow(float1, float2)), epsilon: 0.5)

        //

        let lgammaHalf = lgamma(half1)
        let lgammaFloat = lgamma(float1)

        assertNearEqual(lgammaHalf.0, Half(lgammaFloat.0))
        XCTAssertEqual(lgammaHalf.1, lgammaFloat.1)

        let remquoHalf = remquo(half1, half2)
        let remquoFloat = remquo(float1, float2)

        assertNearEqual(remquoHalf.0, Half(remquoFloat.0))
        XCTAssertEqual(remquoHalf.1, remquoFloat.1)
    }

    // MARK: Private Methods

    private func assertNearEqual(_ value1: Half, _ value2: Half, epsilon: Half = 0.001, file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue((value1 - value2).magnitude <= epsilon, "assertNearEqual failed: (\"\(value1)\") is not equal to (\"\(value2)\")", file: file, line: line)
    }
}
