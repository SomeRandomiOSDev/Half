//
//  Half+Coding.swift
//  Half
//
//  Copyright © 2020 SomeRandomiOSDev. All rights reserved.
//

import Foundation

// MARK: - Codable Protocol Conformance

extension Half: Codable {

    @_transparent
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let float = try container.decode(Float.self)

        guard float.isInfinite || float.isNaN || abs(float) <= Float(Half.greatestFiniteMagnitude) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Parsed number \(float) does not fit in \(type(of: self))."))
        }

        self.init(float)
    }

    @_transparent
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(Float(self))
    }
}
