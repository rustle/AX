//
//  AXError.swift
//
//  Copyright © 2017-2021 Doug Russell. All rights reserved.
//

import ApplicationServices.HIServices

// It would be nice to just have AXError conform to Swift.Error
// but we want to drop the `success` case

@available(macOS 10.2, *)
public enum Error: Swift.Error {
    /// The action is not supported by the UIElement.
    case actionUnsupported
    /// The accessibility API is disabled.
    ///
    /// See also `isTrusted(promptIfNeeded:)`
    case apiDisabled
    /// The attribute is not supported by the UIElement.
    case attributeUnsupported
    /// The parameterized attribute is not supported by the UIElement.
    case parameterizedAttributeUnsupported
    /// The function cannot complete because messaging failed in some way or because the application with which the function is communicating is busy or unresponsive.
    case cannotComplete
    /// A system error occurred, such as the failure to allocate an object.
    case failure
    /// An illegal argument was passed to the function.
    case illegalArgument
    ///  The AXUIElementRef passed to the function is invalid.
    case invalidUIElement
    /// The Observer passed to the function is not a valid observer.
    case invalidUIElementObserver
    /// Not enough precision.
    case notEnoughPrecision
    /// This notification has already been registered.
    case notificationAlreadyRegistered
    /// The notification is not supported by the UIElement
    case notificationUnsupported
    /// Indicates that the function or method is not implemented (this can be returned if a process does not support the accessibility API).
    case notImplemented
    /// Indicates that a notification is not registered yet.
    case notificationNotRegistered
    /// The requested value or UIElement does not exist.
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
            throw Error.cannotComplete
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
        guard let error = Error(error: self) else {
            return
        }
        throw error
    }
}
