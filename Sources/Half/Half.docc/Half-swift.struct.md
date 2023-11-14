# ``Half/Half``

## Topics

### Converting Integers

- ``init(_:)-7kco9``
- ``init(_:)-7dq13``

### Converting Floating-Point Values

- ``init(_:)-8pz9d``
- ``init(_:)-303gr``
- ``init(_:)-27j5y``
- ``init(_:)-sx6z``
- ``init(_:)-7en2n``
- ``init(_:)-7dq13``
- ``init(sign:exponent:significand:)``
- ``init(signOf:magnitudeOf:)``
- ``init(_:)-5317f``

### Converting with No Loss of Precision

These initializers result in `nil` if the value passed can't be represented without any loss of precision.

- ``init(exactly:)-6m48t``
- ``init(exactly:)-5u1uj``
- ``init(exactly:)-7zp1d``
- ``init(exactly:)-39lxr``

### Creating a Random Value

- ``random(in:)-6g8g9``
- ``random(in:using:)-1aafi``
- ``random(in:)-1292g``
- ``random(in:using:)-5lebz``

### Performing Calculations

- <doc:Floating-Point-Operators-for-Half>

- ``addingProduct(_:_:)``
- ``addProduct(_:_:)``
- ``squareRoot()``
- ``formSquareRoot()``
- ``remainder(dividingBy:)``
- ``formRemainder(dividingBy:)``
- ``truncatingRemainder(dividingBy:)``
- ``formTruncatingRemainder(dividingBy:)``
- ``negate()-87nlz``

### Rounding Values

- ``rounded()``
- ``rounded(_:)``
- ``round()``
- ``round(_:)``

### Comparing Values

- <doc:Floating-Point-Operators-for-Half>

- ``isEqual(to:)``
- ``isLess(than:)``
- ``isLessThanOrEqualTo(_:)``
- ``isTotallyOrdered(belowOrEqualTo:)``
- ``minimum(_:_:)``
- ``minimumMagnitude(_:_:)``
- ``maximum(_:_:)``
- ``maximumMagnitude(_:_:)``

### Finding the Sign and Magnitude

- ``magnitude``
- ``sign``

### Querying a Half

- ``ulp``
- ``significand``
- ``exponent``
- ``nextUp``
- ``nextDown``
- ``binade``

### Accessing Numeric Constants

- ``pi``
- ``infinity``
- ``greatestFiniteMagnitude``
- ``nan``
- ``signalingNaN``
- ``ulpOfOne-7ie3h``
- ``leastNonzeroMagnitude``
- ``leastNormalMagnitude``
- ``zero``

### Working with Binary Representation

- ``bitPattern``
- ``significandBitPattern``
- ``significandWidth``
- ``exponentBitPattern``
- ``significandBitCount``
- ``exponentBitCount``
- ``radix``
- ``init(bitPattern:)``
- ``init(sign:exponentBitPattern:significandBitPattern:)``
- ``init(nan:signaling:)``

### Querying a Half's State

- ``isZero``
- ``isFinite``
- ``isInfinite``
- ``isNaN``
- ``isSignalingNaN``
- ``isNormal``
- ``isSubnormal``
- ``isCanonical``
- ``floatingPointClass``

### Encoding and Decoding Values

- ``encode(to:)``
- ``init(from:)``

### Creating a Range

- ``..<(_:_:)``
- ``...(_:_:)``

### Describing a Half

- ``description``
- ``debugDescription``
- ``customMirror``
- ``hash(into:)``

### Infrequently Used Functionality

- ``init()``
- ``init(floatLiteral:)``
- ``init(integerLiteral:)``
- ``advanced(by:)``
- ``distance(to:)``
- ``write(to:)``
- ``hashValue``

<!-- Copyright (c) 2023 SomeRandomiOSDev. All Rights Reserved. -->
