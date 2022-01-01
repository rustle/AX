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
        public init?(error: AXError) {
            switch error {
            case .success:
                return nil
            case .actionUnsupported:
                self = .actionUnsupported
            case .apiDisabled:
                self = .apiDisabled
            case .attributeUnsupported:
                self = .attributeUnsupported
            case .cannotComplete:
                self = .cannotComplete
            case .failure:
                self = .failure
            case .illegalArgument:
                self = .illegalArgument
            case .invalidUIElement:
                self = .invalidUIElement
            case .invalidUIElementObserver:
                self = .invalidUIElementObserver
            case .notEnoughPrecision:
                self = .notEnoughPrecision
            case .notificationAlreadyRegistered:
                self = .notificationAlreadyRegistered
            case .notificationUnsupported:
                self = .notificationUnsupported
            case .notImplemented:
                self = .notImplemented
            case .notificationNotRegistered:
                self = .notificationNotRegistered
            case .noValue:
                self = .noValue
            case .parameterizedAttributeUnsupported:
                self = .parameterizedAttributeUnsupported
            @unknown default:
                self = .failure
            }
        }
    }
}

@available(macOS 10.2, *)
public extension AXError {
    /// If `result == .success` force unwrap `value`
    /// If `result` is a known error convert it
    @inlinable
    func check(_ value: Any?) throws -> Any {
        try check()
        return value!
    }
    /// If `result == .success` force unwrap `value`
    /// If `result` is a known error convert it
    @inlinable
    func check<V>(_ value: Any?) throws -> V {
        try check()
        guard let checked = value as? V else {
            throw 🪓.Error.cannotComplete
        }
        return checked
    }
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
        guard let error = 🪓.Error(error: self) else {
            return
        }
        throw error
    }
}
