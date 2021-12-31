//
//  AXError.swift
//
//  Copyright © 2017-2021 Doug Russell. All rights reserved.
//

import ApplicationServices.HIServices

// It would be nice to just have AXError conform to Swift.Error
// but we want to drop the `success` case

@available(macOS 10.0, *)
public extension 🪓 {
    @available(macOS 10.2, *)
    enum Error: Swift.Error {
        case actionUnsupported
        case apiDisabled
        case attributeUnsupported
        case parameterizedAttributeUnsupported
        case cannotComplete
        case failure
        case illegalArgument
        case invalidUIElement
        case invalidUIElementObserver
        case notEnoughPrecision
        case notificationAlreadyRegistered
        case notificationUnsupported
        case notImplemented
        case notificationNotRegistered
        case noValue
    }
}

@available(macOS 10.2, *)
public extension AXError {
    /// If `result == .success` force unwrap `value`
    /// If `result` is a known error convert it
    @inlinable
    func check<V>(_ value: V?) throws -> V {
        try check()
        return value!
    }

    /// If `result == .success` nop
    /// If `result` is a known error convert it
    @inlinable
    func check() throws {
        switch self {
        case .success:
            return
        case .actionUnsupported:
            throw 🪓.Error.actionUnsupported
        case .apiDisabled:
            throw 🪓.Error.apiDisabled
        case .attributeUnsupported:
            throw 🪓.Error.attributeUnsupported
        case .cannotComplete:
            throw 🪓.Error.cannotComplete
        case .failure:
            throw 🪓.Error.failure
        case .illegalArgument:
            throw 🪓.Error.illegalArgument
        case .invalidUIElement:
            throw 🪓.Error.invalidUIElement
        case .invalidUIElementObserver:
            throw 🪓.Error.invalidUIElementObserver
        case .notEnoughPrecision:
            throw 🪓.Error.notEnoughPrecision
        case .notificationAlreadyRegistered:
            throw 🪓.Error.notificationAlreadyRegistered
        case .notificationUnsupported:
            throw 🪓.Error.notificationUnsupported
        case .notImplemented:
            throw 🪓.Error.notImplemented
        case .notificationNotRegistered:
            throw 🪓.Error.notificationNotRegistered
        case .noValue:
            throw 🪓.Error.noValue
        case .parameterizedAttributeUnsupported:
            throw 🪓.Error.parameterizedAttributeUnsupported
        @unknown default:
            throw 🪓.Error.failure
        }
    }
}
