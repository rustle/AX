//
//  AXValue.swift
//
//  Copyright © 2017-2022 Doug Russell. All rights reserved.
//

import ApplicationServices
import Cocoa

@available(macOS 10.11, *)
public enum Value: Equatable, Sendable {
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
            var point: CGPoint = .zero
            try value.get(&point)
            self = .point(point)
        case .cgSize:
            var size: CGSize = .zero
            try value.get(&size)
            self = .size(size)
        case .cgRect:
            var rect: CGRect = .zero
            try value.get(&rect)
            self = .rect(rect)
        case .cfRange:
            var range: CFRange = .init(
                location: kCFNotFound,
                length: 0
            )
            try value.get(&range)
            guard range.location <= (range.location+range.length) else {
                throw AXError.failure
            }
            self = .range(range.location..<range.location+range.length)
        case .axError:
            var axError: ApplicationServices.AXError = .success
            try value.get(&axError)
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
    func get(
        _ result: inout CGPoint
    ) throws {
        guard AXValueGetValue(
            self,
            .cgPoint,
            &result
        ) else {
            throw AXError.failure
        }
    }
    func get() throws -> CGPoint {
        var result: CGPoint = .zero
        guard AXValueGetValue(
            self,
            .cgPoint,
            &result
        ) else {
            throw AXError.failure
        }
        return result
    }
    func get(
        _ result: inout CGSize
    ) throws {
        guard AXValueGetValue(
            self,
            .cgSize,
            &result
        ) else {
            throw AXError.failure
        }
    }
    func get() throws -> CGSize {
        var result: CGSize = .zero
        guard AXValueGetValue(
            self,
            .cgSize,
            &result
        ) else {
            throw AXError.failure
        }
        return result
    }
    func get(
        _ result: inout CGRect
    ) throws {
        guard AXValueGetValue(
            self,
            .cgRect,
            &result
        ) else {
            throw AXError.failure
        }
    }
    func get() throws {
        var result: CGRect = .zero
        guard AXValueGetValue(
            self,
            .cgRect,
            &result
        ) else {
            throw AXError.failure
        }
    }
    func get(
        _ result: inout ApplicationServices.AXError
    ) throws {
        guard AXValueGetValue(
            self,
            .axError,
            &result
        ) else {
            throw AXError.failure
        }
    }
    func get() throws -> ApplicationServices.AXError {
        var result: ApplicationServices.AXError = .success
        guard AXValueGetValue(
            self,
            .axError,
            &result
        ) else {
            throw AXError.failure
        }
        return result
    }
    func get(
        _ result: inout CFRange
    ) throws {
        guard AXValueGetValue(
            self,
            .cfRange,
            &result
        ) else {
            throw AXError.failure
        }
    }
    func get() throws -> CFRange {
        var result: CFRange = .init(
            location: kCFNotFound,
            length: 0
        )
        guard AXValueGetValue(
            self,
            .cfRange,
            &result
        ) else {
            throw AXError.failure
        }
        return result
    }
}
