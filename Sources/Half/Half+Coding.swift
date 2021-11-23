//
//  Half+Coding.swift
//  Half
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

// MARK: - Codable Protocol Conformance

extension Half: Codable {

    /**
     Creates a new instance by decoding from the given decoder.

     The way in which `Half` decodes itself is by first decoding the next largest
     floating-point type that conforms to `Decodable` and then attempting to cast it
     down to `Half`. This initializer throws an error if reading from the decoder
     fails, if the data read is corrupted or otherwise invalid, or if the decoded
     floating-point value is too large to fit in a `Half` type.

     - Parameters:
       - decoder: The decoder to read data from.
     */
    @_transparent
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let float = try container.decode(Float.self)

        guard float.isInfinite || float.isNaN || abs(float) <= Float(Half.greatestFiniteMagnitude) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Parsed number \(float) does not fit in \(type(of: self))."))
        }

        self.init(float)
    }

    /**
     Encodes this value into the given encoder.

     The way in which `Half` encodes itself is by first prompting itself to the next
     largest floating-point type that conforms to `Encodable` and encoding that value
     to the encoder. This function throws an error if any values are invalid for the
     given encoder’s format.

     - Parameters:
       - encoder: The encoder to write data to.

     - Note: This documentation comment was copied from `Double`.
     */
    @_transparent
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(Float(self))
    }
}
