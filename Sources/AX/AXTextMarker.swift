//
//  AXTextMarker.swift
//
//  Copyright © 2017-2021 Doug Russell. All rights reserved.
//

import Cocoa

@available(macOS 10.0, *)
public extension 🪓 {
    @available(macOS 12, *)
    struct TextMarker: CustomStringConvertible, CustomDebugStringConvertible {

        // MARK: Init

        public let textMarker: AXTextMarker
        public init(textMarker: AXTextMarker) {
            self.textMarker = textMarker
        }

        public init(data: Data) throws {
            guard data.count > 0 else {
                throw 🪓.Error.illegalArgument
            }
            textMarker = data.withUnsafeBytes { buffer in
                AXTextMarkerCreate(kCFAllocatorDefault,
                                   buffer.bindMemory(to: UInt8.self).baseAddress!,
                                   buffer.count)
            }
        }

        // MARK: Utility

        public var debugDescription: String {
            String(describing: textMarker)
        }
        public var description: String {
            debugDescription
        }

        // MARK: Data

        @inlinable
        public func withUnsafeBytes<ResultType>(_ body: (UnsafeRawBufferPointer) throws -> ResultType) rethrows -> ResultType {
            try body(UnsafeRawBufferPointer(start: AXTextMarkerGetBytePtr(textMarker),
                                            count: AXTextMarkerGetLength(textMarker)))
        }
    }

    @available(macOS 12, *)
    struct TextMarkerRange {

        // MARK: Init

        public let textMarkerRange: AXTextMarkerRange
        public var lowerBound: TextMarker {
            TextMarker(textMarker: AXTextMarkerRangeCopyStartMarker(textMarkerRange))
        }
        public var upperBound: TextMarker {
            TextMarker(textMarker: AXTextMarkerRangeCopyEndMarker(textMarkerRange))
        }
        public init(textMarkerRange: AXTextMarkerRange) {
            self.textMarkerRange = textMarkerRange
        }
        public init(lowerBound: TextMarker,
                    upperBound: TextMarker) {
            textMarkerRange = AXTextMarkerRangeCreate(kCFAllocatorDefault,
                                                      lowerBound.textMarker,
                                                      upperBound.textMarker)
        }
        public init(lowerBound: Data,
                    upperBound: Data) throws {
            guard lowerBound.count > 0, upperBound.count > 0 else {
                throw 🪓.Error.illegalArgument
            }
            textMarkerRange = lowerBound.withUnsafeBytes { lowerData -> AXTextMarkerRange in
                upperBound.withUnsafeBytes { upperData -> AXTextMarkerRange in
                    AXTextMarkerRangeCreateWithBytes(kCFAllocatorDefault,
                                                     lowerData.bindMemory(to: UInt8.self).baseAddress!,
                                                     lowerData.count,
                                                     upperData.bindMemory(to: UInt8.self).baseAddress!,
                                                     upperData.count)
                }
            }
        }
    }
}
