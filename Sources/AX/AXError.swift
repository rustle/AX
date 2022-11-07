//
//  AXError.swift
//
//  Copyright © 2017-2022 Doug Russell. All rights reserved.
//

import ApplicationServices.HIServices

// It would be nice to just have ApplicationServices.AXError conform to Swift.Error
// but we want to drop the `success` case

@available(macOS 10.2, *)
public enum AXError: Error {
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
    ///  The UIElement passed to the function is invalid.
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
    public var error: ApplicationServices.AXError {
        switch self {
        case .actionUnsupported:
            return .actionUnsupported
        case .apiDisabled:
            return .apiDisabled
        case .attributeUnsupported:
            return .attributeUnsupported
        case .parameterizedAttributeUnsupported:
            return .parameterizedAttributeUnsupported
        case .cannotComplete:
            return .cannotComplete
        case .failure:
            return .failure
        case .illegalArgument:
            return .illegalArgument
        case .invalidUIElement:
            return .invalidUIElement
        case .invalidUIElementObserver:
            return .invalidUIElementObserver
        case .notEnoughPrecision:
            return .notEnoughPrecision
        case .notificationAlreadyRegistered:
            return .notificationAlreadyRegistered
        case .notificationUnsupported:
            return .notificationUnsupported
        case .notImplemented:
            return .notImplemented
        case .notificationNotRegistered:
            return .notificationNotRegistered
        case .noValue:
            return .noValue
        }
    }
    public init?(error: ApplicationServices.AXError) {
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
    public var localizedDescription: String {
        switch self {
        case .actionUnsupported:
            return "AX.AXError.actionUnsupported - The action is not supported by the UIElement."
        case .apiDisabled:
            return "AX.AXError.apiDisabled - The accessibility API is disabled."
        case .attributeUnsupported:
            return "AX.AXError.attributeUnsupported - The attribute is not supported by the UIElement."
        case .parameterizedAttributeUnsupported:
            return "AX.AXError.parameterizedAttributeUnsupported - The parameterized attribute is not supported by the UIElement."
        case .cannotComplete:
            return "AX.AXError.cannotComplete - The function cannot complete because messaging failed in some way or because the application with which the function is communicating is busy or unresponsive."
        case .failure:
            return "AX.AXError.failure - A system error occurred, such as the failure to allocate an object."
        case .illegalArgument:
            return "AX.AXError.illegalArgument - An illegal argument was passed to the function."
        case .invalidUIElement:
            return "AX.AXError.invalidUIElement - The UIElement passed to the function is invalid."
        case .invalidUIElementObserver:
            return "AX.AXError.invalidUIElementObserver - The Observer passed to the function is not a valid observer."
        case .notEnoughPrecision:
            return "AX.AXError.notEnoughPrecision - Not enough precision."
        case .notificationAlreadyRegistered:
            return "AX.AXError.notificationAlreadyRegistered - This notification has already been registered."
        case .notificationUnsupported:
            return "AX.AXError.notificationUnsupported - The notification is not supported by the UIElement"
        case .notImplemented:
            return "AX.AXError.notImplemented - Indicates that the function or method is not implemented (this can be returned if a process does not support the accessibility API)."
        case .notificationNotRegistered:
            return "AX.AXError.notificationNotRegistered"
        case .noValue:
            return "AX.AXError.noValue - The requested value or UIElement does not exist."
        }
    }
}

@available(macOS 10.2, *)
public extension ApplicationServices.AXError {
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
            throw AXError.cannotComplete
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
        guard let error = AXError(error: self) else {
            return
        }
        throw error
    }
}
