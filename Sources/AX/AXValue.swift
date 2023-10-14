//
//  AXValue.swift
//
//  Copyright © 2017-2022 Doug Russell. All rights reserved.
//

import ApplicationServices
import Cocoa

@available(macOS 10.11, *)
public enum Value: Equatable {
    case point(CGPoint)
    case size(CGSize)
    case rect(CGRect)
    case range(Range<Int>)
    case error(AXError)

    public var value: AXValue {
        switch self {
        case .point(var point):
            return AXValueCreate(
                .cgPoint,
                &point
            )!
        case .size(var size):
            return AXValueCreate(
                .cgSize,
                &size
            )!
        case .rect(var rect):
            return AXValueCreate(
                .cgRect,
                &rect
            )!
        case .range(let range):
            var cfRange = CFRange(
                location: range.lowerBound,
                length: range.upperBound-range.lowerBound
            )
            return AXValueCreate(
                .cfRange,
                &cfRange
            )!
        case .error(let error):
            var axError = error.error
            return AXValueCreate(
                .axError,
                &axError
            )!
        }
    }

    // MARK: Init

    public init(value: AXValue) throws {
        switch value.type {
        case .cgPoint:
            var point = CGPoint(
                x: 0,
                y: 0
            )
            try value.get(
                .cgPoint,
                &point
            )
            self = .point(point)
        case .cgSize:
            var size = CGSize(
                width: 0,
                height: 0
            )
            try value.get(
                .cgSize,
                &size
            )
            self = .size(size)
        case .cgRect:
            var rect = CGRect(
                x: 0,
                y: 0,
                width: 0,
                height: 0
            )
            try value.get(
                .cgRect,
                &rect
            )
            self = .rect(rect)
        case .cfRange:
            // TODO: Check for NSNotFound/kCFNotFound in location
            var range = CFRange(
                location: kCFNotFound,
                length: 0
            )
            try value.get(
                .cfRange,
                &range
            )
            self = .range(range.location..<range.location+range.length)
        case .axError:
            var axError = ApplicationServices.AXError.success
            try value.get(
                .axError,
                &axError
            )
            guard let error = AXError(error: axError) else {
                throw AXError.failure
            }
            self = .error(error)
        case .illegal:
            fatalError()
        @unknown default:
            throw AXError.failure
        }
    }
}

@available(macOS 10.11, *)
public extension AXValue {
    var type: AXValueType {
        AXValueGetType(self)
    }
    func get<V>(
        _ type: AXValueType,
        _ result: inout V
    ) throws {
        guard AXValueGetValue(
            self,
            type,
            &result
        ) else {
            throw AXError.failure
        }
    }
}
