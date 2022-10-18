//
//  CHalfTests.swift
//  Half
//
//  Copyright © 2022 SomeRandomiOSDev. All rights reserved.
//

#if SWIFT_PACKAGE
@testable import CHalf
#endif
@testable import Half
import XCTest

class TestCHalf: XCTestCase {

    // MARK: Test Methods

    func testConstructorFunctions() {
        var half = Half(_half_zero())
        XCTAssertEqual(half, 0.0)

        half = Half(_half_epsilon())
        XCTAssertEqual(half, .ulpOfOne)

        half = Half(_half_pi())
        XCTAssertEqual(half, .pi)

        half = Half(_half_nan())
        XCTAssertTrue(half.isNaN)
        XCTAssertFalse(half.isSignalingNaN)
    }

    func testConvertingToFromRawValue() {
        let raw: UInt16 = 0x749A
        let half = Half(_half_from_raw(raw))

        XCTAssertEqual(Half(bitPattern: raw), half)
        XCTAssertEqual(half.bitPattern, raw)
        XCTAssertEqual(raw, _half_to_raw(half._value))
    }

    func testConvertToFromPrimitiveValues() {
        XCTAssertEqual(Half(_half_from(Double(-1.0))), -1.0)
        XCTAssertEqual(Half(_half_from(Float(-1.0))), -1.0)
        XCTAssertEqual(Half(_half_from(CLongLong(-2))), -2.0)
        XCTAssertEqual(Half(_half_from(CLong(-2))), -2.0)
        XCTAssertEqual(Half(_half_from(CInt(-2))), -2.0)
        XCTAssertEqual(Half(_half_from(CShort(-2))), -2.0)
        XCTAssertEqual(Half(_half_from(CChar(-2))), -2.0)
        XCTAssertEqual(Half(_half_from(CUnsignedLongLong(3))), 3.0)
        XCTAssertEqual(Half(_half_from(CUnsignedLong(3))), 3.0)
        XCTAssertEqual(Half(_half_from(CUnsignedInt(3))), 3.0)
        XCTAssertEqual(Half(_half_from(CUnsignedShort(3))), 3.0)
        XCTAssertEqual(Half(_half_from(CUnsignedChar(3))), 3.0)

        XCTAssertEqual(_half_to_double(Half(-1.0)._value), -1.0)
        XCTAssertEqual(_half_to_float(Half(-1.0)._value), -1.0)
        XCTAssertEqual(_half_to_longlong(Half(-2.0)._value), -2)
        XCTAssertEqual(_half_to_long(Half(-2.0)._value), -2)
        XCTAssertEqual(_half_to_int(Half(-2.0)._value), -2)
        XCTAssertEqual(_half_to_short(Half(-2.0)._value), -2)
        XCTAssertEqual(_half_to_char(Half(-2.0)._value), -2)
        XCTAssertEqual(_half_to_ulonglong(Half(3.0)._value), 3)
        XCTAssertEqual(_half_to_ulong(Half(3.0)._value), 3)
        XCTAssertEqual(_half_to_uint(Half(3.0)._value), 3)
        XCTAssertEqual(_half_to_ushort(Half(3.0)._value), 3)
        XCTAssertEqual(_half_to_uchar(Half(3.0)._value), 3)
    }

    func testArithmeticFunctions() {
        let lhs = Half(10.0)
        let rhs = Half(2.5)
        let value = Half(6.7)

        XCTAssertEqual(Half(_half_add(lhs._value, rhs._value)), 12.5)
        XCTAssertEqual(Half(_half_add(lhs._value, rhs._value)), lhs + rhs)

        XCTAssertEqual(Half(_half_sub(lhs._value, rhs._value)), 7.5)
        XCTAssertEqual(Half(_half_sub(lhs._value, rhs._value)), lhs - rhs)

        XCTAssertEqual(Half(_half_mul(lhs._value, rhs._value)), 25.0)
        XCTAssertEqual(Half(_half_mul(lhs._value, rhs._value)), lhs * rhs)

        XCTAssertEqual(Half(_half_div(lhs._value, rhs._value)), 4.0)
        XCTAssertEqual(Half(_half_div(lhs._value, rhs._value)), lhs / rhs)

        XCTAssertEqual(Half(_half_fma(value._value, lhs._value, rhs._value)), 31.7)
        XCTAssertEqual(Half(_half_fma(value._value, lhs._value, rhs._value)), value.addingProduct(lhs, rhs))
    }

    func testMiscellaneousFunctions() {
        let half = Half(-9.0)

        XCTAssertEqual(Half(_half_neg(half._value)), 9.0)
        XCTAssertEqual(Half(_half_neg(half._value)), -half)

        XCTAssertEqual(Half(_half_abs(half._value)), 9.0)
        XCTAssertEqual(Half(_half_abs(half._value)), half.magnitude)
        XCTAssertEqual(Half(_half_abs(half._value)), abs(half))

        XCTAssertEqual(Half(_half_sqrt(abs(half)._value)), 3.0)
        XCTAssertEqual(Half(_half_sqrt(abs(half)._value)), abs(half).squareRoot())
        XCTAssertEqual(Half(_half_sqrt(abs(half)._value)), sqrt(abs(half)))
    }

    func testLogicFunctions() {
        let value1 = Half(4.9)
        let value2 = Half(6.7)
        let value3 = Half(4.9)

        XCTAssertFalse(_half_equal(value1._value, value2._value))
        XCTAssertTrue(_half_lt(value1._value, value2._value))
        XCTAssertFalse(_half_gt(value1._value, value2._value))
        XCTAssertTrue(_half_lte(value1._value, value2._value))
        XCTAssertFalse(_half_gte(value1._value, value2._value))

        XCTAssertFalse(_half_equal(value2._value, value3._value))
        XCTAssertFalse(_half_lt(value2._value, value3._value))
        XCTAssertTrue(_half_gt(value2._value, value3._value))
        XCTAssertFalse(_half_lte(value2._value, value3._value))
        XCTAssertTrue(_half_gte(value2._value, value3._value))

        XCTAssertTrue(_half_equal(value3._value, value1._value))
        XCTAssertFalse(_half_lt(value3._value, value1._value))
        XCTAssertFalse(_half_gt(value3._value, value1._value))
        XCTAssertTrue(_half_lte(value3._value, value1._value))
        XCTAssertTrue(_half_gte(value3._value, value1._value))
    }
}
