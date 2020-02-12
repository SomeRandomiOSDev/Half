//
//  Functions.swift
//  Half
//
//  Copyright © 2020 SomeRandomiOSDev. All rights reserved.
//

import Foundation

// Implmentation of public functions found in swift/stdlib/public/Platform for Half precision.
//
// For the sake of simplicity, we'll implement these functions by casting up the
// input to a Float, call the corresponding overload of the function and down cast
// the result back to a Half.

@_transparent
public func acos(_ value: Half) -> Half {
    return Half(acos(Float(value)))
}

@_transparent
public func acosh(_ value: Half) -> Half {
    return Half(acosh(Float(value)))
}

@_transparent
public func asin(_ value: Half) -> Half {
    return Half(asin(Float(value)))
}

@_transparent
public func asinh(_ value: Half) -> Half {
    return Half(asinh(Float(value)))
}

@_transparent
public func atan(_ value: Half) -> Half {
    return Half(atan(Float(value)))
}

@_transparent
public func atanh(_ value: Half) -> Half {
    return Half(atanh(Float(value)))
}

@_transparent
public func cbrt(_ value: Half) -> Half {
    return Half(cbrt(Float(value)))
}

@_transparent
public func cos(_ value: Half) -> Half {
    return Half(cos(Float(value)))
}

@_transparent
public func cosh(_ value: Half) -> Half {
    return Half(cosh(Float(value)))
}

@_transparent
public func erf(_ value: Half) -> Half {
    return Half(erf(Float(value)))
}

@_transparent
public func erfc(_ value: Half) -> Half {
    return Half(erfc(Float(value)))
}

@_transparent
public func exp(_ value: Half) -> Half {
    return Half(exp(Float(value)))
}

@_transparent
public func exp2(_ value: Half) -> Half {
    return Half(exp2(Float(value)))
}

@_transparent
public func expm1(_ value: Half) -> Half {
    return Half(expm1(Float(value)))
}

@_transparent
public func log(_ value: Half) -> Half {
    return Half(log(Float(value)))
}

@_transparent
public func log10(_ value: Half) -> Half {
    return Half(log10(Float(value)))
}

@_transparent
public func log1p(_ value: Half) -> Half {
    return Half(log1p(Float(value)))
}

@_transparent
public func log2(_ value: Half) -> Half {
    return Half(log2(Float(value)))
}

@_transparent
public func logb(_ value: Half) -> Half {
    return Half(logb(Float(value)))
}

@_transparent
public func nearbyint(_ value: Half) -> Half {
    return Half(nearbyint(Float(value)))
}

@_transparent
public func rint(_ value: Half) -> Half {
    return Half(rint(Float(value)))
}

@_transparent
public func sin(_ value: Half) -> Half {
    return Half(sin(Float(value)))
}

@_transparent
public func sinh(_ value: Half) -> Half {
    return Half(sinh(Float(value)))
}

@_transparent
public func tan(_ value: Half) -> Half {
    return Half(tan(Float(value)))
}

@_transparent
public func tanh(_ value: Half) -> Half {
    return Half(tanh(Float(value)))
}

@_transparent
public func tgamma(_ value: Half) -> Half {
    return Half(tgamma(Float(value)))
}

//

@_transparent
public func atan2(_ lhs: Half, _ rhs: Half) -> Half {
    return Half(atan2(Float(lhs), Float(rhs)))
}

@_transparent
public func copysign(_ lhs: Half, _ rhs: Half) -> Half {
    return Half(copysign(Float(lhs), Float(rhs)))
}

@_transparent
public func fdim(_ lhs: Half, _ rhs: Half) -> Half {
    return Half(fdim(Float(lhs), Float(rhs)))
}

@_transparent
public func fmax(_ lhs: Half, _ rhs: Half) -> Half {
    return Half(fmax(Float(lhs), Float(rhs)))
}

@_transparent
public func fmin(_ lhs: Half, _ rhs: Half) -> Half {
    return Half(fmin(Float(lhs), Float(rhs)))
}

@_transparent
public func hypot(_ lhs: Half, _ rhs: Half) -> Half {
    return Half(hypot(Float(lhs), Float(rhs)))
}

@_transparent
public func nextafter(_ lhs: Half, _ rhs: Half) -> Half {
    return Half(nextafter(Float(lhs), Float(rhs)))
}

@_transparent
public func pow(_ lhs: Half, _ rhs: Half) -> Half {
    return Half(pow(Float(lhs), Float(rhs)))
}

//

@_transparent
public func lgamma(_ value: Half) -> (Half, Int) {
    let result = lgamma(Float(value))
    return (Half(result.0), result.1)
}

@_transparent
public func remquo(_ lhs: Half, _ rhs: Half) -> (Half, Int) {
    let result = remquo(Float(lhs), Float(rhs))
    return (Half(result.0), result.1)
}
