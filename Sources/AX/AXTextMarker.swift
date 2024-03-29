//
//  AXTextMarker.swift
//
//  Copyright © 2017-2022 Doug Russell. All rights reserved.
//

import ApplicationServices
import Cocoa

@available(macOS 11, *)
public struct TextMarker: @unchecked Sendable, CustomStringConvertible, CustomDebugStringConvertible {

    // MARK: Init

    public let textMarker: AXTextMarker
    public init(textMarker: AXTextMarker) {
        self.textMarker = textMarker
    }

    public init(data: Data) throws {
        guard data.count > 0 else {
            throw AXError.illegalArgument
        }
        textMarker = data.withUnsafeBytes { buffer in
            AXTextMarkerCreate(
                kCFAllocatorDefault,
                buffer.bindMemory(to: UInt8.self).baseAddress!,
                buffer.count
            )
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
        try body(UnsafeRawBufferPointer(
            start: AXTextMarkerGetBytePtr(textMarker),
            count: AXTextMarkerGetLength(textMarker)
        ))
    }
}

@available(macOS 11, *)
public struct TextMarkerRange: @unchecked Sendable, CustomStringConvertible, CustomDebugStringConvertible {

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
    public init(
        lowerBound: TextMarker,
        upperBound: TextMarker
    ) {
        textMarkerRange = AXTextMarkerRangeCreate(
            kCFAllocatorDefault,
            lowerBound.textMarker,
            upperBound.textMarker
        )
    }
    public init(
        lowerBound: Data,
        upperBound: Data
    ) throws {
        guard lowerBound.count > 0, upperBound.count > 0 else {
            throw AXError.illegalArgument
        }
        textMarkerRange = lowerBound.withUnsafeBytes { lowerData -> AXTextMarkerRange in
            upperBound.withUnsafeBytes { upperData -> AXTextMarkerRange in
                AXTextMarkerRangeCreateWithBytes(
                    kCFAllocatorDefault,
                    lowerData.bindMemory(to: UInt8.self).baseAddress!,
                    lowerData.count,
                    upperData.bindMemory(to: UInt8.self).baseAddress!,
                    upperData.count
                )
            }
        }
    }

    // MARK: Utility

    public var debugDescription: String {
        String(describing: textMarkerRange)
    }
    public var description: String {
        debugDescription
    }
}

@available(macOS 11, *)
extension TextMarker: ReferenceConvertible {
    public final class ReferenceType: NSObject, NSCopying {
        public func copy(with zone: NSZone? = nil) -> Any {
            self
        }
    }
    public typealias _ObjectiveCType = AXTextMarker
    public func _bridgeToObjectiveC() -> _ObjectiveCType {
        textMarker
    }
    public static func _forceBridgeFromObjectiveC(
        _ source: _ObjectiveCType,
        result: inout TextMarker?
    ) {
        result = .init(textMarker: source)
    }
    public static func _conditionallyBridgeFromObjectiveC(
        _ source: _ObjectiveCType,
        result: inout TextMarker?
    ) -> Bool {
        guard CFGetTypeID(source) == AXTextMarkerGetTypeID() else { return false }
        result = .init(textMarker: source)
        return true
    }
    public static func _unconditionallyBridgeFromObjectiveC(_ source: _ObjectiveCType?) -> TextMarker {
        .init(textMarker: source!)
    }
}

@available(macOS 11, *)
extension TextMarkerRange: ReferenceConvertible {
    public final class ReferenceType: NSObject, NSCopying {
        public func copy(with zone: NSZone? = nil) -> Any {
            self
        }
    }
    public typealias _ObjectiveCType = AXTextMarkerRange
    public func _bridgeToObjectiveC() -> _ObjectiveCType {
        textMarkerRange
    }
    public static func _forceBridgeFromObjectiveC(
        _ source: _ObjectiveCType,
        result: inout TextMarkerRange?
    ) {
        result = .init(textMarkerRange: source)
    }
    public static func _conditionallyBridgeFromObjectiveC(
        _ source: _ObjectiveCType,
        result: inout TextMarkerRange?
    ) -> Bool {
        guard CFGetTypeID(source) == AXTextMarkerRangeGetTypeID() else { return false }
        result = .init(textMarkerRange: source)
        return true
    }
    public static func _unconditionallyBridgeFromObjectiveC(_ source: _ObjectiveCType?) -> TextMarkerRange {
        .init(textMarkerRange: source!)
    }
}
