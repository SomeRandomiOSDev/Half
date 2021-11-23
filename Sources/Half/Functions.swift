//
//  Functions.swift
//  Half
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

#if os(Linux)
import Glibc
#else
import Darwin
#endif

// Implmentation of public functions found in swift/stdlib/public/Platform for Half precision.
//
// For the sake of simplicity, we'll implement these functions by casting up the
// input to a Float, call the corresponding overload of the function and down cast
// the result back to a Half.

/// The standard libary arccosine function.
@_transparent
public func acos(_ value: Half) -> Half {
    return Half(acos(Float(value)))
}

/// The standard libary hyperbolic arccosine function.
@_transparent
public func acosh(_ value: Half) -> Half {
    return Half(acosh(Float(value)))
}

/// The standard libary arcsine function.
@_transparent
public func asin(_ value: Half) -> Half {
    return Half(asin(Float(value)))
}

/// The standard libary hyperbolic arcsine function.
@_transparent
public func asinh(_ value: Half) -> Half {
    return Half(asinh(Float(value)))
}

/// The standard libary arctangent function.
@_transparent
public func atan(_ value: Half) -> Half {
    return Half(atan(Float(value)))
}

/// The standard libary hyperbolic arctangent function.
@_transparent
public func atanh(_ value: Half) -> Half {
    return Half(atanh(Float(value)))
}

/// The standard library cube root function.
@_transparent
public func cbrt(_ value: Half) -> Half {
    return Half(cbrt(Float(value)))
}

/// The standard library cosine function.
@_transparent
public func cos(_ value: Half) -> Half {
    return Half(cos(Float(value)))
}

/// The standard library hyperbolic cosine function.
@_transparent
public func cosh(_ value: Half) -> Half {
    return Half(cosh(Float(value)))
}

/// The standard library error function value function.
@_transparent
public func erf(_ value: Half) -> Half {
    return Half(erf(Float(value)))
}

/// The standard library complementary error function value function.
@_transparent
public func erfc(_ value: Half) -> Half {
    return Half(erfc(Float(value)))
}

/// The standard library exponent function (base `e`).
@_transparent
public func exp(_ value: Half) -> Half {
    return Half(exp(Float(value)))
}

/// The standard library exponent function (base `2`).
@_transparent
public func exp2(_ value: Half) -> Half {
    return Half(exp2(Float(value)))
}

/// The standard library exponent minus one function (base `e`).
@_transparent
public func expm1(_ value: Half) -> Half {
    return Half(expm1(Float(value)))
}

/// The standard library natural logarithm function (base `e`).
@_transparent
public func log(_ value: Half) -> Half {
    return Half(log(Float(value)))
}

/// The standard library logarithm function (base `10`).
@_transparent
public func log10(_ value: Half) -> Half {
    return Half(log10(Float(value)))
}

/// The standard library natural logarithm plus one function (base `e`).
@_transparent
public func log1p(_ value: Half) -> Half {
    return Half(log1p(Float(value)))
}

/// The standard library logarithm function (base `2`).
@_transparent
public func log2(_ value: Half) -> Half {
    return Half(log2(Float(value)))
}

/// The standard library absolute value logarithm function (base ``Half/Half/radix``).
@_transparent
public func logb(_ value: Half) -> Half {
    return Half(logb(Float(value)))
}
/// The standard library round to integer function.
@_transparent
public func nearbyint(_ value: Half) -> Half {
    return Half(nearbyint(Float(value)))
}

/// The standard library round to integer function.
@_transparent
public func rint(_ value: Half) -> Half {
    return Half(rint(Float(value)))
}

/// The standard library sine function.
@_transparent
public func sin(_ value: Half) -> Half {
    return Half(sin(Float(value)))
}

/// The standard library hyperbolic sine function.
@_transparent
public func sinh(_ value: Half) -> Half {
    return Half(sinh(Float(value)))
}

/// The standard library tangent function.
@_transparent
public func tan(_ value: Half) -> Half {
    return Half(tan(Float(value)))
}

/// The standard library hyperbolic tangent function.
@_transparent
public func tanh(_ value: Half) -> Half {
    return Half(tanh(Float(value)))
}

/// The standard library gamma function.
@_transparent
public func tgamma(_ value: Half) -> Half {
    return Half(tgamma(Float(value)))
}

//

/// The standard library arctangent (2) function.
@_transparent
public func atan2(_ lhs: Half, _ rhs: Half) -> Half {
    return Half(atan2(Float(lhs), Float(rhs)))
}

/// The standard library copy sign function.
@_transparent
public func copysign(_ lhs: Half, _ rhs: Half) -> Half {
    return Half(copysign(Float(lhs), Float(rhs)))
}

/// The standard library positive difference function.
@_transparent
public func fdim(_ lhs: Half, _ rhs: Half) -> Half {
    return Half(fdim(Float(lhs), Float(rhs)))
}

/// The standard library floating-point maximum function.
@_transparent
public func fmax(_ lhs: Half, _ rhs: Half) -> Half {
    return Half(fmax(Float(lhs), Float(rhs)))
}

/// The standard library floating-point minium function.
@_transparent
public func fmin(_ lhs: Half, _ rhs: Half) -> Half {
    return Half(fmin(Float(lhs), Float(rhs)))
}

/// The standard library hypotenuse function.
@_transparent
public func hypot(_ lhs: Half, _ rhs: Half) -> Half {
    return Half(hypot(Float(lhs), Float(rhs)))
}

/// The standard library next after function.
@_transparent
public func nextafter(_ lhs: Half, _ rhs: Half) -> Half {
    return Half(nextafter(Float(lhs), Float(rhs)))
}

/// The standard library power (exponentiation) function.
@_transparent
public func pow(_ lhs: Half, _ rhs: Half) -> Half {
    return Half(pow(Float(lhs), Float(rhs)))
}

//

/// The standard library natural log gamma function.
@_transparent
public func lgamma(_ value: Half) -> (Half, Int) {
    let result = lgamma(Float(value))
    return (Half(result.0), result.1)
}

/// The standard library remainder & quotient function.
@_transparent
public func remquo(_ lhs: Half, _ rhs: Half) -> (Half, Int) {
    let result = remquo(Float(lhs), Float(rhs))
    return (Half(result.0), result.1)
}
